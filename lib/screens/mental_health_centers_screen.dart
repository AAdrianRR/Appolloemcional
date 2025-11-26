import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class MentalHealthCenter {
  final String nombre;
  final String direccion;
  final String telefono;
  final String horario;
  final String servicios;
  final String tipo; // 'publico', 'asociacion', 'hospital'
  final double? lat;
  final double? lng;

  MentalHealthCenter({
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.horario,
    required this.servicios,
    required this.tipo,
    this.lat,
    this.lng,
  });
}

class MentalHealthCentersScreen extends StatefulWidget {
  const MentalHealthCentersScreen({super.key});

  @override
  State<MentalHealthCentersScreen> createState() =>
      _MentalHealthCentersScreenState();
}

class _MentalHealthCentersScreenState extends State<MentalHealthCentersScreen> {
  String _selectedFilter =
      'todos'; // 'todos', 'publico', 'asociacion', 'hospital'

  double scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width / 390;
  }

  // CENTROS DE AYUDA EN DURANGO
  final List<MentalHealthCenter> _centers = [
    MentalHealthCenter(
      nombre: 'Centro de Salud Mental Durango',
      direccion: 'Blvd. Felipe Pescador 1501, Nueva Vizcaya, 34080 Durango',
      telefono: '6188137000',
      horario: 'Lunes a Viernes: 8:00 AM - 8:00 PM',
      servicios: 'Atención psicológica, psiquiátrica, terapia grupal',
      tipo: 'publico',
      lat: 24.0277,
      lng: -104.6532,
    ),
    MentalHealthCenter(
      nombre: 'Hospital General 450 - Servicio de Psiquiatría',
      direccion: 'Av. 5 de Febrero 220, Zona Centro, 34000 Durango',
      telefono: '6188251650',
      horario: '24 horas (Urgencias)',
      servicios: 'Urgencias psiquiátricas, hospitalización, consulta externa',
      tipo: 'hospital',
      lat: 24.0260,
      lng: -104.6678,
    ),
    MentalHealthCenter(
      nombre: 'DIF Durango - Área de Psicología',
      direccion: 'Blvd. Dolores del Río 100, Guadalupe, 34120 Durango',
      telefono: '6188259200',
      horario: 'Lunes a Viernes: 9:00 AM - 5:00 PM',
      servicios: 'Terapia psicológica gratuita, orientación familiar',
      tipo: 'publico',
      lat: 24.0365,
      lng: -104.6593,
    ),
    MentalHealthCenter(
      nombre: 'SAPTEL Durango - Línea de Crisis',
      direccion: 'Teléfono de atención (no requiere cita)',
      telefono: '6188180800',
      horario: '24 horas, 7 días a la semana',
      servicios:
          'Línea telefónica de apoyo emocional y prevención del suicidio',
      tipo: 'asociacion',
    ),
    MentalHealthCenter(
      nombre: 'Centro Integral de Salud Mental (CISAME)',
      direccion: 'Calle Constitución 100 Sur, Zona Centro, 34000 Durango',
      telefono: '6188272600',
      horario: 'Lunes a Viernes: 8:00 AM - 4:00 PM',
      servicios: 'Atención psicológica, terapia ocupacional, grupos de apoyo',
      tipo: 'publico',
      lat: 24.0235,
      lng: -104.6653,
    ),
    MentalHealthCenter(
      nombre: 'Cruz Roja Durango - Apoyo Psicológico',
      direccion: 'Av. Universidad s/n, Benito Juárez, 34260 Durango',
      telefono: '6188252525',
      horario: 'Lunes a Sábado: 8:00 AM - 8:00 PM',
      servicios: 'Primera atención psicológica, orientación en crisis',
      tipo: 'asociacion',
      lat: 24.0156,
      lng: -104.6445,
    ),
  ];

  List<MentalHealthCenter> get _filteredCenters {
    if (_selectedFilter == 'todos') return _centers;
    return _centers.where((c) => c.tipo == _selectedFilter).toList();
  }

  //  LLAMAR
  Future<void> _makeCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError('No se pudo abrir el marcador');
      }
    } catch (e) {
      _showError('Error al intentar llamar: $e');
    }
  }

  // ABRIR EN MAPS
  Future<void> _openInMaps(double? lat, double? lng, String nombre) async {
    if (lat == null || lng == null) {
      _showError('Ubicación no disponible');
      return;
    }

    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError('No se pudo abrir Google Maps');
      }
    } catch (e) {
      _showError('Error al abrir mapa: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = scale(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20 * s),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FadeInLeft(
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: AppTheme.foreground, size: 28 * s),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Expanded(
                          child: FadeInDown(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Centros de Ayuda',
                                    style:
                                        AppTheme.h2.copyWith(fontSize: 24 * s)),
                                Text('Durango, México',
                                    style: AppTheme.caption
                                        .copyWith(fontSize: 14 * s)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20 * s),

                    // Filtros
                    FadeIn(
                      delay: const Duration(milliseconds: 200),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                                'Todos', 'todos', Icons.healing, s),
                            SizedBox(width: 8 * s),
                            _buildFilterChip('Públicos', 'publico',
                                Icons.account_balance, s),
                            SizedBox(width: 8 * s),
                            _buildFilterChip('Hospitales', 'hospital',
                                Icons.local_hospital, s),
                            SizedBox(width: 8 * s),
                            _buildFilterChip('Asociaciones', 'asociacion',
                                Icons.volunteer_activism, s),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de centros
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16 * s),
                  itemCount: _filteredCenters.length,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      delay: Duration(milliseconds: 300 + (index * 100)),
                      child:
                          _buildCenterCard(_filteredCenters[index], index, s),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon, double s) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 10 * s),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.cyanGradient : null,
          color: isSelected ? null : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Colors.white.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18 * s,
                color: isSelected ? Colors.white : AppTheme.foreground),
            SizedBox(width: 6 * s),
            Text(
              label,
              style: TextStyle(
                fontSize: 14 * s,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterCard(MentalHealthCenter center, int index, double s) {
    final colors = {
      'publico': Colors.blue.shade400,
      'hospital': Colors.red.shade400,
      'asociacion': Colors.green.shade400,
    };
    final color = colors[center.tipo] ?? Colors.grey;

    return Container(
      margin: EdgeInsets.only(bottom: 16 * s),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16 * s),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icono tipo
                    Container(
                      padding: EdgeInsets.all(10 * s),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        center.tipo == 'hospital'
                            ? Icons.local_hospital
                            : center.tipo == 'asociacion'
                                ? Icons.volunteer_activism
                                : Icons.account_balance,
                        color: color,
                        size: 24 * s,
                      ),
                    ),
                    SizedBox(width: 12 * s),

                    // Nombre y tipo
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            center.nombre,
                            style: TextStyle(
                              fontSize: 16 * s,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.foreground,
                            ),
                          ),
                          SizedBox(height: 4 * s),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8 * s, vertical: 4 * s),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              center.tipo == 'publico'
                                  ? 'Público'
                                  : center.tipo == 'hospital'
                                      ? 'Hospital'
                                      : 'Asociación',
                              style: TextStyle(
                                fontSize: 11 * s,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12 * s),

                // Dirección
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on,
                        size: 16 * s, color: AppTheme.mutedForeground),
                    SizedBox(width: 6 * s),
                    Expanded(
                      child: Text(
                        center.direccion,
                        style: TextStyle(
                          fontSize: 13 * s,
                          color: AppTheme.foreground,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8 * s),

                // Horario
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 16 * s, color: AppTheme.mutedForeground),
                    SizedBox(width: 6 * s),
                    Expanded(
                      child: Text(
                        center.horario,
                        style: TextStyle(
                          fontSize: 13 * s,
                          color: AppTheme.foreground,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8 * s),

                // Servicios
                Container(
                  padding: EdgeInsets.all(10 * s),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    center.servicios,
                    style: TextStyle(
                      fontSize: 12 * s,
                      color: AppTheme.foreground,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 12 * s),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _makeCall(center.telefono),
                        icon: Icon(Icons.phone, size: 18 * s),
                        label:
                            Text('Llamar', style: TextStyle(fontSize: 13 * s)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12 * s),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    if (center.lat != null && center.lng != null) ...[
                      SizedBox(width: 8 * s),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openInMaps(
                              center.lat, center.lng, center.nombre),
                          icon: Icon(Icons.map, size: 18 * s),
                          label:
                              Text('Mapa', style: TextStyle(fontSize: 13 * s)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade400,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12 * s),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
