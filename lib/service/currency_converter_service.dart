class CurrencyConverterService {
  // Misalnya nilai tukar tetap antara USD dan IDR
  static const double usdToIdr = 15000;

  // Fungsi untuk mengonversi mata uang
  static String convert(double amount) {
    double result = amount * usdToIdr; // Mengonversi USD ke IDR
    return 'Converted Value: ${result.toStringAsFixed(2)} IDR';
  }
}
