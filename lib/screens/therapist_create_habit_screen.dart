import 'package:flutter/material.dart';

class TherapistCreateHabitScreen extends StatefulWidget {
  final String patientName;

  const TherapistCreateHabitScreen({
    super.key,
    this.patientName = "Juan Pérez",
  });

  @override
  State<TherapistCreateHabitScreen> createState() =>
      _TherapistCreateHabitScreenState();
}

class _TherapistCreateHabitScreenState
    extends State<TherapistCreateHabitScreen> {
  final _habitNameController = TextEditingController();

  String _selectedCategory = 'Rutina Matutina';
  String _selectedFrequency = 'Diario';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  final List<String> _categories = [
    'Rutina Matutina',
    'Sueño y Descanso',
    'Actividad Física',
    'Mindfulness y Calma',
    'Socialización',
    'Alimentación',
    'Medicación'
  ];

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFFF5F9FC);
    final Color primaryColor = const Color(0xFF4A90E2);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Crear Nueva Rutina",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: Icon(Icons.person, color: primaryColor),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Asignando a:",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(widget.patientName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Detalles de la Rutina",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 15),
            _buildLabel("Nombre de la Actividad"),
            TextField(
              controller: _habitNameController,
              decoration: InputDecoration(
                hintText: "Ej. Caminata de 15 min",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.edit_note, color: primaryColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel("Categoría"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: primaryColor),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel("Frecuencia"),
            Row(
              children: [
                _buildChip("Diario", primaryColor),
                const SizedBox(width: 10),
                _buildChip("Semanal", primaryColor),
                const SizedBox(width: 10),
                _buildChip("3x Semana", primaryColor),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel("Hora Sugerida"),
            GestureDetector(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null)
                  setState(() {
                    _selectedTime = picked;
                  });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedTime.format(context),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Icon(Icons.access_time_rounded, color: primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Rutina asignada exitosamente"),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
                child: const Text("Guardar Rutina",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 5),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  Widget _buildChip(String label, Color color) {
    bool isSelected = _selectedFrequency == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFrequency = label;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2)),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4))
                  ]
                : [],
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
