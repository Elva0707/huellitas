import 'package:flutter/material.dart';
import '../model/mascotas.dart';
import '../servicios/mascotas_service.dart';

class MascotasAdd extends StatefulWidget {
  const MascotasAdd({super.key});

  @override
  State<MascotasAdd> createState() => _MascotasAddState();
}

class _MascotasAddState extends State<MascotasAdd> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _razaController = TextEditingController();
  final _edadController = TextEditingController();
  final _imagenController = TextEditingController();

  final MascotasService _service = MascotasService();
  bool _mostrarVistaPrevia = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _razaController.dispose();
    _edadController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: validator,
        onChanged: (value) {
          if (controller == _imagenController) {
            setState(() {
              _mostrarVistaPrevia = value.isNotEmpty;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Agregar Mascota",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Encabezado decorativo
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Nueva Mascota",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Completa los datos de tu compañero",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Formulario
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Información Básica",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      controller: _nombreController,
                      label: "Nombre",
                      icon: Icons.badge,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Ingrese el nombre" : null,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _razaController,
                      label: "Raza",
                      icon: Icons.category,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Ingrese la raza" : null,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _edadController,
                      label: "Edad (años)",
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Ingrese la edad";
                        if (int.tryParse(v) == null) {
                          return "Ingrese un número válido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Fotografía",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      controller: _imagenController,
                      label: "URL de la Imagen",
                      icon: Icons.image,
                      maxLines: 2,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Ingrese una URL" : null,
                    ),

                    const SizedBox(height: 20),

                    // Vista previa animada
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _mostrarVistaPrevia ? 250 : 0,
                      curve: Curves.easeInOut,
                      child: _mostrarVistaPrevia
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                _imagenController.text,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, _) => Container(
                                  color: Colors.red.shade300,
                                  child: const Center(
                                    child: Text(
                                      "Error al cargar imagen",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 30),

                    // --------------------------
                    // BOTÓN GUARDAR MODIFICADO
                    // --------------------------
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Loading
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Color(0xFF667eea),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text("Guardando...",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );

                                  await _service.addMascota(
                                    Mascota(
                                      id: "",
                                      nombre: _nombreController.text,
                                      raza: _razaController.text,
                                      edad: _edadController.text,
                                      imagen: _imagenController.text,
                                    ),
                                  );

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${_nombreController.text} agregado correctamente",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFE3F2FD), // Color suave
                                elevation: 8,
                                shadowColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check,
                                      size: 24, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text(
                                    "Guardar",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // TEXTO NEGRO
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Botón cancelar
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
