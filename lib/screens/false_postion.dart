import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class FalsePositionPage extends StatefulWidget {
  const FalsePositionPage({super.key});

  @override
  State<FalsePositionPage> createState() => _FalsePositionPageState();
}

class IterationData {
  final int step;
  final double xl;
  final double fxl;
  final double xu;
  final double fxu;
  final double xr;
  final double fxr;
  final String error;

  IterationData(
      this.step,
      this.xl,
      this.fxl,
      this.xu,
      this.fxu,
      this.xr,
      this.fxr,
      this.error,
      );
}

class _FalsePositionPageState extends State<FalsePositionPage> {
  final equationController = TextEditingController();
  final xlController = TextEditingController();
  final xuController = TextEditingController();
  final tolController = TextEditingController();

  List<IterationData> iterations = [];
  double? finalRoot;

  double evaluateFunction(String equation, double xValue) {
    Parser p = Parser();
    Expression exp = p.parse(equation);
    ContextModel cm = ContextModel();
    cm.bindVariable(Variable('x'), Number(xValue));
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  void calculateFalse() {
    iterations.clear();
    finalRoot = null;

    double? xl = double.tryParse(xlController.text.trim());
    double? xu = double.tryParse(xuController.text.trim());
    double? tol = double.tryParse(tolController.text.trim());

    if (xl == null || xu == null || tol == null) return;
    if (xl >= xu) return;

    String eq = equationController.text;
    if (eq.isEmpty) return;

    double xlVal = xl;
    double xuVal = xu;

    double xr = 0;
    double xrOld = 0;

    double fxl = evaluateFunction(eq, xlVal);
    double fxu = evaluateFunction(eq, xuVal);

    if (fxl * fxu > 0) return;

    int step = 1;

    double? error;
    String errorDisplay = "-";

    while (true) {
      xrOld = xr;

      // False Position Formula
      xr = xuVal - (fxu * (xlVal - xuVal)) / (fxl - fxu);
      double fxr = evaluateFunction(eq, xr);

      // 🔥 Error Calculation (Fixed)
      if (step > 1 && xr != 0) {
        error = ((xr - xrOld).abs() / xr) * 100;
        errorDisplay = error.toStringAsFixed(6);
      } else {
        error = null;
        errorDisplay = "-";
      }

      iterations.add(
        IterationData(
          step,
          xlVal,
          fxl,
          xuVal,
          fxu,
          xr,
          fxr,
          errorDisplay,
        ),
      );

      // 🔥 Stop Conditions
      if (fxr == 0) break;
      if (error != null && error <= tol) break;

      // Update interval
      if (fxl * fxr < 0) {
        xuVal = xr;
        fxu = fxr;
      } else {
        xlVal = xr;
        fxl = fxr;
      }

      step++;
      if (step > 1000) break;
    }

    setState(() {
      finalRoot = xr;
    });
  }

  Widget buildIterationsTable() {
    if (iterations.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Step')),
          DataColumn(label: Text('xl')),
          DataColumn(label: Text('f(xl)')),
          DataColumn(label: Text('xu')),
          DataColumn(label: Text('f(xu)')),
          DataColumn(label: Text('xr')),
          DataColumn(label: Text('f(xr)')),
          DataColumn(label: Text('Error %')),
        ],
        rows: iterations.map((it) {
          return DataRow(cells: [
            DataCell(Text(it.step.toString())),
            DataCell(Text(it.xl.toStringAsFixed(6))),
            DataCell(Text(it.fxl.toStringAsFixed(6))),
            DataCell(Text(it.xu.toStringAsFixed(6))),
            DataCell(Text(it.fxu.toStringAsFixed(6))),
            DataCell(Text(it.xr.toStringAsFixed(6))),
            DataCell(Text(it.fxr.toStringAsFixed(6))),
            DataCell(Text(it.error)),
          ]);
        }).toList(),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "False Position Method",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    buildTextField(
                      controller: equationController,
                      label: "Enter Equation",
                      icon: Icons.functions,
                    ),
                    const SizedBox(height: 15),
                    buildTextField(
                      controller: xlController,
                      label: "Enter xl",
                      icon: Icons.arrow_downward,
                      isNumber: true,
                    ),
                    const SizedBox(height: 15),
                    buildTextField(
                      controller: xuController,
                      label: "Enter xu",
                      icon: Icons.arrow_upward,
                      isNumber: true,
                    ),
                    const SizedBox(height: 15),
                    buildTextField(
                      controller: tolController,
                      label: "Error %",
                      icon: Icons.percent,
                      isNumber: true,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: calculateFalse,
                      child: const Text(
                        "Calculate Root",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (finalRoot != null)
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "Final Root = ${finalRoot!.toStringAsPrecision(6)}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            if (iterations.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Iterations Table:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildIterationsTable(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
