import 'dart:ui';

import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/form_page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfflinePageTile extends StatelessWidget {
  final OfflineFormPageModel page;
  final int index;
  final VoidCallback onTap;
  final bool useColoredTile;

  const OfflinePageTile({
    super.key,
    required this.page,
    required this.index,
    required this.onTap,
    this.useColoredTile = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = useColoredTile
        ? MyColors.getOfflineColorByIndex(index)
        : Colors.blueGrey.shade700;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: baseColor.withValues(alpha: 0.08),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    ...List.generate(
                      6,
                      (i) => Container(
                        margin: EdgeInsets.only(
                            bottom: 6, right: (i >= 3 && i < 5) ? (i * 10) : 0),
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (page.attachments)
                      Icon(
                        Icons.attach_file,
                        size: 16,
                        color: baseColor,
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Text(
                page.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OfflinePageCard1 extends StatelessWidget {
  final OfflineFormPageModel page;
  final int index;
  final VoidCallback onTap;
  final bool useColoredTile;

  const OfflinePageCard1({
    super.key,
    required this.page,
    required this.index,
    required this.onTap,
    this.useColoredTile = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = useColoredTile
        ? MyColors.getOfflineColorByIndex(index)
        : Colors.blueGrey.shade700;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ---------- ABSTRACT BUBBLES ----------
            Positioned(
              top: -30,
              right: -30,
              child: _bubble(baseColor.withValues(alpha: 0.12), 90),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: _bubble(baseColor.withValues(alpha: 0.08), 70),
            ),

            // ---------- CONTENT ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ---------- ICON ----------
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // ---------- TITLE ----------
                  Expanded(
                    child: Text(
                      page.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------- ATTACHMENT INDICATOR ----------
            if (page.attachments)
              Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.attach_file,
                  size: 18,
                  color: baseColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------- BUBBLE ----------
  Widget _bubble(Color color, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OfflinePageCard2 extends StatelessWidget {
  final OfflineFormPageModel page;
  final int index;
  final VoidCallback onTap;
  final bool useColoredTile;

  const OfflinePageCard2({
    super.key,
    required this.page,
    required this.index,
    required this.onTap,
    this.useColoredTile = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = useColoredTile
        ? MyColors.getOfflineColorByIndex(index)
        : Colors.blueGrey.shade700;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ..._buildBlobs(baseColor, index),

            // ---------- CONTENT ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ICON
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // TITLE
                  Expanded(
                    child: Text(
                      page.caption,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ATTACHMENT INDICATOR
            if (page.attachments)
              Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.attach_file,
                  size: 18,
                  color: baseColor,
                ),
              ),

            Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    "assets/images/content2.png",
                    width: 100,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBlobs(Color baseColor, int index) {
    final variant = index % 4;

    switch (variant) {
      case 0:
        return [
          // big top-right
          Positioned(
            top: -50,
            right: -30,
            child: _blob(baseColor.withValues(alpha: 0.14), 120),
          ),
          // mid left
          Positioned(
            top: 40,
            left: -35,
            child: _blob(baseColor.withValues(alpha: 0.08), 85),
          ),
          // small top center
          Positioned(
            top: 10,
            left: 60,
            child: _blob(baseColor.withValues(alpha: 0.06), 50),
          ),
          // faint depth blob
          Positioned(
            top: 90,
            right: 40,
            child: _blob(baseColor.withValues(alpha: 0.04), 70),
          ),
        ];

      case 1:
        return [
          Positioned(
            top: -45,
            left: -35,
            child: _blob(baseColor.withValues(alpha: 0.13), 115),
          ),
          Positioned(
            top: 55,
            right: -30,
            child: _blob(baseColor.withValues(alpha: 0.08), 80),
          ),
          Positioned(
            top: 15,
            right: 70,
            child: _blob(baseColor.withValues(alpha: 0.05), 55),
          ),
          Positioned(
            top: 95,
            left: 50,
            child: _blob(baseColor.withValues(alpha: 0.04), 75),
          ),
        ];

      case 2:
        return [
          Positioned(
            top: -55,
            right: -25,
            child: _blob(baseColor.withValues(alpha: 0.15), 130),
          ),
          Positioned(
            top: 35,
            left: -30,
            child: _blob(baseColor.withValues(alpha: 0.09), 90),
          ),
          Positioned(
            top: 20,
            left: 80,
            child: _blob(baseColor.withValues(alpha: 0.05), 60),
          ),
          Positioned(
            top: 100,
            right: 30,
            child: _blob(baseColor.withValues(alpha: 0.04), 70),
          ),
        ];

      default:
        return [
          Positioned(
            top: -40,
            left: -30,
            child: _blob(baseColor.withValues(alpha: 0.14), 120),
          ),
          Positioned(
            top: 60,
            right: -35,
            child: _blob(baseColor.withValues(alpha: 0.09), 85),
          ),
          Positioned(
            top: 25,
            left: 90,
            child: _blob(baseColor.withValues(alpha: 0.05), 55),
          ),
          Positioned(
            top: 110,
            left: 40,
            child: _blob(baseColor.withValues(alpha: 0.04), 80),
          ),
        ];
    }
  }

  Widget _blob(Color color, double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OfflinePageCard extends StatelessWidget {
  final OfflineFormPageModel page;
  final int index;
  final VoidCallback onTap;
  final bool useColoredTile;

  const OfflinePageCard({
    super.key,
    required this.page,
    required this.index,
    required this.onTap,
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
            // ---------- WAVE LAYERS ----------
            Positioned.fill(
              child: CustomPaint(
                painter: _WavePainter(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _WavePainter(
                  offset: 40,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),

            Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    "assets/images/content.png",
                    width: 100,
                  ),
                )),

            // ---------- CONTENT ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // TITLE
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

                  // ICON
                  Icon(
                    CupertinoIcons.doc_text_fill,
                    size: 54,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ],
              ),
            ),

            // ---------- ATTACHMENT INDICATOR ----------
            if (page.attachments)
              Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  CupertinoIcons.paperclip,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  final double offset;

  _WavePainter({
    required this.color,
    this.offset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    path.moveTo(0, size.height * 0.6 + offset);
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.5 + offset,
      size.width,
      size.height * 0.65 + offset,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
