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

	public function print(Request $request, $id)
	{
		$transaction = $this->transaction->getOne($id);

		$bayar = request()->bayar;

		$pdf = PDF::loadView('transaction.print', compact('transaction', 'bayar'));
		$pdf->setPaper(array(0, 0, 211, 700));

		return $pdf->stream();
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
