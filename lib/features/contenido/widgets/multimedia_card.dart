import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:escoge/features/contenido/data/models/multimedia_item_model.dart';

class MultimediaCard extends StatelessWidget {
  final MultimediaItemModel item;

  const MultimediaCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          _handleTap(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (item.thumbnailUrl.isEmpty) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFF1A3DAB),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: const Center(
          child: Icon(Icons.image, color: Colors.white54, size: 40),
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: Image.network(
        item.thumbnailUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.titulo,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.descripcion,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildChip(item.tipo),
            const SizedBox(width: 8),
            _buildChip(item.categoria),
          ],
        )
      ],
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFD4AF37),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (item.tipo == "audio") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reproducir audio próximamente")),
      );
    } else if (item.tipo == "video") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Abrir video próximamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Abrir contenido")),
      );
    }
  }
}
