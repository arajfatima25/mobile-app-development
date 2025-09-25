import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentNumber = "";
  double _num1 = 0;
  String _operator = "";

  void _buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      _clear();
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "x" ||
        buttonText == "/") {
      _handleOperator(buttonText);
    } else if (buttonText == ".") {
      _handleDecimal();
    } else if (buttonText == "=") {
      _calculate();
    } else {
      _handleNumber(buttonText);
    }
  }

  void _clear() {
    setState(() {
      _output = "0";
      _currentNumber = "";
      _num1 = 0;
      _operator = "";
    });
  }

  void _handleOperator(String operator) {
    setState(() {
      if (_currentNumber.isNotEmpty) {
        _num1 = double.parse(_currentNumber);
        _operator = operator;
        _currentNumber = "";
        _output = "$_num1 $_operator";
      }
    });
  }

  void _handleDecimal() {
    setState(() {
      if (!_currentNumber.contains(".")) {
        _currentNumber += ".";
        _output = _currentNumber;
      }
    });
  }

  void _calculate() {
    setState(() {
      if (_currentNumber.isNotEmpty && _operator.isNotEmpty) {
        double num2 = double.parse(_currentNumber);
        double result = 0;
        if (_operator == "+") {
          result = _num1 + num2;
        } else if (_operator == "-") {
          result = _num1 - num2;
        } else if (_operator == "x") {
          result = _num1 * num2;
        } else if (_operator == "/") {
          result = _num1 / num2;
        }
        _output = result.toString();
        _num1 = result;
        _currentNumber = "";
        _operator = "";
      }
    });
  }

  void _handleNumber(String number) {
    setState(() {
      _currentNumber += number;
      _output = _currentNumber;
    });
  }

  Widget _buildButton(String buttonText, Color buttonColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              _output,
              style: const TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
          const Divider(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton("7", Colors.black54),
                      _buildButton("8", Colors.black54),
                      _buildButton("9", Colors.black54),
                      _buildButton("/", Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton("4", Colors.black54),
                      _buildButton("5", Colors.black54),
                      _buildButton("6", Colors.black54),
                      _buildButton("x", Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton("1", Colors.black54),
                      _buildButton("2", Colors.black54),
                      _buildButton("3", Colors.black54),
                      _buildButton("-", Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton(".", Colors.black54),
                      _buildButton("0", Colors.black54),
                      _buildButton("00", Colors.black54),
                      _buildButton("+", Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton("CLEAR", Colors.redAccent),
                      _buildButton("=", Colors.green),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
