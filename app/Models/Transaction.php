<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $table = 'penjualan';
    protected $primaryKey = 'idPenjualan';

    public $timestamps = false;
    public $incrementing = false;

    protected $fillable = ['idPenjualan', 'idUser', 'namaUser','namaPembeli', 'total', 'ppn', 'tanggal', 'status'];

    protected static function booted()
    {
        static::creating(function ($transaction)
        {
            if (!$transaction->idPenjualan) {
                $lastId = Transaction::latest('idPenjualan')->first()->idPenjualan ?? 0;
                $lastId = (int)substr($lastId, 1, 4);

                $transaction->idPenjualan = sprintf("T%04d-%d-%06d", $lastId+1, auth()->id(), date('dmy'));
            }
        });
    }

    public function getDateAttribute()
    {
        return localDate($this->tanggal);
    }

    public function getStatusBadgeAttribute(): String
    {
        return $this->status ? '<span class="badge badge-success">berhasil</span>' : '<span class="badge badge-danger">batal</span>';
    }

    public function detail()
    {
        return $this->hasMany(DetailTransaction::class, 'idPenjualan');
    }

    public function ppn()
    {
        return $this->hasOne(PPN::class, 'idPenjualan');
    }

    public function stuffs()
    {
        return $this->belongsToMany(Stuff::class, 'detail_penjualan', 'idPenjualan', 'idBuku')->using(DetailTransaction::class)->withPivot('judul', 'hargaPokok', 'hargaJual', 'jumlah', 'disc');
    }

    public function user()
    {
    	return $this->belongsTo(User::class, 'idUser');
    }
}
