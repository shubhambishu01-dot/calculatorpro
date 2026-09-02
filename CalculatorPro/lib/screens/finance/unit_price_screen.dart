import 'package:flutter/material.dart';

class UnitPriceScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color accentColor;
  const UnitPriceScreen({
    super.key,
    required this.isDarkMode,
    this.accentColor = Colors.orange,
  });

  @override
  State<UnitPriceScreen> createState() => _UnitPriceScreenState();
}

class _UnitPriceScreenState extends State<UnitPriceScreen> {
  final TextEditingController priceAController = TextEditingController(
    text: '120',
  );
  final TextEditingController qtyAController = TextEditingController(
    text: '4',
  );
  final TextEditingController priceBController = TextEditingController(
    text: '200',
  );
  final TextEditingController qtyBController = TextEditingController(
    text: '6',
  );

  double get unitA {
    final p = double.tryParse(priceAController.text) ?? 0;
    final q = double.tryParse(qtyAController.text) ?? 0;
    return q > 0 ? p / q : 0;
  }

  double get unitB {
    final p = double.tryParse(priceBController.text) ?? 0;
    final q = double.tryParse(qtyBController.text) ?? 0;
    return q > 0 ? p / q : 0;
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final subColor = widget.isDarkMode ? Colors.grey[400] : Colors.black54;
    final cardColor =
        widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100;

    final aCheaper = unitA > 0 && (unitB == 0 || unitA <= unitB);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Unit Price Compare', style: TextStyle(color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product A', style: TextStyle(color: subColor, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _field('Price', priceAController, textColor, cardColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field('Quantity', qtyAController, textColor, cardColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Product B', style: TextStyle(color: subColor, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _field('Price', priceBController, textColor, cardColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field('Quantity', qtyBController, textColor, cardColor),
                ),
              ],
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
                  _row(
                    'A: price/unit',
                    unitA,
                    textColor,
                    aCheaper ? widget.accentColor : textColor,
                  ),
                  const SizedBox(height: 10),
                  _row(
                    'B: price/unit',
                    unitB,
                    textColor,
                    !aCheaper ? widget.accentColor : textColor,
                  ),
                  const SizedBox(height: 16),
                  if (unitA > 0 || unitB > 0)
                    Text(
                      aCheaper ? 'Product A is the better deal' : 'Product B is the better deal',
                      style: TextStyle(
                        color: widget.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, double value, Color textColor, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        Text(
          value.toStringAsFixed(3),
          style: TextStyle(
            fontSize: 18,
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
    Color? cardColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(border: InputBorder.none),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
