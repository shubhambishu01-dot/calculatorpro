import 'package:flutter/material.dart';

class DiscountScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color accentColor;
  const DiscountScreen({
    super.key,
    required this.isDarkMode,
    this.accentColor = Colors.orange,
  });

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final TextEditingController priceController = TextEditingController(
    text: '1200',
  );
  final TextEditingController percentController = TextEditingController(
    text: '20',
  );

  double get originalPrice => double.tryParse(priceController.text) ?? 0;
  double get discountPercent => double.tryParse(percentController.text) ?? 0;
  double get discountAmount => originalPrice * discountPercent / 100;
  double get finalPrice => originalPrice - discountAmount;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final cardColor =
        widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Discount', style: TextStyle(color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field('Original price', priceController, textColor, cardColor),
            const SizedBox(height: 16),
            _field(
              'Discount (%)',
              percentController,
              textColor,
              cardColor,
              suffix: '%',
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('You save', discountAmount, textColor, widget.accentColor),
                  const SizedBox(height: 10),
                  _row('Final price', finalPrice, textColor, textColor, big: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value, Color textColor, Color valueColor,
      {bool big = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: big ? 20 : 16,
            fontWeight: big ? FontWeight.bold : FontWeight.w600,
            color: textColor,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: big ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    Color textColor,
    Color? cardColor, {
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixText: suffix,
            ),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
