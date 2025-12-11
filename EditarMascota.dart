import 'package:flutter/material.dart';
import '../model/mascotas.dart';
import '../servicios/mascotas_service.dart';

class MascotasEdit extends StatefulWidget {
  final Mascota mascota;

  const MascotasEdit({super.key, required this.mascota});

  @override
  State<MascotasEdit> createState() => _MascotasEditState();
}

class _MascotasEditState extends State<MascotasEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _razaController;
  late TextEditingController _edadController;
  late TextEditingController _imagenController;

  final MascotasService _service = MascotasService();
  bool _isLoading = false; // Estado para manejar la carga del botón

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los datos actuales
    _nombreController = TextEditingController(text: widget.mascota.nombre);
    _razaController = TextEditingController(text: widget.mascota.raza);
    _edadController = TextEditingController(text: widget.mascota.edad);
    _imagenController = TextEditingController(text: widget.mascota.imagen);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _razaController.dispose();
    _edadController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  // Función para manejar la actualización
  Future<void> _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mostrar indicador de carga
      });
      try {
        final updatedMascota = Mascota(
          id: widget.mascota.id,
          nombre: _nombreController.text,
          raza: _razaController.text,
          edad: _edadController.text,
          imagen: _imagenController.text,
        );
        await _service.updateMascota(updatedMascota);

        if (context.mounted) {
          // Mostrar un SnackBar de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mascota actualizada con éxito! 🐾'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Retorna true para indicar éxito
        }
      } catch (e) {
        if (context.mounted) {
          // Mostrar un SnackBar de error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al actualizar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false; // Ocultar indicador de carga
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definición de tema y colores para mejor estética
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Colors.orange; // Un color para destacar la imagen

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Mascota ✏️"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sección de Vista Previa de la Imagen
                _buildImagePreview(accentColor),
                
                const SizedBox(height: 20),

                // Formulario
                _buildFormCard(primaryColor),

                const SizedBox(height: 30),

                // Botones de Acción
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets de construcción de la interfaz ---

  Widget _buildImagePreview(Color accentColor) {
    return Column(
      children: [
        Text(
          "Vista Previa de la Imagen",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 10),
        // Contenedor para la imagen con estilo de tarjeta
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: accentColor.withOpacity(0.5), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _imagenController.text.isEmpty
                ? Center(
                    child: Icon(
                      Icons.pets,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                  )
                : Image.network(
                    _imagenController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50, color: Colors.red),
                            const SizedBox(height: 8),
                            const Text(
                              "Error al cargar imagen",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(Color primaryColor) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCustomTextFormField(
              controller: _nombreController,
              label: "Nombre",
              icon: Icons.person_outline,
              validatorMessage: "Ingrese el nombre de la mascota",
            ),
            const SizedBox(height: 15),
            _buildCustomTextFormField(
              controller: _razaController,
              label: "Raza",
              icon: Icons.category_outlined,
              validatorMessage: "Ingrese la raza",
            ),
            const SizedBox(height: 15),
            _buildCustomTextFormField(
              controller: _edadController,
              label: "Edad",
              icon: Icons.cake_outlined,
              keyboardType: TextInputType.number,
              validatorMessage: "Ingrese la edad",
              customValidator: (v) {
                if (v == null || v.isEmpty) {
                  return "Ingrese la edad";
                }
                if (int.tryParse(v) == null) {
                  return "Ingrese un número válido";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            _buildCustomTextFormField(
              controller: _imagenController,
              label: "URL de la Imagen",
              icon: Icons.image_outlined,
              validatorMessage: "Ingrese la URL de la imagen",
              hint: "https://ejemplo.com/imagen.jpg",
              onChanged: (value) {
                // Actualizar la vista previa cuando cambie la URL
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    String? Function(String?)? customValidator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: customValidator ??
          (v) => v == null || v.isEmpty ? validatorMessage : null,
      onChanged: onChanged,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _handleUpdate,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(_isLoading ? "Actualizando..." : "Actualizar"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text("Cancelar"),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}