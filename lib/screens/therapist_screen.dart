import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/semaforo_widget.dart';

class TherapistScreen extends StatefulWidget {
  const TherapistScreen({super.key});

  @override
  State<TherapistScreen> createState() => _TherapistScreenState();
}

class _TherapistScreenState extends State<TherapistScreen> {
  final _tokenController = TextEditingController();
  final _nameController = TextEditingController();

  String? _patientToken;

  final List<Map<String, String>> _savedPatients = [];
  Map<String, String>? _selectedSavedPatient;

  final Color bgColor = const Color(0xFFF5F9FC);
  final Color primaryColor = const Color(0xFF4A90E2);

  @override
  void dispose() {
    _tokenController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _monitorPatient() {
    final token = _tokenController.text.trim();
    final name = _nameController.text.trim();

    if (token.isNotEmpty) {
      setState(() {
        _patientToken = token;

        if (name.isNotEmpty) {
          final exists = _savedPatients.any((p) => p['token'] == token);
          if (!exists) {
            _savedPatients.add({'name': name, 'token': token});
            _tokenController.clear();
            _nameController.clear();
          }
        }
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _selectSavedPatient(Map<String, String>? patient) {
    if (patient != null) {
      setState(() {
        _selectedSavedPatient = patient;
        _patientToken = patient['token'];
        _tokenController.text = patient['token']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Monitor de Riesgo',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: _patientToken == null || _patientToken!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.monitor_heart_outlined,
                                size: 100, color: Colors.grey[300]),
                            const SizedBox(height: 20),
                            Text("Pidele token a tu paciente esta en su perfil",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400])),
                            Text("Ingresa un token abajo para comenzar",
                                style: TextStyle(color: Colors.grey[400])),
                          ],
                        ),
                      )
                    : StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('resumen_riesgo')
                            .doc(_patientToken)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_rounded,
                                      size: 60, color: Colors.orange[300]),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Paciente no encontrado",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          }

                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: SemaforoDisplay(data: data),
                            ),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_savedPatients.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.history_rounded,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Text(
                          "Historial de Sesión:",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map<String, String>>(
                          hint: const Text("Seleccionar reciente...",
                              style: TextStyle(fontSize: 14)),
                          value: _selectedSavedPatient,
                          isExpanded: true,
                          isDense: true,
                          items: _savedPatients.map((patient) {
                            return DropdownMenuItem(
                              value: patient,
                              child: Text(
                                "${patient['name']} (${patient['token']!.substring(0, 4)}...)",
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: _selectSavedPatient,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _tokenController,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'Token ID',
                            hintText: 'Pegar ID',
                            filled: true,
                            fillColor: bgColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'Alias',
                            hintText: 'Ej. Ana',
                            filled: true,
                            fillColor: bgColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: _monitorPatient,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.search_rounded,
                          color: Colors.white, size: 20),
                      label: const Text(
                        'Monitorear Paciente',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
