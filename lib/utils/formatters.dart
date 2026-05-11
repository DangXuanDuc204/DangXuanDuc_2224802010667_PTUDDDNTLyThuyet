String formatCurrency(num value) {
  final rounded = value.round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < rounded.length; i++) {
    final positionFromEnd = rounded.length - i;
    buffer.write(rounded[i]);
    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${buffer.toString()} VNĐ';
}
