import 'package:flutter/material.dart';

class LUStep {
  final String title;
  final List<String> operations;
  final List<List<double>> L;
  final List<List<double>> U;
  final List<double>? c;
  final List<double>? x;

  LUStep({
    required this.title,
    required this.operations,
    required this.L,
    required this.U,
    this.c,
    this.x,
  });
}

class LUPivotPage extends StatefulWidget {
  const LUPivotPage({super.key});

  @override
  State<LUPivotPage> createState() => _LUPivotPageState();
}

class _LUPivotPageState extends State<LUPivotPage> {
  List<List<double>> A =
  List.generate(3, (_) => List.filled(4, 0));

  List<LUStep> steps = [];
  bool show = false;

  void calculateLU() {
    steps.clear();

    List<List<double>> a = A.map((e) => [...e]).toList();
    int n = 3;

    List<List<double>> L =
    List.generate(n, (_) => List.filled(n, 0));
    List<List<double>> U =
    List.generate(n, (_) => List.filled(n, 0));

    for (int i = 0; i < n; i++) {
      L[i][i] = 1;
    }

    for (int i = 0; i < n; i++) {
      for (int k = i; k < n; k++) {
        double sum = 0;
        for (int j = 0; j < i; j++) {
          sum += L[i][j] * U[j][k];
        }
        U[i][k] = a[i][k] - sum;
      }

      for (int k = i + 1; k < n; k++) {
        double sum = 0;
        for (int j = 0; j < i; j++) {
          sum += L[k][j] * U[j][i];
        }
        L[k][i] = (a[k][i] - sum) / U[i][i];
      }

      steps.add(
        LUStep(
          title: "Step ${i + 1}",
          operations: [
            "Compute U row ${i + 1}",
            "Compute L column ${i + 1}",
          ],
          L: L.map((e) => [...e]).toList(),
          U: U.map((e) => [...e]).toList(),
        ),
      );
    }

    setState(() => show = true);
  }

  // ================= UI DESIGN =================

  Widget matrixBox(List<List<double>> m) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: m.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((v) {
              return Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Text(
                  v.toStringAsFixed(2),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget stepCard(LUStep s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),

          ...s.operations.map(
                (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text("• $e"),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "L Matrix",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          matrixBox(s.L),

          const SizedBox(height: 12),

          const Text(
            "U Matrix",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          matrixBox(s.U),
        ],
      ),
    );
  }

  Widget inputGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (c, i) {
        int r = i ~/ 4;
        int col = i % 4;

        return TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: col == 3 ? "b" : "x",
          ),
          onChanged: (v) {
            A[r][col] = double.tryParse(v) ?? 0;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text("LU Decomposition"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // INPUT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Enter Matrix",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  inputGrid(),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: calculateLU,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

            const SizedBox(height: 20),

            if (show)
              Column(
                children: steps.map(stepCard).toList(),
              )
          ],
        ),
      ),
    );
  }
}