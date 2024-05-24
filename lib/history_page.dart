import 'package:flutter/material.dart';
import 'main.dart';

class HistoryPage extends StatefulWidget {
  final List<EquationPieces> equationHistory;

  HistoryPage({required this.equationHistory});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<double> runningTotals = [];

  @override
  void initState() {
    super.initState();
    _calculateRunningTotals();
  }

  void _calculateRunningTotals() {
    runningTotals.clear();
    double total = 0.0;
    for (var equation in widget.equationHistory) {
      double value = equation.value * (equation.operator == 'x' ? equation.multiplier : 1);
      total += value;
      runningTotals.add(total);
    }
  }

  void _updateEquation(int index, String operator, String value, String? multiplier) {
    setState(() {
      double parsedValue = double.tryParse(value) ?? widget.equationHistory[index].value;
      int parsedMultiplier = multiplier != null ? int.tryParse(multiplier) ?? 1 : 1;
      widget.equationHistory[index] = EquationPieces(
        operator: operator,
        value: parsedValue,
        multiplier: parsedMultiplier,
      );
      _calculateRunningTotals();
    });
  }

  void _returnUpdatedTotal() {
    Navigator.pop(context, runningTotals.isNotEmpty ? runningTotals.last : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equation History'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _returnUpdatedTotal,
          ),
      ),
      body: ListView.builder(
        itemCount: widget.equationHistory.length,
        itemBuilder: (context, index) {
          final equation = widget.equationHistory[index];
          TextEditingController valueController = TextEditingController(text: equation.value.toString());
          TextEditingController multiplierController = TextEditingController(text: equation.multiplier.toString());

          return ListTile(
            title: Row(
              children: [
                DropdownButton<String>(
                  value: equation.operator,
                  items: ['+', 'x'].map((String operator) {
                    return DropdownMenuItem<String>(
                      value: operator,
                      child: Text(operator),
                    );
                  }).toList(),
                  onChanged: (String? newOperator) {
                    if (newOperator != null) {
                      _updateEquation(index, newOperator, valueController.text, newOperator == 'x' ? multiplierController.text : null);
                    }
                  },
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: valueController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (newValue) {
                      _updateEquation(index, equation.operator, newValue, equation.operator == 'x' ? multiplierController.text : null);
                    },
                  ),
                ),
                if (equation.operator == 'x') ...[
                  SizedBox(width: 8),
                  Text('x'),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: multiplierController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (newMultiplier) {
                        _updateEquation(index, equation.operator, valueController.text, newMultiplier);
                      },
                    ),
                  ),
                ],
                SizedBox(width: 16),
                Text('\$${runningTotals[index].toStringAsFixed(2)}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
