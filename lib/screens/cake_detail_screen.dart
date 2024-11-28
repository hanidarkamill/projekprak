import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek3/model/cake_model.dart';

class CakeDetailScreen extends StatefulWidget {
  final Cakes cake;

  const CakeDetailScreen({Key? key, required this.cake}) : super(key: key);

  @override
  _CakeDetailScreenState createState() => _CakeDetailScreenState();
}

class _CakeDetailScreenState extends State<CakeDetailScreen> {
  String selectedCurrency = 'IDR';
  String selectedTimeZone = 'WIB'; // Default time zone
  String currentTime = '';
  String witaTime = '';
  String witTime = '';
  String londonTime = '';
  String seoulTime = '';
  double inputPrice = 0.0;
  TextEditingController priceController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool paymentSuccessful = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    inputPrice = widget.cake.price ?? 0.0;
    priceController.text = inputPrice.toString();
    timeController.text = '00:00';

    _updateTimes(DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateTimes(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimes(DateTime dateTime) {
    setState(() {
      currentTime = convertTimeToWIB(dateTime);
      witaTime = convertTimeToWITA(dateTime);
      witTime = convertTimeToWIT(dateTime);
      londonTime = convertTimeToLondon(dateTime);
      seoulTime = convertTimeToSeoul(dateTime);
    });
  }

  String convertPrice(double price, String currency) {
    double convertedPrice = price;
    if (currency == 'USD') convertedPrice = price / 15000;
    if (currency == 'EUR') convertedPrice = price / 16000;
    if (currency == 'GBP') convertedPrice = price / 18000;
    if (currency == 'JPY') convertedPrice = price / 130;
    if (currency == 'CNY') convertedPrice = price / 2200; // IDR to CNY conversion
    if (currency == 'INR') convertedPrice = price / 200;  // IDR to INR conversion
    if (currency == 'AUD') convertedPrice = price / 11000; // IDR to AUD conversion
    if (currency == 'SGD') convertedPrice = price / 10000; // IDR to SGD conversion
    if (currency == 'MYR') convertedPrice = price / 3500; // IDR to MYR conversion

    final formatCurrency = NumberFormat.simpleCurrency(name: currency);
    return formatCurrency.format(convertedPrice);
  }

  String convertTimeToWIB(DateTime dateTime) {
    DateTime wibTime = dateTime.toUtc().add(const Duration(hours: 7));
    var format = DateFormat('HH:mm:ss');
    return format.format(wibTime);
  }

  String convertTimeToWITA(DateTime dateTime) {
    DateTime witaTime = dateTime.toUtc().add(const Duration(hours: 8));
    var format = DateFormat('HH:mm:ss');
    return format.format(witaTime);
  }

  String convertTimeToWIT(DateTime dateTime) {
    DateTime witTime = dateTime.toUtc().add(const Duration(hours: 9));
    var format = DateFormat('HH:mm:ss');
    return format.format(witTime);
  }

  String convertTimeToLondon(DateTime dateTime) {
    DateTime londonTime = dateTime.toUtc().subtract(const Duration(hours: 1));
    var format = DateFormat('HH:mm:ss');
    return format.format(londonTime);
  }

  String convertTimeToSeoul(DateTime dateTime) {
    DateTime seoulTime = dateTime.toUtc().add(const Duration(hours: 9));
    var format = DateFormat('HH:mm:ss');
    return format.format(seoulTime);
  }

  void _processPayment() {
    setState(() {
      paymentSuccessful = inputPrice > 0.0 && timeController.text.isNotEmpty;
    });

    if (paymentSuccessful) {
      _showPaymentSuccess();
    } else {
      _showPaymentFailure();
    }
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.pink[50],
        title: const Text('Pembayaran Berhasil', style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cake: ${widget.cake.title ?? 'No Title'}'),
            Text('Waktu Pesanan: $currentTime'),
            Text('Harga: ${convertPrice(inputPrice, selectedCurrency)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showPaymentFailure() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.pink[50],
        title: const Text('Pembayaran Gagal', style: TextStyle(color: Colors.red)),
        content: const Text('Mohon pastikan semua data sudah benar dan coba lagi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Coba Lagi', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cake.title ?? 'Cake Detail'),
        backgroundColor: const Color(0xFFD32F2F), // Main Red Color
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF8B7D3), // Light pink background without gradient
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: widget.cake.image ?? '',
                  child: Image.network(
                    widget.cake.image ?? '',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.cake.title ?? 'No Title',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.cake.detailDescription ?? 'No Description available',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Changed text color to black for better readability
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              
              // Layout for Time and Price input side by side
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left box for Time
                  Expanded(
                    child: Card(
                      elevation: 8,
                      color: Colors.pink[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Waktu: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              value: selectedTimeZone,
                              items: ['WIB', 'WITA', 'WIT', 'London', 'Seoul']
                                  .map((timeZone) => DropdownMenuItem(
                                        value: timeZone,
                                        child: Text(timeZone),
                                      ))
                                  .toList(),
                              onChanged: (String? newTimeZone) {
                                setState(() {
                                  selectedTimeZone = newTimeZone!;
                                  switch (selectedTimeZone) {
                                    case 'WIB':
                                      currentTime = convertTimeToWIB(DateTime.now());
                                      break;
                                    case 'WITA':
                                      currentTime = witaTime;
                                      break;
                                    case 'WIT':
                                      currentTime = witTime;
                                      break;
                                    case 'London':
                                      currentTime = londonTime;
                                      break;
                                    case 'Seoul':
                                      currentTime = seoulTime;
                                      break;
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Waktu Terpilih: $currentTime',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right box for Price
                  Expanded(
                    child: Card(
                      elevation: 8,
                      color: Colors.pink[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Harga: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan harga',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  inputPrice = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              value: selectedCurrency,
                              items: [
                                'IDR',
                                'USD',
                                'EUR',
                                'GBP',
                                'JPY',
                                'CNY',
                                'INR',
                                'AUD',
                                'SGD',
                                'MYR'
                              ]
                                  .map((currency) => DropdownMenuItem(
                                        value: currency,
                                        child: Text(currency),
                                      ))
                                  .toList(),
                              onChanged: (String? newCurrency) {
                                setState(() {
                                  selectedCurrency = newCurrency!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Harga Terpilih: ${convertPrice(inputPrice, selectedCurrency)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proses Pembayaran',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
