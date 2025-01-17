<?php

namespace App\Http\Livewire\Stock;

use Livewire\Component;

use App\Models\Stock;
use App\Repositories\StuffRepository;

class Form extends Component
{

	public $barcode;
	public $jumlah = 1;
	public $distributor = null;
	public $latestId;

	protected $listeners = ['reset-id' => 'setId'];

	public function submit(StuffRepository $stuffRepo)
	{
		$this->validate([
			'barcode' => 'required|exists:buku',
			'jumlah' => 'required|integer|min:1'
		]);

		$stuff = $stuffRepo->getByCode($this->barcode);

		$this->emit('addData', $stuff, $this->jumlah);
		
		$this->barcode = null;
		$this->distributor = null;
		$this->jumlah = 1;

		$this->dispatchBrowserEvent('reset-data-form');
	}

	public function setId($lastId = null)
	{
		if (!$lastId) {
			$lastId = Stock::latest('idPembelian')->first()->idPembelian ?? 0;
			$lastId = (int)substr($lastId, 1, 4);

			$lastId = sprintf("P%04d-%d-%06d", $lastId+1, auth()->id(), date('dmy'));
		}

		$this->latestId = $lastId;
	}

	public function mount()
	{
		$this->setid();
	}

  public function render()
  {
    return view('livewire.stock.form');
  }
}
