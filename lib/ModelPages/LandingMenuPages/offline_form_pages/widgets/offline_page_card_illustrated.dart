import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/form_page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfflinePageIllustratedCard extends StatelessWidget {
  final OfflineFormPageModel page;
  final int index;
  final VoidCallback onTap;
  final bool useColoredTile;
  final String illustrationAsset;

  const OfflinePageIllustratedCard({
    super.key,
    required this.page,
    required this.index,
    required this.onTap,
    required this.illustrationAsset,
    this.useColoredTile = true,
  });

  @override
  Widget build(BuildContext context) {
    final _GradientSet gradient =
        useColoredTile ? _gradients[index % _gradients.length] : _defaultGray;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: gradient.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ---------- ILLUSTRATION ----------
            Positioned(
              right: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.18,
                child: Image.asset(
                  illustrationAsset,
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ---------- CONTENT ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      page.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    CupertinoIcons.doc_text_fill,
                    size: 52,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ),

            if (page.attachments)
              Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  CupertinoIcons.paperclip,
                  size: 18,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GradientSet {
  final List<Color> colors;
  const _GradientSet(this.colors);
}

const _defaultGray = _GradientSet([
  Color(0xFF546E7A),
  Color(0xFF37474F),
]);

const List<_GradientSet> _gradients = [
  _GradientSet([Color(0xFF7F7FD5), Color(0xFF86A8E7)]),
  _GradientSet([Color(0xFF43CEA2), Color(0xFF185A9D)]),
  _GradientSet([Color(0xFFf7971e), Color(0xFFffd200)]),
  _GradientSet([Color(0xFFf953c6), Color(0xFFb91d73)]),
  _GradientSet([Color(0xFF00c6ff), Color(0xFF0072ff)]),
];
