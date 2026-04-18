import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Iteration {
  final int i;
  final double xi;
  final double fxi;
  final double? ea;

  Iteration({
    required this.i,
    required this.xi,
    required this.fxi,
    this.ea,
  });
}

class SimpleFixedPointDark extends StatefulWidget {
  const SimpleFixedPointDark({super.key});

  @override
  State<SimpleFixedPointDark> createState() => _SimpleFixedPointDarkState();
}

class _SimpleFixedPointDarkState extends State<SimpleFixedPointDark> {
  final fxController = TextEditingController();
  final x0Controller = TextEditingController();
  final esController = TextEditingController();

  List<Iteration> table = [];
  bool showResult = false;

  // =========================
  // evaluate g(x)
  // =========================
  double evaluate(String expr, double x) {
    Parser p = Parser();
    Expression exp = p.parse(expr);
    ContextModel cm = ContextModel();
    cm.bindVariable(Variable('x'), Number(x));
    return exp.evaluate(EvaluationType.REAL, cm);
  }


  void calculate() {
    table.clear();

    double x0 = double.parse(x0Controller.text);
    double es = double.tryParse(esController.text) ?? 0.7;

    String fx = fxController.text;

    double xi = x0;
    double prev = x0;

    int maxIter = 50;

    for (int i = 1; i <= maxIter; i++) {
      double fxi = evaluate(fx, xi);

      double? ea;
      if (i > 1) {
        ea = ((xi - prev).abs() / xi) * 100;
      }

      table.add(
        Iteration(
          i: i,
          xi: xi,
          fxi: fxi,
          ea: ea,
        ),
      );

      if (ea != null && ea < es) break;

      prev = xi;
      xi = fxi;
    }

    setState(() {
      showResult = true;
    });
  }

  // =========================
  // table UI
  // =========================
  Widget buildTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
        MaterialStateProperty.all(const Color(0xFF1F1F1F)),
        dataRowColor:
        MaterialStateProperty.all(const Color(0xFF121212)),
        columns: const [
          DataColumn(label: Text("i", style: TextStyle(color: Colors.white))),
          DataColumn(label: Text("Xi", style: TextStyle(color: Colors.white))),
          DataColumn(label: Text("f(xi)", style: TextStyle(color: Colors.white))),
          DataColumn(label: Text("Ea %", style: TextStyle(color: Colors.white))),
        ],
        rows: table.map((e) {
          return DataRow(cells: [
            DataCell(Text("${e.i}", style: const TextStyle(color: Colors.white))),
            DataCell(Text(e.xi.toStringAsFixed(3),
                style: const TextStyle(color: Colors.white))),
            DataCell(Text(e.fxi.toStringAsFixed(3),
                style: const TextStyle(color: Colors.white))),
            DataCell(Text(
              e.ea == null ? "-" : "${e.ea!.toStringAsFixed(3)}%",
              style: const TextStyle(color: Colors.white),
            )),
          ]);
        }).toList(),
      ),
    );
  }

  // =========================
  // input UI
  // =========================
  Widget buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TextField(
            controller: fxController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "g(x)",
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          TextField(
            controller: x0Controller,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "X0",
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          TextField(
            controller: esController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "ES %",
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: calculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent.shade700,
              foregroundColor: Colors.black,
            ),
            child: const Text("Calculate"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: const Text("Simple Fixed Point"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildInput(),
            const SizedBox(height: 20),
            if (showResult)
              Expanded(child: buildTable()),
          ],
        ),
      ),
    );
  }
}