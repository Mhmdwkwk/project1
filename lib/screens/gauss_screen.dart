import 'package:flutter/material.dart';

class GaussPage extends StatefulWidget {
  const GaussPage({super.key});

  @override
  State<GaussPage> createState() => _GaussPageState();
}

class GaussStep {
  final String title;
  final List<String> operations;
  final List<List<double>> matrix;

  GaussStep({
    required this.title,
    required this.operations,
    required this.matrix,
  });
}

class _GaussPageState extends State<GaussPage> {
  List<List<double>> matrix =
  List.generate(3, (_) => List.filled(4, 0));

  List<GaussStep> steps = [];
  bool showSolution = false;

  // =========================
  // GAUSS ELIMINATION
  // =========================
  void calculateGauss() {
    List<List<double>> a = matrix.map((row) => [...row]).toList();
    steps.clear();

    int n = 3;


    steps.add(
      GaussStep(
        title: "Initial Matrix",
        operations: [],
        matrix: a.map((e) => [...e]).toList(),
      ),
    );

    // Forward Elimination
    for (int i = 0; i < n; i++) {
      List<String> ops = [];

      for (int k = i + 1; k < n; k++) {
        if (a[i][i] == 0) continue;

        double factor = a[k][i] / a[i][i];

        for (int j = i; j <= n; j++) {
          a[k][j] -= factor * a[i][j];
        }

        ops.add(
          "R${k + 1} = R${k + 1} - (${factor.toStringAsFixed(3)}) R${i + 1}",
        );
      }

      steps.add(
        GaussStep(
          title: "Step ${i + 1}",
          operations: ops,
          matrix: a.map((e) => [...e]).toList(),
        ),
      );
    }

    // Back Substitution
    List<double> x = List.filled(n, 0);

    for (int i = n - 1; i >= 0; i--) {
      x[i] = a[i][n];

      for (int j = i + 1; j < n; j++) {
        x[i] -= a[i][j] * x[j];
      }

      x[i] /= a[i][i];
    }

    steps.add(
      GaussStep(
        title: "Final Solution",
        operations: [
          "x = ${x[0].toStringAsFixed(3)}",
          "y = ${x[1].toStringAsFixed(3)}",
          "z = ${x[2].toStringAsFixed(3)}",
        ],
        matrix: [],
      ),
    );

    setState(() {
      showSolution = true;
    });
  }

  // =========================
  // MATRIX INPUT UI
  // =========================
  Widget buildMatrixInput() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ 4;
        int col = index % 4;

        return TextField(
          keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: col == 3 ? "b${row + 1}" : "x${col + 1}",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            matrix[row][col] = double.tryParse(value) ?? 0;
          },
        );
      },
    );
  }

  // =========================
  // MATRIX DISPLAY
  // =========================
  Widget buildMatrix(List<List<double>> matrix) {
    return Column(
      children: matrix.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((val) {
            return Container(
              width: 55,
              height: 45,
              margin: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                val.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  // =========================
  // STEPS UI
  // =========================
  Widget buildSteps() {
    return Column(
      children: steps.map((step) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              ...step.operations.map(
                    (op) => Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 2),
                  child: Text("• $op"),
                ),
              ),

              if (step.matrix.isNotEmpty) ...[
                const SizedBox(height: 10),
                buildMatrix(step.matrix),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Gauss Elimination",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // INPUT CARD
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Enter Matrix",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    buildMatrixInput(),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: calculateGauss,
                      child: const Text(
                        "Solve",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // STEPS
            if (showSolution) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Steps:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              buildSteps(),
            ],
          ],
        ),
      ),
    );
  }
}