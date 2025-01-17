<?php

namespace App\Http\Requests\Stuff;

use Illuminate\Foundation\Http\FormRequest;

class CreateStuffRequest extends FormRequest
{

    public function prepareForValidation()
    {
        $this->merge([
            'hargaPokok' => intval(str_replace([',', '.'], '', $this->hargaPokok)),
            'hargaJual' => intval(str_replace([',', '.'], '', $this->hargaJual)),
            'hargaReseller' => intval(str_replace([',', '.'], '', $this->hargaReseller)),
            'stock' => 0
        ]);
    }

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return $this->user()->can('isAdminGudang');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'idKategori' => 'required|exists:kategori',
            'idRak' => 'required|exists:rak',
            'barcode' => 'required|string|unique:buku',
            'noisbn' => 'nullable|unique:buku',
            'judul' => 'required|string',
            'penulis' => 'nullable|string',
            'penerbit' => 'required|string',
            'tahun' => 'required|date_format:Y',
            'hargaPokok' => 'required|numeric|min:1|digits_between:0,9|max:'.$this->hargaJual,
            'hargaJual' => 'required|numeric|min:1|digits_between:0,9',
            'hargaReseller' => 'required|numeric|digits_between:0,9|min:'.$this->hargaPokok,
            'disc' => 'required|numeric|max:100'
        ];
    }
}
