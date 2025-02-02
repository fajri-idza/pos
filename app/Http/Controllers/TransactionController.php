<?php

namespace App\Http\Controllers;

use App\Services\{TransactionService, DetailTransactionService};
use App\Repositories\UserRepository;
use App\Exports\{TransactionExport, DetailTransactionExport};
use App\Imports\{TransactionImport, DetailTransactionImport};
use App\Http\Requests\Transaction\ImportTransactionRequest;

use Illuminate\View\View;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Mike42\Escpos\Printer;
use Mike42\Escpos\EscposImage;

use Mike42\Escpos\PrintConnectors\WindowsPrintConnector;
use Mike42\Escpos\PrintConnectors\FilePrintConnector;
use Mike42\Escpos\PrintConnectors\NetworkPrintConnector;

use PDF;

class TransactionController extends Controller
{
	protected $transaction;

	public function __construct(TransactionService $transaction)
	{
		$this->transaction = $transaction;
	}

	public function index(UserRepository $userRepo): View
	{
		$user = $userRepo->getKasir();

		return view('transaction.index', compact('user'));
	}

	public function detailTransaction(UserRepository $userRepo): View
	{
		$user = $userRepo->getKasir();

		return view('transaction.detail_transaction', compact('user'));
	}

	public function detail(Request $request, $id): View
	{
		$transaction = $this->transaction->getOne($id);

		return view('transaction.detail', compact('transaction'));
	}

	// public function print(Request $request, $id)
	// {
	// 	$transaction = $this->transaction->getOne($id);

	// 	$bayar = request()->bayar;

	// 	$pdf = PDF::loadView('transaction.print', compact('transaction', 'bayar'));
	// 	$pdf->setPaper(array(0, 0, 211, 700));

	// 	return $pdf->stream();
	// }

    public function print(Request $request, $id)
	{
		$transaction = $this->transaction->getOne($id);

		$bayar = request()->bayar;

        try {
            // **1. Pilih koneksi printer**
            $connector = new WindowsPrintConnector("POS-58"); // Windows
            // $connector = new FilePrintConnector("/dev/usb/lp0"); // Linux
            // $connector = new NetworkPrintConnector("192.168.1.100", 9100); // Jaringan

            $printer = new Printer($connector);

            // **2. Print Logo (Jika ada)**
            // if (site('pakaiLogo')) {
            //     $logoPath = public_path('storage/logo/'.site('logo'));
            //     if (file_exists($logoPath)) {
            //         $logo = EscposImage::load($logoPath);
            //         $printer->graphics($logo); bisa ini
            //         $printer->bitImage($logo); // Cetak gambar dalam mode bit-image
            //     }
            // }

            // **3. Print Header**
            $printer->setJustification(Printer::JUSTIFY_CENTER);
            $printer->setTextSize(2, 2);
            $printer->text(site('nama_toko') . "\n");
			$printer->text("\n");
            $printer->setTextSize(1, 1);
            $printer->text(site('alamat_toko') . "\n");
            $printer->text(site('telepon_toko') . "\n");
            $printer->text("--------------------------------\n");

            // **4. Print Informasi Transaksi**
            $printer->setJustification(Printer::JUSTIFY_LEFT);
            $printer->text("No Faktur : " . $transaction->idPenjualan . "\n");
            $printer->text("Tanggal   : " . date('d/m/y h:i A', strtotime($transaction->tanggal)) . "\n");
            $printer->text("Kasir     : " . $transaction->namaUser . "\n");
            $printer->text("--------------------------------\n");

            // **5. Print Item Transaksi**
            $total = 0;
            $disc = 0;
            foreach ($transaction->detail as $stuff) {
                $subtotal = $stuff->jumlah * $stuff->hargaJual - $stuff->disc;
                $disc += $stuff->disc;
                $total += $subtotal;

                $printer->text($stuff->judul . "\n");
                $printer->text("  " . $stuff->jumlah . " x " . number_format($stuff->hargaJual) . "  Disc: " . number_format($stuff->disc) . "\n");
                $printer->setJustification(Printer::JUSTIFY_RIGHT);
                $printer->text("Rp. " . number_format($subtotal) . "\n");
                $printer->setJustification(Printer::JUSTIFY_LEFT);
            }

            $printer->text("--------------------------------\n");

            // **6. Print Total Harga**
            $printer->setJustification(Printer::JUSTIFY_RIGHT);
            $printer->text("Total    : Rp. " . number_format($total) . "\n");
            $printer->text("PPN      : Rp. " . number_format($transaction->ppn) . "\n");
            $printer->text("Subtotal : Rp. " . number_format($total + $transaction->ppn) . "\n");
            $printer->text("Bayar    : Rp. " . number_format($bayar) . "\n");
            $printer->text("Kembali  : Rp. " . number_format(max($bayar - ($total + $transaction->ppn), 0)) . "\n");

            $printer->text("--------------------------------\n");

            // **7. Print Footer**
            $printer->setJustification(Printer::JUSTIFY_CENTER);
            $printer->text("BKP : " . number_format($total) . "\n");
            $printer->text("DISC: " . number_format($disc) . "\n");
            $printer->text("DPP : " . number_format($total + $transaction->ppn) . "\n");
            $printer->text("PPN : " . number_format($transaction->ppn) . "\n");
            $printer->feed(2);

            $printer->text("Instagram : \n");
            $printer->text("@bengkulu_guitar\n");
            $printer->text("@bengkulupro_audio \n");
            $printer->text("\n");
            $printer->text("Terima Kasih\n");
            $printer->text("Barang yang sudah dibeli\n");
            $printer->text("tidak dapat ditukar atau\n");
			$printer->text("dikembalikan.\n");
            $printer->text("\n");
            $printer->cut();
            $printer->close();

            return redirect()->back()->with('success', 'Struk berhasil dicetak!');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Gagal mencetak: ' . $e->getMessage());
        }
	}

