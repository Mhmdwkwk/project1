import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class NewtonScreen extends StatefulWidget {
  const NewtonScreen({super.key});

  @override
  State<NewtonScreen> createState() => _NewtonScreenState();
}

class _NewtonScreenState extends State<NewtonScreen> {
  final TextEditingController fxController = TextEditingController();
  final TextEditingController x0Controller = TextEditingController();
  final TextEditingController tolController = TextEditingController();

  final List<Map<String, dynamic>> results = [];

  @override
  void dispose() {
    fxController.dispose();
    x0Controller.dispose();
    tolController.dispose();
    super.dispose();
  }

  void calculateNewton() {
    results.clear();

    final fx = fxController.text.trim();
    final x0Text = x0Controller.text.trim();
    final tolText = tolController.text.trim();

    if (fx.isEmpty || x0Text.isEmpty || tolText.isEmpty) {
      setState(() {});
      return;
    }

    double x = double.parse(x0Text);
    final tol = double.parse(tolText);

    final p = Parser();
    final exp = p.parse(fx);
    final derivative = exp.derive('x');
    final cm = ContextModel();

    double? ea;
    double? prevXi;

    for (int i = 1; i <= 50; i++) {
      cm.bindVariable(Variable('x'), Number(x));
      final fxVal = exp.evaluate(EvaluationType.REAL, cm);
      final dfxVal = derivative.evaluate(EvaluationType.REAL, cm);

      if (dfxVal == 0) break;

      // Ea% للسطر الحالي (بين Xi و X(i-1))
      if (prevXi == null || x == 0) {
        ea = null;
      } else {
        ea = ((x - prevXi!).abs() / x.abs()) * 100;
      }

      results.add({
        "i": i,
        "xi": x,
        "fx": fxVal,
        "dfx": dfxVal,
        "ea": ea,
      });

      if (ea != null && ea <= tol) break;

      prevXi = x;
      x = x - (fxVal / dfxVal);
    }

    setState(() {});
  }

  Widget inputField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF8B6F47);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F1),
      appBar: AppBar(
        title: const Text("Newton Method"),
        backgroundColor: brand,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _InputCard(
                child: Column(
                  children: [
                    inputField(
                      hint: " f(x)",
                      controller: fxController,
                      keyboardType: TextInputType.text,
                    ),
                    inputField(
                      hint: "Initial Guess (x0)",
                      controller: x0Controller,
                      keyboardType: TextInputType.number,
                    ),
                    inputField(
                      hint: "Tolerance %",
                      controller: tolController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: calculateNewton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brand,
                          foregroundColor: Colors.black,
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text("Calculate"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // النتائج (Scroll لوحدها) — زي الصورة
              Expanded(
                child: results.isEmpty
                    ? const Center(
                  child: Text(
                    "No results yet",
                    style: TextStyle(color: Colors.black54),
                  ),
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateProperty.all(
                        const Color(0xFF8B6F47).withOpacity(0.2),
                      ),
                      columns: const [
                        DataColumn(label: Text("i")),
                        DataColumn(label: Text("Xi")),
                        DataColumn(label: Text("f(x)")),
                        DataColumn(label: Text("f'(x)")),
                        DataColumn(label: Text("Ea%")),
                      ],
                      rows: results.map((row) {
                        final int i = row["i"];
                        final double xi = row["xi"];
                        final double fx = row["fx"];
                        final double dfx = row["dfx"];
                        final double? ea = row["ea"];

                        return DataRow(
                          cells: [
                            DataCell(Text("$i")),
                            DataCell(Text(xi.toStringAsFixed(4))),
                            DataCell(Text(fx.toStringAsFixed(4))),
                            DataCell(Text(dfx.toStringAsFixed(4))),
                            DataCell(
                              Text(
                                ea == null ? "-" : "${ea.toStringAsFixed(3)}%",
                                style: TextStyle(
                                  color: ea == null ? Colors.black45 : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final Widget child;
  const _InputCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: child,
      ),
    );
  }
}
