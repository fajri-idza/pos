@extends('_layouts.app')

@section('title', 'Tambah Barang')

@section('content')

	<div class="mb-4">
		<div>
			<div class="card">
			<form action="{{ route('stuff.store') }}" method="post">
				@csrf
				<div class="card-header">
					<h2 class="h6 font-weight-bold mb-0 card-title">Tambah Barang</h2>
				</div>
				<div class="card-body">

					<div class="form-group">
					<label>Barang*</label>
								<input type="text" class="form-control @error('judul') is-invalid @enderror" name="judul" placeholder="Barang" value="{{ old('judul') }}" autofocus>

								@error('judul')
									<span class="invalid-feedback">{{ $message }}</span>
								@enderror
					</div>

					<div class="form-row">
						<div class="col">
							<div class="form-group">
							<label>No Produk</label>
						<input type="text" class="form-control @error('noisbn') is-invalid @enderror" name="noisbn" placeholder="No Produk" value="{{ old('noisbn') }}">

						@error('noisbn')
							<span class="invalid-feedback">{{ $message }}</span>
						@enderror
							</div>
						</div>
						<div class="col">
							<div class="form-group">
							<label>Barcode*</label>
						<div class="input-group">
							<input type="text" class="form-control @error('barcode') is-invalid @enderror" name="barcode" placeholder="Barcode" value="{{ old('barcode') }}" >
							<div class="input-group-append">
								<button class="btn btn-outline-secondary generate-barcode" type="button">Generate</button>
							</div>

							@error('barcode')
								<span class="invalid-feedback">{{ $message }}</span>
							@enderror
						</div>
							</div>
						</div>
					</div>

					<div class="form-row">
				<div class="col">
					<div class="form-group">
						<label>Kategori*</label>
						<select class="form-control custom-select" name="idKategori" style="width: 100%;"></select>

						<span class="invalid-feedback"></span>
					</div>
				</div>
				<div class="col">
					<div class="form-group">
						<label>Rak*</label>
						<select class="form-control custom-select" name="idRak" style="width: 100%;"></select>

						<span class="invalid-feedback"></span>
					</div>
				</div>
			</div>
					<div class="form-row">
						<div class="col">
							<div class="form-group">
							<label>Satuan*</label>
								<input type="text" class="form-control @error('penerbit') is-invalid @enderror" name="penerbit" placeholder="Satuan" value="{{ old('penerbit') }}">

								@error('penerbit')
									<span class="invalid-feedback">{{ $message }}</span>
								@enderror
							</div>
						</div>
						<div class="col">
							<div class="form-group">
								<label>Keterangan</label>
								<input type="text" class="form-control @error('penulis') is-invalid @enderror" name="penulis" placeholder="Keterangan" value="{{ old('penulis') }}">

								@error('penulis')
									<span class="invalid-feedback">{{ $message }}</span>
								@enderror
							</div>
						</div>
					</div>
					<div class="form-row">
						<div class="col">
							<div class="form-group">

								<label>Discount (%)</label>
								<input type="text" class="form-control discount @error('disc') is-invalid @enderror" name="disc" placeholder="Disc" value="{{ old('disc', 0) }}">

								@error('disc')
									<span class="invalid-feedback">{{ $message }}</span>
								@enderror
							</div>
						</div>
						<div class="col">
							<div class="form-group">
								<label>Tahun*</label>
								<input type="text" class="form-control @error('tahun') is-invalid @enderror" name="tahun" placeholder="Tahun" value="{{ old('tahun') }}">

								@error('tahun')
									<span class="invalid-feedback">{{ $message }}</span>
								@enderror
							</div>
						</div>
					</div>
					<div class="form-row">
						<div class="col">
							<div class="form-group">
								<label>Harga Pokok*</label>
								<div class="input-group">
									<div class="input-group-prepend">
										<span class="input-group-text">Rp</span>
									</div>
									<input type="text" class="form-control price @error('hargaPokok') is-invalid @enderror" name="hargaPokok" placeholder="Harga Pokok" value="{{ old('hargaPokok') }}">

									@error('hargaPokok')
										<span class="invalid-feedback">{{ $message }}</span>
									@enderror
								</div>
							</div>
						</div>
						<div class="col">
							<div class="form-group">
								<label>Harga Jual*</label>
								<div class="input-group">
									<div class="input-group-prepend">
										<span class="input-group-text">Rp</span>
									</div>
									<input type="text" class="form-control price @error('hargaJual') is-invalid @enderror" name="hargaJual" placeholder="Harga Jual" value="{{ old('hargaJual') }}">

									@error('hargaJual')
										<span class="invalid-feedback">{{ $message }}</span>
									@enderror
								</div>
							</div>
						</div>
                        <div class="col">
							<div class="form-group">
								<label>Harga Reseller</label>
								<div class="input-group">
									<div class="input-group-prepend">
										<span class="input-group-text">Rp</span>
									</div>
									<input type="text" class="form-control price @error('hargaReseller') is-invalid @enderror" name="hargaReseller" placeholder="Harga Reseller" value="{{ old('hargaReseller') }}">

									@error('hargaReseller')
										<span class="invalid-feedback">{{ $message }}</span>
									@enderror
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="card-footer">

					<a class="btn btn-secondary" href="{{ route('stuff.index') }}">Kembali</a>
					<button class="btn btn-primary" type="submit">Simpan</button>
				</div>
			</form>
			</div>
		</div>
	</div>

