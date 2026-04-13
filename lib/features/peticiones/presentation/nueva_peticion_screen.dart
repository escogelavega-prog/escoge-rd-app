import 'package:escoge/features/peticiones/services/peticiones_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NuevaPeticionScreen extends StatefulWidget {
  const NuevaPeticionScreen({super.key});

  @override
  State<NuevaPeticionScreen> createState() => _NuevaPeticionScreenState();
}

class _NuevaPeticionScreenState extends State<NuevaPeticionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textoController = TextEditingController();

  final PeticionesService _service = PeticionesService();

  bool _loading = false;

  String _categoriaSeleccionada = 'Familia';
  String _tipoVisibilidad = 'publica';

  final List<String> _categorias = const [
    'Salud',
    'Familia',
    'Estudios',
    'Trabajo',
    'Fortaleza espiritual',
    'Gratitud',
    'Otra',
  ];

  Future<void> _publicarPeticion() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() => _loading = true);

    try {
      await _service.crearPeticion(
        userId: user.uid,
        userName: user.displayName ?? 'Usuario',
        texto: _textoController.text.trim(),
        categoria: _categoriaSeleccionada,
        tipoVisibilidad: _tipoVisibilidad,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Petición publicada correctamente.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al publicar petición: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  Widget _buildVisibilidadOption({
    required String value,
    required String title,
    required String subtitle,
  }) {
    final selected = _tipoVisibilidad == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tipoVisibilidad = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFD4AF37).withOpacity(0.12)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFD4AF37) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? const Color(0xFFD4AF37) : Colors.grey,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva petición'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Comparte tu intención de oración',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu comunidad podrá acompañarte espiritualmente.',
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _textoController,
                maxLines: 6,
                maxLength: 400,
                decoration: const InputDecoration(
                  hintText: 'Escribe aquí tu petición...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Debes escribir una petición.';
                  }

                  if (value.trim().length < 10) {
                    return 'La petición es demasiado corta.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                items: _categorias
                    .map(
                      (categoria) => DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _categoriaSeleccionada = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Visibilidad',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 14),
              _buildVisibilidadOption(
                value: 'publica',
                title: 'Pública',
                subtitle: 'Tu nombre aparecerá junto a la petición.',
              ),
              _buildVisibilidadOption(
                value: 'anonima',
                title: 'Anónima',
                subtitle:
                    'La comunidad verá tu intención, pero no tu identidad.',
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _loading ? null : _publicarPeticion,
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                        ),
                      )
                    : const Text('Publicar petición'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
