import 'package:flutter/material.dart';

class ProfitMarginScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color accentColor;
  const ProfitMarginScreen({
    super.key,
    required this.isDarkMode,
    this.accentColor = Colors.orange,
  });

  @override
  State<ProfitMarginScreen> createState() => _ProfitMarginScreenState();
}

class _ProfitMarginScreenState extends State<ProfitMarginScreen> {
  final TextEditingController costController = TextEditingController(
    text: '1200',
  );
  final TextEditingController saleController = TextEditingController(
    text: '1500',
  );

  double get cost => double.tryParse(costController.text) ?? 0;
  double get sale => double.tryParse(saleController.text) ?? 0;
  double get margin => sale - cost;
  double get marginPercent => sale > 0 ? (margin / sale) * 100 : 0;
  double get markupPercent => cost > 0 ? (margin / cost) * 100 : 0;

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
        title: Text(
          'Gain & Profit Margin',
          style: TextStyle(color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field('Cost', costController, textColor, cardColor),
            const SizedBox(height: 16),
            _field('Sale price', saleController, textColor, cardColor),
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
                  _pctRow(
                    'Margin of profit',
                    marginPercent,
                    textColor,
                    widget.accentColor,
                  ),
                  const SizedBox(height: 10),
                  _pctRow('Markup', markupPercent, textColor, textColor),
                  const SizedBox(height: 10),
                  _row('Margin', margin, textColor, textColor, big: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pctRow(String label, double value, Color textColor, Color valueColor) {
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
          '${value.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
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
    Color? cardColor,
  ) {
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
            decoration: const InputDecoration(border: InputBorder.none),
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
