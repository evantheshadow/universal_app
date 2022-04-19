import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:new_calc/main.dart';
import 'package:new_calc/screens/1_calc/button_style.dart';

class CalcScreen extends StatefulWidget {
  const CalcScreen({Key? key}) : super(key: key);

  @override
  _CalcScreenState createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  String previousNum = '';
  String currentNum = '';
  String result = '';
  String prevResult = "";
  String selectedOperation = '';

  _onButtonPressed(String value) {
    setState(() {
      switch (value) {
        case "/":
        case "*":
        case "-":
        case "^":
        case "+":
          if (previousNum != '') {
            _calculateResult();
          } else {
            previousNum = currentNum;
          }
          currentNum = '';
          selectedOperation = value;
          break;

        case "+/-":
          currentNum = convertStringToDouble(currentNum) < 0
              ? currentNum.replaceAll("-", '')
              : "-$currentNum";
          result = currentNum;
          break;

        case "%":
          currentNum = (convertStringToDouble(currentNum) / 100).toString();
          result = currentNum;
          break;

        case "=":
          _calculateResult();
          previousNum = '';
          selectedOperation = '';
          break;

        case "C":
          _resetCalculator();
          break;

        default:
          currentNum = currentNum + value;
          result = currentNum;
          prevResult = previousNum;
      }
    });
  }

  void _calculateResult() {
    double? _previousNum = convertStringToDouble(previousNum);
    double? _currentNum = convertStringToDouble(currentNum);
    String message = '';

    switch (selectedOperation) {
      case "^":
        if (_previousNum == null) {
          message = 'В степень должно возводиться число!';
          break;
        } else {
          _previousNum = pow(_previousNum!, _currentNum!) as double?;
        }
        break;

      case "+":
        if (_previousNum == null) {
          _previousNum = _currentNum!;
          break;
        } else {
          _previousNum = _previousNum! + _currentNum!;
        }
        break;

      case "-":
        if (_previousNum == null) {
          _previousNum = -(_currentNum!);
          break;
        } else {
          _previousNum = _previousNum! - _currentNum!;
        }
        break;

      case "/":
        if (_previousNum != 0 && _currentNum! == 0) {
          message = 'Нельзя делить на 0!';
          break;
        } else if (_previousNum == 0 && _currentNum! == 0) {
          _previousNum = _currentNum!;
          break;
        } else if (_previousNum == null) {
          message = 'Число должно делиться на число!';
          break;
        } else {
          print(_previousNum);
          _previousNum = _previousNum! / _currentNum!;
          break;
        }

      case "*":
        if (_previousNum == null) {
          message = 'Число должно умножаться на число!';
          break;
        } else {
          _previousNum = _previousNum! * _currentNum!;
        }
        break;
      default:
        break;
    }

    if (message == '') {
      currentNum =
          (_previousNum! % 1 == 0 ? _previousNum.toInt() : _previousNum)
              .toString();
    }
    print('currentNum: $currentNum');
    print('Message: $message');
    result = (message == '' ? currentNum : message);
  }

  void _resetCalculator() {
    previousNum = '';
    currentNum = '';
    result = '';
    selectedOperation = '';
    prevResult = '';
  }

  convertStringToDouble(String number) {
    return double.tryParse(number);
  }

  void _dragToDelete() {
    setState(() {
      if (result.length > 1) {
        result = result.substring(0, result.length - 1);
        currentNum = result;
      } else {
        result = '';
        currentNum = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Калькулятор'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xffe2ebf0),
              Color(0xffcfd9df),
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25),
                  child: Text(
                    prevResult,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 18),
                  child: Text(
                    selectedOperation,
                    style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onHorizontalDragEnd: (details) => {_dragToDelete()},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
                child: Text(
                  result,
                  style: TextStyle(
                      fontSize: result.length > 5 ? 50 : 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.61,
              child: Center(child: _buildButtonGrid()),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildButtonGrid() => StaggeredGridView?.countBuilder(
        crossAxisCount: 4,
        itemCount: buttons.length,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        itemBuilder: (context, index) {
          return MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 7,
            padding: const EdgeInsets.all(0),
            color:
                (buttons[index].value == selectedOperation && currentNum != "")
                    ? Colors.white
                    : buttons[index].bgColor,
            splashColor: Colors.purple,
            onPressed: () {
              _onButtonPressed(buttons[index].value);
            },
            child: Text(
              buttons[index].value,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: (buttons[index].value == selectedOperation &&
                          currentNum != "")
                      ? Colors.black
                      : buttons[index].fgColor),
            ),
          );
        },
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        staggeredTileBuilder: (index) => const StaggeredTile.count(1, 1),
      );
}
