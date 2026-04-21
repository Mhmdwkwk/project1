import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class IterationData {
  final int i;
  final double xi_1;
  final double fxi_1;
  final double xi;
  final double fxi;
  final String error;

  IterationData(
      this.i,
      this.xi_1,
      this.fxi_1,
      this.xi,
      this.fxi,
      this.error,
      );
}

class SecantPage extends StatefulWidget {
  const SecantPage({super.key});

  @override
  State<SecantPage> createState() => _SecantPageState();
}

class _SecantPageState extends State<SecantPage> {
  final equationController = TextEditingController();
  final x0Controller = TextEditingController();
  final x1Controller = TextEditingController();
  final tolController = TextEditingController();

  double? finalRoot;
  List<IterationData> iterations = [];

  double evaluateFunction(String equation, double x) {
    Parser p = Parser();
    Expression exp = p.parse(equation);
    ContextModel cm = ContextModel();
    cm.bindVariable(Variable('x'), Number(x));
    return exp.evaluate(EvaluationType.REAL, cm);
  }
  void calculateSecant() {
    iterations.clear();
    finalRoot = null;

    final eq = equationController.text.trim();
    final x0Text = x0Controller.text.trim();
    final x1Text = x1Controller.text.trim();
    final tolText = tolController.text.trim();

    if (eq.isEmpty || x0Text.isEmpty || x1Text.isEmpty || tolText.isEmpty) {
      setState(() {});
      return;
    }

    double x0 = double.parse(x0Text);
    double x1 = double.parse(x1Text);
    final tol = double.parse(tolText);

    
    iterations.add(
      IterationData(
        1,
        x0,
        evaluateFunction(eq, x0),
        x1,
        evaluateFunction(eq, x1),
        "-",
      ),
    );

    for (int i = 2; i <= 50; i++) {
      final fx0 = evaluateFunction(eq, x0);
      final fx1 = evaluateFunction(eq, x1);

      final denom = fx1 - fx0;
      if (denom == 0) break;

      final xNew = x1 - fx1 * (x0 - x1) / f(x0)-f(x1);
      final fxNew = evaluateFunction(eq, xNew);

      
      final ea = (xNew == 0) ? null : ((xNew - x1).abs() / xNew.abs()) * 100;

      iterations.add(
        IterationData(
          i,
          x1,
          fx1,
          xNew,
          fxNew,
          ea == null ? "-" : ea.toStringAsFixed(3),
        ),
      );

      if (ea != null && ea <= tol) {
        x1 = xNew;
        break;
      }

      x0 = x1;
      x1 = xNew;
    }

    setState(() => finalRoot = x1);
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
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }


  Widget buildIterationsTable() {
    if (iterations.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('i')),
          DataColumn(label: Text('xi-1')),
          DataColumn(label: Text('f(xi-1)')),
          DataColumn(label: Text('xi')),
          DataColumn(label: Text('f(xi)')),
          DataColumn(label: Text('Error')),
        ],
        rows: iterations.map((it) {
          return DataRow(cells: [
            DataCell(Text(it.i.toString())),
            DataCell(Text(it.xi_1.toStringAsPrecision(6))),
            DataCell(Text(it.fxi_1.toStringAsPrecision(6))),
            DataCell(Text(it.xi.toStringAsPrecision(6))),
            DataCell(Text(it.fxi.toStringAsPrecision(6))),
            DataCell(Text(it.error)),
          ]);
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    equationController.dispose();
    x0Controller.dispose();
    x1Controller.dispose();
    tolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Secant Method",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField(
              controller: equationController,
              label: "Enter f(x)",
              icon: Icons.functions,
            ),
            const SizedBox(height: 15),

            buildTextField(
              controller: x0Controller,
              label: "Enter X0",
              icon: Icons.looks_one,
              isNumber: true,
            ),
            const SizedBox(height: 15),

            buildTextField(
              controller: x1Controller,
              label: "Enter X1",
              icon: Icons.looks_two,
              isNumber: true,
            ),
            const SizedBox(height: 15),

            buildTextField(
              controller: tolController,
              label: "Tolerance (%)",
              icon: Icons.percent,
              isNumber: true,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateSecant,
              child: const Text("Calculate",style: TextStyle(color: Colors.black,fontSize: 20),),
            ),

            const SizedBox(height: 20),

            if (finalRoot != null)
              Text(
                "Final Root = ${finalRoot!.toStringAsPrecision(8)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),

            const SizedBox(height: 20),

            buildIterationsTable(),
          ],
        ),
      ),
    );
  }
}
