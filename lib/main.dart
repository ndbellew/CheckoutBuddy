import 'package:flutter/material.dart';
import 'history_page.dart'; // Import the new file

void main() {
  runApp(GroceryCalculatorApp());
}

class GroceryCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class ParseResult {
  final bool isValid;
  final double? value;

  ParseResult({required this.isValid, this.value});
}

class EquationPieces {
  final String operator;
  final double value;
  final int multiplier;

  EquationPieces({
    required this.operator,
    required this.value,
    this.multiplier = 1,
  });
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  List<double> inputs = [];
  List<EquationPieces> equationHistory = [];
  String currentInput = '';
  double total = 0;
  double previousNumber = 0;

  bool isMultiplying = false;
  double? multiplyValue;

  ParseResult parseInput(String input) {
    bool isValid = true;
    double? value;
    try {
      value = double.parse(input);
    } catch (e) {
      isValid = false;
    }

    return ParseResult(isValid: isValid, value: value);
  }

  void numPressed(String num) {
    setState(() {
      if (currentInput == '0' && num != '.') {
        currentInput = num;
      } else {
        currentInput += num;
      }
      display = currentInput;
    });
  }

  void addPressed() {
    setState(() {
      if (currentInput.isNotEmpty) {
        double value = double.parse(currentInput);
        inputs.add(value);
        total += value;
        equationHistory.add(EquationPieces(operator: '+', value: value));
        currentInput = '';
        display = '0';
      }
    });
  }

  void multiplyPressed() {
    setState(() {
      if (currentInput.isNotEmpty) {
        double value = double.parse(currentInput);
        int multiplier = 1;
        double tempTotal = 0.0;

        if (isMultiplying && multiplyValue != null){
          multiplyValue = multiplyValue! * value;
        } else {
          multiplyValue = value;
          isMultiplying = true;
        }
        if (inputs.isEmpty) {
          inputs.add(value);
          total += value;
        } else {
          multiplier = int.parse(currentInput);
          tempTotal = value * multiplier;
          inputs.add(tempTotal);
          total += tempTotal;
        }
        equationHistory.add(EquationPieces(operator: 'x', value: value, multiplier: multiplier));
        currentInput = '';
        display = '0';
      }
    });
  }

  void equalsPressed() {
    setState(() {
      if (currentInput.isNotEmpty) {
        ParseResult result = parseInput(currentInput);
        if (result.isValid) {
          inputs.add(result.value!);
          total += result.value!;
        } else {
          currentInput = '';
          display = 'Invalid input';
        }
      }
      double result = inputs.fold(0, (sum, element) => sum + element);
      display = result.toString();
      inputs.clear();
      currentInput = '';
    });
  }

  void backspacePressed() {
    setState(() {
      if (currentInput.isNotEmpty) {
        currentInput = currentInput.substring(0, currentInput.length - 1);
        display = currentInput.isEmpty ? '0' : currentInput;
      }
    });
  }

  Future<void> viewHistory() async {
    final updatedTotal = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage(equationHistory: equationHistory)),
    );

    if (updatedTotal != null && updatedTotal is double) {
      setState(() {
        total = updatedTotal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: viewHistory,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                display,
                style: TextStyle(fontSize: 48),
              ),
            ),
          ),
          buildNumberPad(),
          buildOperationPad(),
        ],
      ),
    );
  }

  Widget buildNumberPad() {
  return Expanded(
    flex: 2,
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Column(
            children: <Widget>[
              buildNumberRow(['1', '2', '3']),
              buildNumberRow(['4', '5', '6']),
              buildNumberRow(['7', '8', '9']),
              buildNumberRow(['.', '0', '.99']),
            ],
          ),
        ),
        // Add a new Expanded widget to handle the operation buttons
        Container(
          width: 120, // Adjust the width as needed
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: backspacePressed,
                  child: Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Center(
                      child: Text(
                        '<',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              // Changed the '+' button to span the height of two rows
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: addPressed,
                  child: Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Center(
                      child: Text(
                        '+',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              // Ensured the 'x' button is the same height as the '.99' button
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: multiplyPressed,
                  child: Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Center(
                      child: Text(
                        'x',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildNumberRow(List<String> numbers) {
  return Flexible(
    fit: FlexFit.loose,
    child: Row(
      children: numbers.map((num) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              numPressed(num);
            },
            child: Container(
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Center(
                child: Text(
                  num,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}


  Widget buildOperationPad() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: equalsPressed,
            child: Container(
              margin: EdgeInsets.all(1),
              color: Colors.blue,
              child: Center(
                child: Text(
                  '=',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
