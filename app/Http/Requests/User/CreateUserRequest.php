<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;

class CreateUserRequest extends FormRequest
{
    public function prepareForValidation()
    {
        $this->merge([
            'status' => 1,
            'password' => $this->username,
        ]);
    }

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'nama' => 'required|string|unique:user',
            'username' => 'required|string|unique:user',
            'alamat' => 'required|string',
            'telepon' => 'required|numeric',
            'password' => 'required|string',
            'hakAkses' => 'required|in:1,2,3',
        ];
    }
}
