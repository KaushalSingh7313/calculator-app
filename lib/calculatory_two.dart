import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = "0"; // Current input or result
  String input = ""; // Expression to be evaluated
  String history = ""; // Previous calculations stored

  // Method to handle button press
  void handleButtonPress(String value) {
    setState(() {
      if (value == "=") {
        if (input.isNotEmpty) {
          try {
            Parser parser = Parser();
            Expression expression = parser.parse(input);
            ContextModel contextModel = ContextModel();
            double eval = expression.evaluate(EvaluationType.REAL, contextModel);
            displayText = eval.toString();
            history += "$input = $displayText\n";
            input = displayText; // Carry forward result for further calculations
          } catch (e) {
            displayText = "Error";
            input = "";
          }
        }
      } else if (value == "AC") {
        input = "";
        displayText = "0";

      } else if (value == "C") {
        input = input.isNotEmpty ? input.substring(0, input.length - 1) : "";
        displayText = input.isEmpty ? "0" : input;
      } else {
        if (displayText == "0" && value != ".") {
          input = value; // Replace "0" with the input value
        } else {
          input += value;
        }

        displayText = input;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(

            icon: Icon(Icons.history, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Calculation History'),
                  content: Text(history.isEmpty ? "No history available" : history),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              color: Colors.white,
              child: Text(
                displayText,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: buildButtons(context),
          ),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context) {
    final List<String> buttons = [
      'AC', 'C', '%','/',
      '7', '8', '9', '+',
      '4', '5', '6', '-',
      '1', '2', '3', '*',
      '.', '0', '00','='
    ];

    return GridView.builder(
      padding: EdgeInsets.all(1),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2),
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: Center(
            child: ElevatedButton(
              onPressed: buttons[index].isNotEmpty
                  ? () => handleButtonPress(buttons[index])
                  : null, // Disable empty buttons
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(18),
                backgroundColor: Colors.tealAccent[100],
              ),
              child: Text(
                buttons[index],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[900]),
              ),
            ),
          ),
        );
      },
    );
  }
}

