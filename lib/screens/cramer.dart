import 'package:flutter/material.dart';

class CramerStep {
  final String title;
  final List<String> operations;
  final List<List<double>> matrix;
  final double det;

  CramerStep({
    required this.title,
    required this.operations,
    required this.matrix,
    required this.det,
  });
}

class CramerPage extends StatefulWidget {
  const CramerPage({super.key});

  @override
  State<CramerPage> createState() => _CramerPageState();
}

class _CramerPageState extends State<CramerPage> {
  List<List<double>> A =
  List.generate(3, (_) => List.filled(4, 0));

  List<CramerStep> steps = [];
  bool show = false;

  double det3(List<List<double>> m) {
    return m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1]) -
        m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) +
        m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
  }

  List<List<double>> replaceCol(
      List<List<double>> m, int col, List<double> b) {
    List<List<double>> copy = m.map((e) => [...e]).toList();
    for (int i = 0; i < 3; i++) {
      copy[i][col] = b[i];
    }
    return copy;
  }

  void calculateCramer() {
    steps.clear();

    List<List<double>> a = A.map((e) => [...e]).toList();
    List<double> b = [a[0][3], a[1][3], a[2][3]];

    List<List<double>> Aonly = [
      [a[0][0], a[0][1], a[0][2]],
      [a[1][0], a[1][1], a[1][2]],
      [a[2][0], a[2][1], a[2][2]],
    ];

    double detA = det3(Aonly);

    steps.add(
      CramerStep(
        title: "Matrix A",
        operations: ["det(A) computed"],
        matrix: Aonly,
        det: detA,
      ),
    );

    List<List<double>> A1 = replaceCol(Aonly, 0, b);
    double d1 = det3(A1);

    List<List<double>> A2 = replaceCol(Aonly, 1, b);
    double d2 = det3(A2);

    List<List<double>> A3 = replaceCol(Aonly, 2, b);
    double d3 = det3(A3);

    steps.add(
      CramerStep(
        title: "A1 (x1 replaced)",
        operations: ["det(A1) = $d1"],
        matrix: A1,
        det: d1,
      ),
    );

    steps.add(
      CramerStep(
        title: "A2 (x2 replaced)",
        operations: ["det(A2) = $d2"],
        matrix: A2,
        det: d2,
      ),
    );

    steps.add(
      CramerStep(
        title: "A3 (x3 replaced)",
        operations: ["det(A3) = $d3"],
        matrix: A3,
        det: d3,
      ),
    );

    double x1 = d1 / detA;
    double x2 = d2 / detA;
    double x3 = d3 / detA;

    steps.add(
      CramerStep(
        title: "Final Solution",
        operations: [
          "x1 = det(A1)/det(A) = $x1",
          "x2 = det(A2)/det(A) = $x2",
          "x3 = det(A3)/det(A) = $x3",
        ],
        matrix: [],
        det: 0,
      ),
    );

    setState(() => show = true);
  }

  Widget matrixBox(List<List<double>> m) {
    return Column(
      children: m.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((v) {
            return Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Text(v.toStringAsFixed(2)),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget stepCard(CramerStep s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8),
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
              color: Colors.deepOrange,
            ),
          ),
          const SizedBox(height: 10),

          ...s.operations.map((e) => Text("• $e")),

          const SizedBox(height: 10),

          if (s.matrix.isNotEmpty) matrixBox(s.matrix),

          const SizedBox(height: 10),

          Text(
            "Det = ${s.det}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
            hintText: col == 3 ? "b" : "x",
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text("Cramer Rule"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  const SizedBox(height: 10),
                  inputGrid(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: calculateCramer,
                    child: const Text("Solve"),
                  )
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