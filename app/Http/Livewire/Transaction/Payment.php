<?php

namespace App\Http\Livewire\Transaction;

use App\Transaction;
use App\Services\TransactionService;

use Livewire\Component;

class Payment extends Component
{

	public $total;
	public $money;
	public $return;
	public $ppn;
	public $subtotal;
	public $user;
	public $stuffs;
    public $pembeli;

	protected $listeners = [
		'count-total' => 'count',
		'open-payment' => 'open',
        'send-purchaser-data' => 'receivePurchaserData',
	];

	public function open()
	{
		$this->money = 0;
		$this->return = 0;

		$this->resetValidation();
		$this->dispatchBrowserEvent('open-payment');
	}

    public function receivePurchaserData($userData)
    {
        $this->pembeli = $userData;
    }

	public function store(TransactionService $transactionService)
	{
		$this->money = intval(str_replace([',', '.'], '', $this->money));

		$this->validate([
			'money' => 'required|integer|min:'.$this->subtotal
		]);

		$data = [
			'idUser' => $this->user->idUser,
			'namaUser' => $this->user->nama,
            'namaPembeli' => $this->pembeli,
			'total' => $this->subtotal,
			'ppn' => $this->ppn,
			'total_bayar' => $this->money,
			'tanggal' => date('Y-m-d H:i:s')
		];

		$transaction = $transactionService->store($data, $this->stuffs);

		$this->emit('clear-transaction');
        $this->emit('clear-purchaser');
		$this->emit('reset-id');
		$this->emit('open-print', $transaction->idPenjualan, $this->money, $this->return);
		$this->dispatchBrowserEvent('close-payment');
		$this->dispatchBrowserEvent('reset-stuff');
	}

	public function count(array $stuffs, int $total)
	{
		$ppn = site('ppn') / 100;

		$this->stuffs = $stuffs;
		$this->total = $total;
		$this->ppn = $total * $ppn;
		$this->subtotal = $this->total + $this->ppn;
	}

	public function updatedMoney($money)
	{
		$this->return = max(intval(str_replace([',', '.'], '', $money)) - $this->subtotal, 0);
	}

	public function mount()
	{
		$this->user = auth()->user();
	}

    public function render()
    {
        return view('livewire.transaction.payment');
    }
}
