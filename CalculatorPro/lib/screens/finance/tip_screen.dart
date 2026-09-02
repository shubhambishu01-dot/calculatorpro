import 'package:flutter/material.dart';

class TipScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color accentColor;
  const TipScreen({
    super.key,
    required this.isDarkMode,
    this.accentColor = Colors.orange,
  });

  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  final TextEditingController billController = TextEditingController(
    text: '850',
  );
  final TextEditingController peopleController = TextEditingController(
    text: '1',
  );
  double tipPercent = 15;

  double get bill => double.tryParse(billController.text) ?? 0;
  int get people => int.tryParse(peopleController.text) ?? 1;
  double get tipAmount => bill * tipPercent / 100;
  double get total => bill + tipAmount;
  double get perPerson => people > 0 ? total / people : total;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final subColor = widget.isDarkMode ? Colors.grey[400] : Colors.black54;
    final cardColor =
        widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Tip Calculator', style: TextStyle(color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field('Bill amount', billController, textColor, cardColor),
            const SizedBox(height: 20),
            Text(
              'Tip: ${tipPercent.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Slider(
              value: tipPercent,
              min: 0,
              max: 30,
              divisions: 30,
              activeColor: widget.accentColor,
              label: '${tipPercent.toStringAsFixed(0)}%',
              onChanged: (v) => setState(() => tipPercent = v),
            ),
            const SizedBox(height: 12),
            _field('Split between (people)', peopleController, textColor,
                cardColor),
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
                  _row('Tip amount', tipAmount, textColor, widget.accentColor),
                  const SizedBox(height: 10),
                  _row('Total bill', total, textColor, textColor),
                  const SizedBox(height: 10),
                  _row('Per person', perPerson, textColor, textColor,
                      big: true),
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