	public function printall(Request $request)
	{
		$request->validate([
			'dari' => 'date|nullable',
			'sampai' => 'date|nullable',
			'status' => 'nullable|boolean',
			'user' => 'nullable|exists:user,idUser'
		]);

		if ($request->filled('status')) {
			$transactions = $this->transaction->filter($request->dari, $request->sampai, $request->status, $request->user);
		} else {
			$transactions = [
				'success' => $this->transaction->filterSuccess($request->dari, $request->sampai, $request->user),
				'cancel' => $this->transaction->filterCancel($request->dari, $request->sampai, $request->user)
			];
		}

		$status = $request->filled('status');

		$pdf = PDF::loadView('transaction.printall', compact('transactions', 'status'));
		$pdf->setPaper('a4');

		return $pdf->stream();
	}

	public function destroy($id): JsonResponse
	{
		$this->transaction->deleteData($id);

		return response()->json(['success' => 'Sukses Menghapus Transaksi']);
	}

	public function cancel($id): JsonResponse
	{
		$this->transaction->cancel($id);

		return response()->json(['success' => 'Sukses Membatalkan Transaksi']);
	}

	public function datatables(Request $request): Object
	{
		$dari = $request->dari;
		$sampai = $request->sampai;
		$user = $request->user;
		$status = $request->status;

		return $this->transaction->getDatatables($dari, $sampai, $status, $user);
	}

	public function detailPrintall(DetailTransactionService $detailTransaction, Request $request)
	{
		$request->validate([
			'dari' => 'date|nullable',
			'sampai' => 'date|nullable',
			'status' => 'nullable|boolean',
			'user' => 'nullable|exists:user,idUser'
		]);

		if ($request->filled('status')) {
			$transactions = $detailTransaction->filter($request->dari, $request->sampai, $request->status, $request->user);
		} else {
			$transactions = [
				'success' => $detailTransaction->filter($request->dari, $request->sampai, true, $request->user),
				'cancel' => $detailTransaction->filter($request->dari, $request->sampai, false, $request->user)
			];
		}

		$status = $request->filled('status');

		$pdf = PDF::loadView('transaction.detail_transaction_printall', compact('transactions', 'status'));
		$pdf->setPaper('a4');

		return $pdf->stream();
	}

	public function detailDatatables(DetailTransactionService $detailTransaction, Request $request): Object
	{
		$dari = $request->dari;
		$sampai = $request->sampai;
		$user = $request->user;
		$status = $request->status;

		return $detailTransaction->datatables($dari, $sampai, $status, $user);
	}

    public function export(TransactionExport $export)
    {
        return $export->download('transaction.xlsx');
    }

    public function detailExport(DetailTransactionExport $export)
    {
        return $export->download('detail_transaction.xlsx');
    }

    public function import(TransactionImport $import, ImportTransactionRequest $request)
    {
        $import->import($request->file);

        $failures = count($import->failures());
        $errors = count($import->errors());

        $res = $import->success.' import berhasil, '.$failures.' error '.$errors.' gagal';

        return response()->json(['success' => $res]);
    }

    public function detailImport(DetailTransactionImport $import, ImportTransactionRequest $request)
    {
        $import->import($request->file);

        $failures = count($import->failures());
        $errors = count($import->errors());

        $res = $import->success.' import berhasil, '.$failures.' error '.$errors.' gagal';

        return response()->json(['success' => $res]);
    }
}
