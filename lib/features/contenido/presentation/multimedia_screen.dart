import 'package:escoge/features/contenido/widgets/multimedia_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/features/contenido/data/models/multimedia_item_model.dart';
import 'package:escoge/features/contenido/data/services/multimedia_service.dart';

class MultimediaScreen extends StatefulWidget {
  const MultimediaScreen({super.key});

  @override
  State<MultimediaScreen> createState() => _MultimediaScreenState();
}

class _MultimediaScreenState extends State<MultimediaScreen> {
  final MultimediaService _service = MultimediaService();

  late Future<List<MultimediaItemModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getPublishedMultimedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1E66),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: FutureBuilder<List<MultimediaItemModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoading();
                  }

                  if (snapshot.hasError) {
                    return _buildError(snapshot.error.toString());
                  }

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    return _buildEmpty();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return MultimediaCard(item: items[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill, color: Color(0xFFD4AF37)),
          const SizedBox(width: 10),
          Text(
            "Multimedia",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFD4AF37),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        "No hay contenido disponible",
        style: GoogleFonts.poppins(color: Colors.white70),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Text(
        "Error cargando contenido",
        style: GoogleFonts.poppins(color: Colors.redAccent),
      ),
    );
  }
}
