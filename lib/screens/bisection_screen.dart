import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class BisectionPage extends StatefulWidget {
  const BisectionPage({super.key});

  @override
  State<BisectionPage> createState() => _BisectionPageState();
}

class IterationData {//تخزين البيانات
  final int i;
  final double xl, fxl, xr, fxr, xu, fxu;
  final double? ea;

  IterationData(
      this.i,
      this.xl,
      this.fxl,
      this.xr,
      this.fxr,
      this.xu,
      this.fxu,
      this.ea,
      );
}

class _BisectionPageState extends State<BisectionPage> {
  final equationController = TextEditingController();
  final xlController = TextEditingController();
  final xuController = TextEditingController();
  final esController = TextEditingController();

  List<IterationData> iterations = [];//عبارة عن ليست تخزن كل خطوة حصلت أثناء الحل.
  double? finalRoot;

  double evaluate(String eq, double x) {
    Parser p = Parser();//يحول المعادلة من String → حاجة يفهمها البرنامج
    Expression exp = p.parse(eq);
    ContextModel cm = ContextModel();
    cm.bindVariable(Variable('x'), Number(x));
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  void calculateBisection() {
    iterations.clear();
    finalRoot = null;

    double? xl = double.tryParse(xlController.text.trim());
    double? xu = double.tryParse(xuController.text.trim());
    double? es = double.tryParse(esController.text.trim());

    if (xl == null || xu == null || es == null) return;
    if (xl >= xu) return;

    String eq = equationController.text;
    if (eq.isEmpty) return;

    double xr = 0, oldXr = 0;

    double fxl = evaluate(eq, xl);
    double fxu = evaluate(eq, xu);

    if (fxl * fxu > 0) return;

    int i = 1;

    while (true) {
      oldXr = xr;
      xr = (xl! + xu!) / 2;
      double fxr = evaluate(eq, xr);

      double? ea;

      if (i > 1 && xr != 0) {
        ea = ((xr - oldXr).abs() / xr) * 100;
      }

      iterations.add(
        IterationData(i, xl, fxl, xr, fxr, xu, fxu, ea),
      );


      if (fxr == 0) break;
      if (ea != null && ea <= es) break;

      if (fxl * fxr > 0) {
        xl = xr;
        fxl = fxr;
      } else {
        xu = xr;
        fxu = fxr;
      }

      i++;
      if (i > 1000) break;
    }

    setState(() {
      finalRoot = xr;
    });
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
        prefixIcon: Icon(icon, color: Colors.deepPurple),
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

  Widget buildTable() {
    if (iterations.isEmpty) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('i')),
          DataColumn(label: Text('xl')),
          DataColumn(label: Text('f(xl)')),
          DataColumn(label: Text('xr')),
          DataColumn(label: Text('f(xr)')),
          DataColumn(label: Text('xu')),
          DataColumn(label: Text('f(xu)')),
          DataColumn(label: Text('Ea %')),
        ],
        rows: iterations.map((it) {
          return DataRow(cells: [
            DataCell(Text(it.i.toString())),
            DataCell(Text(it.xl.toStringAsFixed(6))),
            DataCell(Text(it.fxl.toStringAsFixed(6))),
            DataCell(Text(it.xr.toStringAsFixed(6))),
            DataCell(Text(it.fxr.toStringAsFixed(6))),
            DataCell(Text(it.xu.toStringAsFixed(6))),
            DataCell(Text(it.fxu.toStringAsFixed(6))),
            DataCell(Text(it.ea != null ? it.ea!.toStringAsFixed(6) : "-")),
          ]);
        }).toList(),
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
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Bisection Method",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
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
                      controller: esController,
                      label: "Error %",
                      icon: Icons.percent,
                      isNumber: true,
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: calculateBisection,
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
                  buildTable(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