@endsection

@push('css')

	<link rel="stylesheet" href="{{ asset('sufee-admin/vendors/select2/css/select2.min.css') }}">
	<link rel="stylesheet" href="{{ asset('sufee-admin/vendors/select2-bootstrap4-theme/select2-bootstrap4.min.css') }}">

@endpush

@push('js')

	<script src="{{ asset('sufee-admin/vendors/select2/js/select2.min.js') }}"></script>

	<script>
		jQuery(function ($) {
			const generate = () => {
				const val = Math.floor(1000 + Math.random() * 9999)

				let barcode = ('97862300'+val).substr(0,12)

				if (barcode.length < 12) {
					barcode += Math.floor(Math.random() * 9 + 1)
				}

				const digit = barcode.split('').reduce((total, val, index) => {
					const num = (index + 1) % 2 === 0 ? 3 : 1
					const sum = num * val

					return total + sum
				}, 0)

				return { barcode, digit }
			}

			const getDigit = () => {
				const { barcode, digit } = generate()
				const sisa = 10 - (digit % 10)

				if (sisa < 10) {
					return barcode + '' + sisa
				}
				getDigit()
			}

			$('.price').on('keyup', function() {
				const number = Number(this.value.replace(/\D/g, ''))
				const price = new Intl.NumberFormat().format(number)

				this.value = price
			})

			$('.discount').on('keyup', function() {
				const number = this.value.replace(/[^0-9\.]/g, '')

				console.log(number)

				if (number.toString().length >= 4) {
					this.value = number.toString().substr(0, 4)
				} else {
					this.value = number
				}

			})
			$('.generate-barcode').on('click', function () {
				const barcode = getDigit()

				$('[name=barcode]').val(barcode)
			})
			$('[name=idKategori]').select2({
				placeholder: 'Kategori',
				theme: 'bootstrap4',
				ajax: {
					url: '{{ route('category.select') }}',
					type: 'post',
					data: params => ({
						name: params.term,
						_token: '{{ csrf_token() }}'
					}),
					processResults: res => ({
						results: res
					}),
					cache: true
				}
			})
			$('[name=idRak]').select2({
				placeholder: 'Rak',
				theme: 'bootstrap4',
				ajax: {
					url: '{{ route('rack.select') }}',
					type: 'post',
					data: params => ({
						name: params.term,
						_token: '{{ csrf_token() }}'
					}),
					processResults: res => ({
						results: res
					}),
					cache: true
				}
			})
		})
	</script>

@endpush
