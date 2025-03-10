<div class="card">
	<div class="card-header d-flex justify-content-between align-items-center py-2">
		<h2 class="card-title h6 mb-0 font-weight-bold">Data Transaksi</h2>
		<div>
			<a href="{{ route('transaction.index') }}" class="btn btn-sm btn-secondary">Kembali</a>
			<button class="btn btn-danger btn-sm" {{ count($transactions) ? '' : 'disabled' }} wire:click="clear">Reset</button>
			<button class="btn btn-sm btn-primary" {{ count($transactions) ? '' : 'disabled' }} id="payment-btn" wire:click="$emit('open-payment')">Bayar</button>
		</div>
	</div>
	<div class="card-body">
		@if(session()->has('stock-error'))
			<div class="alert alert-danger alert-dismissible">
				{{ session('stock-error') }}
				<button class="close" data-dismiss="alert">&times;</button>
			</div>
		@endif

		<div class="table-responsive">
			<table class="table table-bordered" width="100%">
				<thead>
					<tr>
						<th width="50px">No</th>
						<th width="150px">Barcode</th>
						<th>Barang</th>
						<th width="200px">Harga</th>
						<th width="150px">Qty</th>
						<th width="120px"> Discount</th>
						<th width="200px">Total</th>
						<th width="100px">Action</th>
					</tr>
				</thead>
				<tbody class="transaction-table">
				@forelse ($transactions as $transaction)
					@php
						$disc = $transaction['total'] * ($transaction['hargaJual'] * $transaction['disc'] / 100);
						$total = $transaction['total'] * $transaction['hargaJual'] - round($disc);
					@endphp
					<tr>
						<td>{{ $loop->iteration }}</td>
						<td>{{ $transaction['stuff']['barcode'] }}</td>
						<td>{{ $transaction['judul'] }}</td>
						<td><div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Rp</span>
                            </div>
                            <input type="number" name="price" class="form-control price @error('price') is-invalid @enderror" data-id="{{ $transaction['id'] }}"
                            data-total="{{ $transaction['hargaJual'] }}"
                            value="{{ $transaction['hargaJual'] }}" placeholder="0">

                            @error('price')
                                <span class="invalid-feedback">{{ $message }}</span>
                            @enderror
                        </div>

                        </td>
						<td>
							<div class="input-group">
								<div class="input-group-prepend">
									<button class="btn btn-outline-secondary" wire:click="decrement('{{ $transaction['id'] }}')">-</button>
								</div>
								<input type="text" class="form-control qty" data-action="update" data-id="{{ $transaction['id'] }}" data-total="{{ $transaction['total'] }}" data-stock="{{ $transaction['stuff']['stock'] }}" value="{{ $transaction['total'] }}">
								<div class="input-group-append">
									<button class="btn btn-outline-secondary" wire:click="increment('{{ $transaction['id'] }}')">+</button>
								</div>

								<span class="invalid-feedback"></span>
							</div>
						</td>
						<td align="right">Rp {{ number_format($disc) }}</td>
						<td align="right">Rp {{ number_format($total) }}</td>
						<td><button class="btn btn-sm btn-danger" wire:click="delete('{{ $transaction['id'] }}')"><i class="fa fa-trash"></i></button></td>
					</tr>
				@empty
					<tr>
						<td colspan="8" align="center">Kosong</td>
					</tr>
				@endforelse
				</tbody>
				@if ($transactions)
					<tfoot>
						<tr class="bg-success text-white">
							<td style="border: none;" align="center" colspan="6"><strong>Subtotal</strong></td>
							<td style="border: none;" align="right">Rp {{ number_format($subtotal) }}</td>
							<td style="border: none;"></td>
						</tr>
					</tfoot>
				@endif
			</table>
		</div>
	</div>
</div>

@push('js')
<script>
	$(function () {
		$('.transaction-table').on('keyup', '.qty', function () {
			const number = this.value.replace(/\D/gi, '')
			const { stock, id } = $(this).data()

			if (number) {
				if (number > stock) {
					$(this).addClass('is-invalid')
					$(this).siblings('.invalid-feedback').html('Stok melampau batas')
				} else if (number <= 0) {
					$(this).addClass('is-invalid')
					$(this).siblings('.invalid-feedback').html('Stok terlalu sedikit')
				} else {
					Livewire.emit('update-stock', id, number)

					this.value = number
				}
			}

		})

		$('.transaction-table').on('focusout', '.qty', function () {
			if ($(this).hasClass('is-invalid')) {
				this.value = $(this).data('total')
			}

			if (!this.value) {
				this.value = $(this).data('total')
			}

			$(this).removeClass('is-invalid')
		})

        let debounceTimer;

$('.transaction-table').on('input', '.price', function () {
    clearTimeout(debounceTimer);
    const $input = $(this);
    const { id } = $input.data();
    let newPrice = $input.val();

    // Hanya hapus karakter yang bukan angka tanpa mengganti keseluruhan nilai
    let filteredPrice = newPrice.replace(/[^0-9]/g, '');
    if (newPrice !== filteredPrice) {
        let caretPos = $input[0].selectionStart;
        $input.val(filteredPrice);
        $input[0].setSelectionRange(caretPos, caretPos);
    }

    debounceTimer = setTimeout(() => {
        if (filteredPrice.trim() !== '') {
            let currentPrice = parseInt(filteredPrice, 10);
            if (!isNaN(currentPrice)) {
                Livewire.emit('update-price', id, currentPrice);
                $input.data('total', filteredPrice); // Update nilai total agar tidak kembali ke nilai awal
            }
        }
    }, 500);
});

$('.transaction-table').on('focusout', '.price', function () {
    const $input = $(this);
    let newPrice = $input.val();
    let filteredPrice = newPrice.replace(/[^0-9]/g, '');

    if (newPrice !== filteredPrice) {
        $input.val(filteredPrice);
    }
    if (filteredPrice.trim() !== '') {
        let currentPrice = parseInt(filteredPrice, 10);
        if (!isNaN(currentPrice)) {
            Livewire.emit('update-price', $input.data('id'), currentPrice);
            $input.data('total', filteredPrice); // Update nilai total saat focusout agar tidak revert
        }
    } else {
        $input.val($input.data('total'));
    }
});





    //     let debounceTimer;
    //     $('.transaction-table').on('input', '.price', function () {
    //         // const newPrice = parseInt(this.value.replace(/\D/g, ''), 10);
    //         // const { id } = $(this).data();

    //         // if (newPrice && newPrice > 0) {
    //         //     Livewire.emit('update-price', id, newPrice);
    //         // } else {
    //         //     $(this).addClass('is-invalid');
    //         //     $(this).siblings('.invalid-feedback').html('Harga tidak valid');
    //         // }

    //         clearTimeout(debounceTimer);
    // const $input = $(this);
    // debounceTimer = setTimeout(() => {
    //     const newPrice = parseInt($input.val().replace(/\D/g, ''), 10);
    //     const { id } = $input.data();

    //     if (newPrice && newPrice > 0) {
    //         Livewire.emit('update-price', id, newPrice);
    //         $input.removeClass('is-invalid');
    //     } else {
    //         $input.addClass('is-invalid');
    //         $input.siblings('.invalid-feedback').html('Harga tidak valid');
    //     }
    // }, 500);
    //     });

    //     $('.transaction-table').on('focusout', '.price', function () {
    //         if ($(this).hasClass('is-invalid')) {
    //             this.value = $(this).data('total'); // Mengembalikan harga awal jika invalid
    //             $(this).removeClass('is-invalid');
    //         }
    //     });

	})
</script>
@endpush
