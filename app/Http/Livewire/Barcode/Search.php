<?php

namespace App\Http\Livewire\Barcode;

use Livewire\Component;

class Search extends Component
{

    public $barcode, $judul, $idBuku;

    protected $rules = [
        'barcode' => 'required|exists:buku',
        'judul' => 'required',
        'idBuku' => 'required',
    ];

    public function setData($data)
    {
        $this->barcode = $data['barcode'];
        $this->judul = $data['judul'];
        $this->idBuku = $data['idBuku'];
    }

    public function submit(): Void
    {
        $data = $this->validate();

        $this->emit('add-barcode', $data);
        $this->reset();
    }

    public function render()
    {
        return view('livewire.barcode.search');
    }
}
