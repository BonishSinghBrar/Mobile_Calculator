import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bonish Calculator'),
        ),
        backgroundColor: Colors.grey, // Set the background color to grey
        body: Calculator(),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _output = '';

  void _onPressed(String text) {
    setState(() {
      if (_output == 'ERROR') {
        _output = '';
        _expression = '';
      }
      if (text == 'CE') {
        _output = '';
        _expression = '';
      } else if (text == 'C') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
          _output = _expression;
        }
      } else if (text == '=') {
        _calculate();
      } else {
        _expression += text;
        _output = _expression;
      }
    });
  }

  void _calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _output = eval.toString();
        _expression = '';
      });
    } catch (e) {
      setState(() {
        _output = 'ERROR';
        _expression = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(3.0),
            child: Text(
              _output,
              style: TextStyle(fontSize: 30.0),
            ),
          ),
        ),
        Divider(height: 10.0),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildRow(['7', '8', '9', '/']),
              _buildRow(['4', '5', '6', '*']),
              // Changed 'x' to '*'
              _buildRow(['1', '2', '3', '-']),
              _buildRow(['CE', '0', 'C', '+']),
              _buildRow(['', '', '.', '=']),
              // Additional row for decimal and equals
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(List<String> texts) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: texts
            .map((text) => _buildButton(text))
            .toList()
            .expand((widget) => [widget, SizedBox(width: 0.5)])
            .toList()
          ..removeLast(),
      ),
    );
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          _onPressed(text);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 30.0,
            color: text == 'CE' || text == 'C' || text == '=' || text == '/' ||
                text == '*' || text == '+' || text == '-'
                ? Colors.yellow
                : Colors
                .white54, // Changed text color to white for better visibility
          ),
        ),
      ),
    );
  }
}
