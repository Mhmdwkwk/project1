import 'package:flutter/material.dart';

class GaussJordanPage extends StatefulWidget {
  const GaussJordanPage({super.key});

  @override
  State<GaussJordanPage> createState() => _GaussJordanPageState();
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

class _GaussJordanPageState extends State<GaussJordanPage> {
  List<List<double>> matrix =
  List.generate(3, (_) => List.filled(4, 0));

  List<GaussStep> steps = [];
  bool showSolution = false;

  // =========================
  // GAUSS JORDAN METHOD
  // =========================
  void calculateGaussJordan() {
    List<List<double>> a = matrix.map((e) => [...e]).toList();
    steps.clear();

    int n = 3;

    // Initial matrix
    steps.add(
      GaussStep(
        title: "Initial Matrix",
        operations: [],
        matrix: a.map((e) => [...e]).toList(),
      ),
    );

    for (int i = 0; i < n; i++) {
      List<String> ops = [];

      // 1. Normalize pivot row
      double pivot = a[i][i];

      if (pivot == 0) continue;

      for (int j = 0; j <= n; j++) {
        a[i][j] /= pivot;
      }

      ops.add("R${i + 1} = R${i + 1} ÷ ${pivot.toStringAsFixed(3)}");

      // 2. Eliminate all other rows (Jordan step)
      for (int k = 0; k < n; k++) {
        if (k != i) {
          double factor = a[k][i];

          for (int j = 0; j <= n; j++) {
            a[k][j] -= factor * a[i][j];
          }

          ops.add(
            "R${k + 1} = R${k + 1} - (${factor.toStringAsFixed(3)})R${i + 1}",
          );
        }
      }

      steps.add(
        GaussStep(
          title: "Step ${i + 1}",
          operations: ops,
          matrix: a.map((e) => [...e]).toList(),
        ),
      );
    }

    // Final solution directly from RREF
    steps.add(
      GaussStep(
        title: "Final Solution",
        operations: [
          "x = ${a[0][3].toStringAsFixed(3)}",
          "y = ${a[1][3].toStringAsFixed(3)}",
          "z = ${a[2][3].toStringAsFixed(3)}",
        ],
        matrix: [],
      ),
    );

    setState(() {
      showSolution = true;
    });
  }

  // =========================
  // MATRIX INPUT
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
  // MATRIX VIEW
  // =========================
  Widget buildMatrix(List<List<double>> m) {
    return Column(
      children: m.map((row) {
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
                style: const TextStyle(fontWeight: FontWeight.bold),
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
              BoxShadow(color: Colors.black12, blurRadius: 6),
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
                    (op) => Text("• $op"),
              ),

              const SizedBox(height: 10),

              if (step.matrix.isNotEmpty) buildMatrix(step.matrix),
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
        title: const Text("Gauss Jordan Method"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 6,
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
                      onPressed: calculateGaussJordan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 30,
                        ),
                      ),
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
            ]
          ],
        ),
      ),
    );
  }
}