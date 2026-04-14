import 'dart:convert';
import 'dart:io';

import 'package:escoge/features/oracion/services/liturgia_seed_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiturgiaSeedScreen extends StatelessWidget {
  const LiturgiaSeedScreen({
    super.key,
    required this.userRole,
  });

  final String userRole;

  bool get _isSuperAdmin => userRole.trim().toLowerCase() == 'superadmin';

  @override
  Widget build(BuildContext context) {
    if (!_isSuperAdmin) {
      return const _LiturgiaSeedAccessDeniedView();
    }

    return const _LiturgiaSeedAdminView();
  }
}

class _LiturgiaSeedAccessDeniedView extends StatelessWidget {
  const _LiturgiaSeedAccessDeniedView();

  static const Color _primaryBlue = Color(0xFF0B1E66);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _bg = Color(0xFFF4F6FB);
  static const Color _textDark = Color(0xFF1A1F36);
  static const Color _textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: _primaryBlue,
        title: Text(
          'Acceso restringido',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE8ECF4)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D0F172A),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 74,
                width: 74,
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 34,
                  color: _gold,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Sección exclusiva de superadmin',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'No tienes permisos para acceder a la herramienta de carga litúrgica.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.5,
                  color: _textMuted,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: Text(
                    'Volver',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiturgiaSeedAdminView extends StatefulWidget {
  const _LiturgiaSeedAdminView();

  @override
  State<_LiturgiaSeedAdminView> createState() => _LiturgiaSeedAdminViewState();
}

class _LiturgiaSeedAdminViewState extends State<_LiturgiaSeedAdminView> {
  static const Color _primaryBlue = Color(0xFF0B1E66);
  static const Color _secondaryBlue = Color(0xFF1736B6);
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _bg = Color(0xFFF4F6FB);
  static const Color _textDark = Color(0xFF1A1F36);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _success = Color(0xFF1F9D55);
  static const Color _warning = Color(0xFFD97706);
  static const Color _danger = Color(0xFFDC2626);

  final LiturgiaSeedService _seedService = LiturgiaSeedService();

  bool _isPickingFile = false;
  bool _isPreviewLoading = false;
  bool _isLoading = false;
  bool _overwrite = false;

  String? _selectedFileName;
  String? _selectedFilePath;
  String? _rawJson;

  LiturgiaSeedPreviewResult? _preview;
  LiturgiaSeedResult? _result;
  String? _statusMessage;

  Future<void> _pickJsonFile() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isPickingFile = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: false,
      );

      if (!mounted) return;

      if (result == null || result.files.isEmpty) {
        setState(() {
          _statusMessage = 'No se seleccionó ningún archivo.';
        });
        return;
      }

      final file = result.files.single;

      String rawJson = '';

      if ((file.path ?? '').isNotEmpty) {
        rawJson = await File(file.path!).readAsString();
      } else if (file.bytes != null) {
        rawJson = utf8.decode(file.bytes!);
      } else {
        throw Exception('No se pudo leer el contenido del archivo.');
      }

      if (rawJson.trim().isEmpty) {
        setState(() {
          _selectedFileName = null;
          _selectedFilePath = null;
          _rawJson = null;
          _preview = null;
          _result = null;
          _statusMessage =
              'El archivo seleccionado está vacío o no pudo leerse.';
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _danger,
            content: const Text('No se pudo leer el archivo JSON.'),
          ),
        );
        return;
      }

      setState(() {
        _selectedFileName = file.name;
        _selectedFilePath = file.path;
        _rawJson = rawJson;
        _preview = null;
        _result = null;
        _statusMessage = 'Archivo seleccionado correctamente.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _success,
          content: Text('Archivo seleccionado: ${file.name}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Ocurrió un error al seleccionar el archivo.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _danger,
          content: Text('Error al seleccionar archivo: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isPickingFile = false;
      });
    }
  }

  Future<void> _runPreview() async {
    FocusScope.of(context).unfocus();

    if ((_rawJson ?? '').trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes seleccionar un archivo JSON.'),
        ),
      );
      return;
    }

    setState(() {
      _isPreviewLoading = true;
      _statusMessage = 'Validando archivo litúrgico...';
      _preview = null;
      _result = null;
    });

    try {
      final preview = await _seedService.previewFromJsonString(
        rawJson: _rawJson!,
      );

      if (!mounted) return;

      setState(() {
        _preview = preview;
        _statusMessage = preview.hasErrors
            ? 'La validación terminó con errores globales.'
            : 'Validación completada correctamente.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: preview.hasErrors ? _warning : _success,
          content: Text(
            preview.hasErrors
                ? 'Validación completada con observaciones.'
                : 'Archivo validado correctamente.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Ocurrió un error al validar el archivo.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _danger,
          content: Text('Error al validar: $e'),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isPreviewLoading = false;
      });
    }
  }

  Future<void> _runSeed() async {
    FocusScope.of(context).unfocus();

    if ((_rawJson ?? '').trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes seleccionar un archivo JSON.'),
        ),
      );
      return;
    }

    if (_preview == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primero debes validar el archivo antes de cargarlo.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Procesando carga litúrgica...';
      _result = null;
    });

    try {
      final result = await _seedService.seedFromJsonString(
        rawJson: _rawJson!,
        overwrite: _overwrite,
      );

      if (!mounted) return;

      setState(() {
        _result = result;
        _statusMessage = result.hasErrors
            ? 'La carga terminó con observaciones.'
            : 'Carga completada correctamente.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result.hasErrors ? _warning : _success,
          content: Text(
            result.hasErrors
                ? 'Carga completada con observaciones.'
                : 'Liturgia cargada correctamente.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Ocurrió un error al cargar la liturgia.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _danger,
          content: Text('Error al ejecutar la carga: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _statusColor() {
    if (_isPickingFile || _isPreviewLoading || _isLoading) {
      return _secondaryBlue;
    }
    if (_result != null && _result!.hasErrors) return _warning;
    if (_preview != null && _preview!.hasErrors) return _warning;
    if (_result != null || _preview != null || _rawJson != null) {
      return _success;
    }
    return _textMuted;
  }

  IconData _statusIcon() {
    if (_isPickingFile || _isPreviewLoading || _isLoading) {
      return Icons.sync_rounded;
    }
    if (_result != null && _result!.hasErrors) {
      return Icons.warning_amber_rounded;
    }
    if (_preview != null && _preview!.hasErrors) {
      return Icons.warning_amber_rounded;
    }
    if (_result != null || _preview != null || _rawJson != null) {
      return Icons.check_circle_rounded;
    }
    return Icons.info_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final responsiveRatio =
        MediaQuery.of(context).size.width < 380 ? 1.05 : 1.18;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryBlue,
        centerTitle: true,
        title: Text(
          'Cargar liturgia',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            _HeroAdminCard(
              primaryBlue: _primaryBlue,
              secondaryBlue: _secondaryBlue,
              gold: _gold,
            ),
            const SizedBox(height: 18),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Archivo fuente',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona un archivo JSON desde el dispositivo para validarlo y luego cargarlo a Firestore.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: _textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedFileName ?? 'Ningún archivo seleccionado',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _selectedFileName == null
                                ? _textMuted
                                : _primaryBlue,
                          ),
                        ),
                        if ((_selectedFilePath ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            _selectedFilePath!,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: _textMuted,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    value: _overwrite,
                    // ignore: deprecated_member_use
                    activeColor: _gold,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Sobrescribir documentos existentes',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    subtitle: Text(
                      _overwrite
                          ? 'Los documentos existentes con la misma fecha serán reemplazados.'
                          : 'Si ya existe una fecha, ese documento será omitido.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _textMuted,
                      ),
                    ),
                    onChanged:
                        (_isPickingFile || _isLoading || _isPreviewLoading)
                            ? null
                            : (value) {
                                setState(() {
                                  _overwrite = value;
                                });
                              },
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed:
                          (_isPickingFile || _isLoading || _isPreviewLoading)
                              ? null
                              : _pickJsonFile,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primaryBlue,
                        side: BorderSide(
                          color: _primaryBlue.withValues(alpha: 0.22),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: _isPickingFile
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.attach_file_rounded),
                      label: Text(
                        _isPickingFile
                            ? 'Seleccionando...'
                            : 'Seleccionar archivo JSON',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: (_isPickingFile ||
                                  _isLoading ||
                                  _isPreviewLoading)
                              ? null
                              : _runPreview,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _primaryBlue,
                            side: BorderSide(
                              color: _primaryBlue.withValues(alpha: 0.22),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          icon: _isPreviewLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.visibility_rounded),
                          label: Text(
                            _isPreviewLoading
                                ? 'Validando...'
                                : 'Validar archivo',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (_isPickingFile ||
                                  _isLoading ||
                                  _isPreviewLoading)
                              ? null
                              : _runSeed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryBlue,
                            disabledBackgroundColor:
                                _primaryBlue.withValues(alpha: 0.55),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.cloud_upload_rounded),
                          label: Text(
                            _isLoading ? 'Cargando...' : 'Ejecutar carga',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado del proceso',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _statusColor().withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _statusColor().withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(_statusIcon(), color: _statusColor()),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _statusMessage ??
                                'Aún no se ha seleccionado, validado ni cargado ningún archivo.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de carga',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: responsiveRatio,
                    children: [
                      _MetricCard(
                        title: 'Total',
                        value:
                            (_result?.total ?? _preview?.total ?? 0).toString(),
                        icon: Icons.dataset_rounded,
                        color: _primaryBlue,
                      ),
                      _MetricCard(
                        title: 'Creados',
                        value: (_result?.created ?? 0).toString(),
                        icon: Icons.add_circle_rounded,
                        color: _success,
                      ),
                      _MetricCard(
                        title: 'Actualizados',
                        value: (_result?.updated ?? 0).toString(),
                        icon: Icons.refresh_rounded,
                        color: _secondaryBlue,
                      ),
                      _MetricCard(
                        title: 'Omitidos',
                        value: (_result?.skipped ?? 0).toString(),
                        icon: Icons.skip_next_rounded,
                        color: _warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previsualización',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_preview == null)
                    const _EmptyBox(
                      message: 'Aún no has validado el archivo JSON.',
                    )
                  else ...[
                    if (_preview!.globalErrors.isNotEmpty)
                      ..._preview!.globalErrors.map(
                        (error) => _WarningBox(message: error, danger: true),
                      ),
                    if (_preview!.items.isEmpty)
                      const _EmptyBox(
                        message:
                            'No se encontraron documentos válidos para mostrar.',
                      )
                    else
                      ..._preview!.items.map(
                        (item) => _PreviewLiturgiaCard(item: item),
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Observaciones y errores de carga',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if ((_result?.errors.isEmpty ?? true))
                    const _EmptyBox(
                      message: 'No hay errores registrados por el momento.',
                    )
                  else
                    ..._result!.errors.map(
                      (error) => _WarningBox(message: error, danger: true),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Herramienta interna de producción para validación y carga controlada de liturgia. Su acceso está restringido exclusivamente a superadmin.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewLiturgiaCard extends StatelessWidget {
  const _PreviewLiturgiaCard({
    required this.item,
  });

  final LiturgiaSeedPreviewItem item;

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF1A1F36);
    const textMuted = Color(0xFF6B7280);
    const primaryBlue = Color(0xFF0B1E66);
    const gold = Color(0xFFD4AF37);
    const border = Color(0xFFE8ECF4);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.fecha,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.titulo,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.celebracion.isEmpty
                ? 'Sin celebración definida'
                : item.celebracion,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniTag(
                label: '${item.lecturasCount} lecturas',
                color: primaryBlue,
              ),
              _MiniTag(
                label: item.hasEvangelio ? 'Con evangelio' : 'Sin evangelio',
                color: item.hasEvangelio
                    ? const Color(0xFF1F9D55)
                    : const Color(0xFFD97706),
              ),
              _MiniTag(
                label: item.hasSanto ? 'Con santo' : 'Sin santo',
                color: item.hasSanto ? gold : textMuted,
              ),
              _MiniTag(
                label: item.publicado ? 'Publicado' : 'Borrador',
                color: item.publicado
                    ? const Color(0xFF1F9D55)
                    : const Color(0xFF6B7280),
              ),
            ],
          ),
          if (item.warnings.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...item.warnings.map(
              (warning) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '• $warning',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFD97706),
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({
    required this.message,
    this.danger = false,
  });

  final String message;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFDC2626) : const Color(0xFFD97706);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            danger ? Icons.error_outline_rounded : Icons.warning_amber_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: const Color(0xFF1A1F36),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAdminCard extends StatelessWidget {
  const _HeroAdminCard({
    required this.primaryBlue,
    required this.secondaryBlue,
    required this.gold,
  });

  final Color primaryBlue;
  final Color secondaryBlue;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryBlue,
            secondaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: gold,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carga litúrgica administrada',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ahora puedes seleccionar un archivo JSON desde el dispositivo, validarlo y cargarlo con control total.',
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
