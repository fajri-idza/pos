// jQuery(function ($) {
// 	$('[name=stuff_id]').select2({
// 		placeholder: 'Barang',
// 		ajax: {
// 			url: selectCodeUrl,
// 			type: 'post',
// 			data: params => ({
// 				code: params.term,
// 				_token: csrf
// 			}),
// 			processResults: res => ({
// 				results: res
// 			}),
// 			cache: true
// 		}
// 	})
// 	$('[name=stuff_id]').on('select2:select', function (e) {
// 		const { id, name, stock, price } = e.params.data

// 		$('[name=name]').val(name)
// 		$('[name=stock]').val(stock)
// 		$('[name=price]').val(price)
// 	})
// })