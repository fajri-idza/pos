<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>

	<style>
		@page {
		    margin: 0;
		}
		body {
			font-family: "Roboto";
			color: #000;
			font-size: 16px;
			width: 60%;
		}
		.heading {
			position: relative;
			text-align: center;
			margin-top: -60px;
		}
		.title {
			font-size: 24px;
			color: #111;
		}
		hr {
			border: 0;
			border-top: 2px solid #000;
		}
		p {
			margin: 0;
		}
		img {
			margin-top: 50px;
			width: 100px;
			height: 100px;
		}
	</style>
</head>
<body style="margin-left: 27px">

<div class="heading">
		@if (site('pakaiLogo'))
        <img src="{{ public_path('storage/logo/'.site('logo')) }}" alt="" style="margin-bottom: 55px">
    @endif
    <div class="detail">
    	<p class="title">{{ site('nama_toko') }}</p>
    	<p>{{ site('alamat_toko') }}</p>
    	<p>{{ site('telepon_toko') }}</p>
    </div>
</div>
<hr>

<table width="100%">
	<tr>
		<td width="20%">No Faktur</td>
		<td width="2%">
			:
		</td>
		<td>
			{{ $transaction->idPenjualan }}
		</td>
	</tr>
	<tr>
		<td>Tanggal</td>
		<td width="2%">
			:
		</td>
		<td>
			@php
				date_default_timezone_set('Asia/Jakarta');
			@endphp
			{{ date('d/m/y h:i A', strtotime($transaction->tanggal)) }}
		</td>
	</tr>
	<tr>
		<td>Kasir</td>
		<td width="2%">
			:
		</td>
		<td>
			{{ $transaction->namaUser }}
		</td>
	</tr>
</table>

<hr>

@php
	$total = 0;
	$disc = 0;
@endphp
<table style="margin-bottom: 20px" width="100%">
	@foreach($transaction->detail as $stuff)
		@php
			$subtotal = $stuff->jumlah * $stuff->hargaJual - $stuff->disc;
			$disc += $stuff->disc;
			$total += $subtotal;
		@endphp
		<tr>
			<td width="5%" valign="top">
				{{ $loop->iteration }}.
			</td>
			<td width="95%">
				{{ $stuff->judul }}<br>
				{{ $stuff->jumlah }} x {{ $stuff->hargaJual }}<br>
				Disc. {{ $stuff->disc }}<br>
			</td>
			<td align="right">
				{{ number_format($subtotal) }}
			</td>
		</tr>
	@endforeach
</table>

<hr>

<table width="100%" style="margin-bottom: 10px">
	<tr>
		<td width="20%">Total</td>
		<td width="2%">
			:
		</td>
		<td width="55%" align="right">
			<span>{{ number_format($total) }}</span>
		</td>
	</tr>
	<tr>
		<td width="20%">PPN</td>
		<td width="2%">
			:
		</td>
		<td width="78%" align="right">
			<span>{{ number_format($transaction->ppn) }}</span>
		</td>
	</tr>
	<tr>
		<td width="20%">Subtotal</td>
		<td width="2%">
			:
		</td>
		<td width="78%" align="right">
			<span>{{ number_format($total + $transaction->ppn) }}</span>
		</td>
	</tr>
	<tr>
		<td width="20%">Bayar</td>
		<td width="2%">
			:
		</td>
		<td width="78%" align="right">
			<span>{{ number_format($bayar ?? 0) }}</span>
		</td>
	</tr>
	<tr>
		<td width="20%">Kembali</td>
		<td width="2%">
			:
		</td>
		<td width="78%" align="right">
			<span>{{ number_format(max($bayar - ($total + $transaction->ppn), 0)) }}</span>
		</td>
	</tr>
</table>

<hr>

<table width="100%">
	<tr>
		<td width="50%">BKP : {{ number_format($total) }}</td>
		<td width="50%">DISC : <span style="text-align: right; float: right;">{{ number_format($disc) }}</span></td>
	</tr>
	<tr>
		<td width="50%">DPP : {{ number_format($total + $transaction->ppn) }}</td>
		<td width="50%">PPN : <span style="text-align: right; float: right;">{{ number_format($transaction->ppn) }}</span></td>
	</tr>
</table>

<div style="text-transform: uppercase; text-align: center; margin-top: 40px">
	<p>Terima Kasih</p>
	<p>Barang Yang sudah dibeli</p>
	<p>tidak dapat ditukar atau dikembalikan</p>
</div>

</body>
</html>
