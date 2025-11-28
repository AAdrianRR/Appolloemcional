import 'package:flutter/material.dart';

class TherapistProgressScreen extends StatefulWidget {
  const TherapistProgressScreen({super.key});

  @override
  State<TherapistProgressScreen> createState() =>
      _TherapistProgressScreenState();
}

class _TherapistProgressScreenState extends State<TherapistProgressScreen> {
  // Colores del tema Soft UI
  final Color bgColor = const Color(0xFFF5F9FC);
  final Color primaryColor = const Color(0xFF4A90E2);
  final Color riskHigh = const Color(0xFFFF7675);
  final Color riskMed = const Color(0xFFFDCB6E);
  final Color riskLow = const Color(0xFF55EFC4);

  // Variable para simular filtro de tiempo
  String _selectedRange = 'Últimos 7 días';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Análisis de Progreso",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRange,
                icon: Icon(Icons.calendar_today_rounded,
                    size: 18, color: primaryColor),
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                items: ['Últimos 7 días', 'Último Mes', 'Todo el año']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedRange = val!;
                  });
                },
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Panorama General",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 15),
            LayoutBuilder(
              builder: (context, constraints) {
                double cardWidth = (constraints.maxWidth - 20) / 2;
                if (constraints.maxWidth > 600)
                  cardWidth = (constraints.maxWidth - 40) / 3;

                return Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    _buildSummaryCard("Pacientes Activos", "24",
                        Icons.people_outline, Colors.blueAccent, cardWidth),
                    _buildSummaryCard("Riesgo Alto", "3",
                        Icons.warning_amber_rounded, riskHigh, cardWidth),
                    _buildSummaryCard("Estables", "18",
                        Icons.check_circle_outline, riskLow, cardWidth),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Tendencia de Riesgo (Semáforo)",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  // Barras Simuladas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBarChartItem("Lun", 30, riskLow),
                      _buildBarChartItem("Mar", 45, riskMed),
                      _buildBarChartItem("Mié", 20, riskLow),
                      _buildBarChartItem("Jue", 80, riskHigh), // Pico de crisis
                      _buildBarChartItem("Vie", 60, riskMed),
                      _buildBarChartItem("Sáb", 40, riskLow),
                      _buildBarChartItem("Dom", 25, riskLow),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendIndicator("Bajo", riskLow),
                      const SizedBox(width: 15),
                      _buildLegendIndicator("Medio", riskMed),
                      const SizedBox(width: 15),
                      _buildLegendIndicator("Alto", riskHigh),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Patrones Detectados por IA",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 5),
            const Text(
              "Eventos recientes analizados en diarios y chats.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            _buildPatternItem(
              date: "Hoy, 10:30 AM",
              patientName: "Juan Pérez",
              pattern: "Lenguaje de desesperanza",
              severityColor: riskHigh,
              icon: Icons.sentiment_very_dissatisfied,
            ),
            _buildPatternItem(
              date: "Ayer, 11:45 PM",
              patientName: "Ana García",
              pattern: "Alteración de sueño (Uso nocturno)",
              severityColor: riskMed,
              icon: Icons.access_time_filled,
            ),
            _buildPatternItem(
              date: "25 Nov, 09:00 AM",
              patientName: "Usuario Anónimo",
              pattern: "Palabras de baja autoestima",
              severityColor: riskMed,
              icon: Icons.group_off,
            ),
            _buildPatternItem(
              date: "24 Nov, 04:20 PM",
              patientName: "Carlos R.",
              pattern: "Mejora anímica consistente",
              severityColor: riskLow,
              icon: Icons.trending_up,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES DE DISEÑO ---

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 15),
          Text(value,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildBarChartItem(String day, double percentage, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: 150 * (percentage / 100), // Altura basada en porcentaje
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(height: 10),
        Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildLegendIndicator(String label, Color color) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildPatternItem({
    required String date,
    required String patientName,
    required String pattern,
    required Color severityColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: severityColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: severityColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pattern,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                Text("$patientName • $date",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
