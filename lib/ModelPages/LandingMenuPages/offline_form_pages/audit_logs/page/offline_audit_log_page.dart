import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/audit_logs/controller/offline_audit_log_controller.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_constants.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/db/offline_db_module.dart';

// ─── Colors ───────────────────────────────────────────────────────────────────

class AuditColors {
  static const primary = Color(0xFF2563EB);
  static const success = Color(0xFF16A34A);
  static const error = Color(0xFFDC2626);
  static const blueSoft = Color(0xFFEFF6FF);
  static const greenSoft = Color(0xFFECFDF5);
  static const redSoft = Color(0xFFFEF2F2);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const surface = Color(0xFFF8FAFC);
}

class AuditLogPage extends StatefulWidget {
  const AuditLogPage({super.key});

  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  late final AuditLogController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(AuditLogController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: _FilterHeaderDelegate(
                child: _FilterPanel(c: c),
              ),
            ),
            if (c.filteredLogs.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _LogTile(log: c.filteredLogs[i], c: c),
                    childCount: c.filteredLogs.length,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AuditColors.textPrimary, size: 20),
        onPressed: () => Get.back(),
      ),
      title: Text(
        "Activity Logs",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: AuditColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              OfflineDbModule.pushAuditLogsToServer(isInternetAvailable: true);
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.green,
            )),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AuditColors.redSoft,
              side: const BorderSide(color: AuditColors.error, width: .6),
            ),
            onPressed: c.confirmClear,
            icon: const Icon(Icons.delete_outline_rounded,
                size: 20, color: AuditColors.error),
          ),
        ),
      ],
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  static const double _height = 152;

  const _FilterHeaderDelegate({required this.child});

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  bool shouldRebuild(_FilterHeaderDelegate oldDelegate) =>
      oldDelegate.child != child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      child: child,
    );
  }
}

class _FilterPanel extends StatelessWidget {
  final AuditLogController c;
  const _FilterPanel({required this.c});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FilterSection1(c: c),
        _FilterSection2(c: c),
      ],
    );
  }
}

class _FilterSection1 extends StatelessWidget {
  final AuditLogController c;
  const _FilterSection1({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final usernames = c.uniqueUsernames;
      return _FilterContainer(
        child: Row(
          spacing: 10,
          children: [
            _FilterChip(label: "All", c: c),
            _FilterChip(label: "Success", c: c),
            _FilterChip(label: "Error", c: c),
            // const Spacer(),
            Flexible(
              child: _AuditDropdown<String>(
                value: c.selectedUsername.value,
                leadingIcon: CupertinoIcons.person_fill,
                // title: "Users",
                hint: "User",
                items: usernames,
                labelBuilder: (v) => v,
                onChanged: c.setUsername,
                fullWidth: true,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _FilterSection2 extends StatelessWidget {
  final AuditLogController c;
  const _FilterSection2({required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final actions = c.uniqueActions;
      final dates = c.uniqueDates;
      return _FilterContainer(
        topMargin: 0,
        child: Row(
          children: [
            Expanded(
              child: _AuditDropdown<String>(
                value: c.selectedAction.value,
                leadingIcon: Icons.pending_actions,
                hint: "Action",
                items: actions,
                labelBuilder: (v) => v,
                onChanged: c.setAction,
                fullWidth: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _AuditDropdown<String>(
                value: c.selectedDate.value,
                leadingIcon: Icons.date_range_sharp,
                hint: "Date",
                items: dates.map((d) => d.value).toList(),
                labelBuilder: (v) =>
                    dates.firstWhere((d) => d.value == v).label,
                onChanged: c.setDate,
                fullWidth: true,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _FilterContainer extends StatelessWidget {
  final Widget child;
  final double topMargin;

  const _FilterContainer({required this.child, this.topMargin = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, topMargin, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AuditColors.border),
      ),
      child: child,
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final AuditLogController c;
  const _FilterChip({required this.label, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool selected = c.selectedFilter.value == label;

      Color bg;
      Color border;
      Color text;

      if (label == "Success" && selected) {
        bg = AuditColors.greenSoft;
        border = AuditColors.success;
        text = AuditColors.success;
      } else if (label == "Error" && selected) {
        bg = AuditColors.redSoft;
        border = AuditColors.error;
        text = AuditColors.error;
      } else if (selected) {
        bg = AuditColors.blueSoft;
        border = AuditColors.primary;
        text = AuditColors.primary;
      } else {
        bg = Colors.white;
        border = AuditColors.border;
        text = AuditColors.textSecondary;
      }

      return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => c.setFilter(label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ),
      );
    });
  }
}

class _AuditDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) labelBuilder;
  final void Function(T?) onChanged;
  final bool fullWidth;

  final IconData? leadingIcon;

  final String? title;

  const _AuditDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.fullWidth = false,
    this.leadingIcon,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final dropdown = Container(
      height: 34,
      padding: EdgeInsets.only(
        left: leadingIcon != null ? 6 : 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AuditColors.border),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 15, color: AuditColors.textSecondary),
            const SizedBox(width: 8),
          ],
          Flexible(
            fit: fullWidth ? FlexFit.tight : FlexFit.loose,
            child: DropdownButton<T>(
              value: value,
              isExpanded: fullWidth,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AuditColors.textSecondary),
              ),
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              dropdownColor: Colors.white,
              items: [
                DropdownMenuItem<T>(
                  value: null,
                  child: Text(
                    "All ${hint}s",
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                ...items.map((item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        labelBuilder(item),
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    )),
              ],
              onChanged: onChanged,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AuditColors.textPrimary),
            ),
          ),
        ],
      ),
    );

    if (title != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AuditColors.textSecondary,
              letterSpacing: .2,
            ),
          ),
          const SizedBox(height: 4),
          dropdown,
        ],
      );
    }

    return dropdown;
  }
}

class _LogTile extends StatelessWidget {
  final Map<String, dynamic> log;
  final AuditLogController c;
  const _LogTile({required this.log, required this.c});

  @override
  Widget build(BuildContext context) {
    final bool isError = log[OfflineDBConstants.COL_IS_ERROR] == 1;
    final String dateStr = c.formatDate(log[OfflineDBConstants.COL_CREATED_AT]);

    final Color statusColor = isError ? AuditColors.error : AuditColors.success;
    final Color tileSoft =
        isError ? AuditColors.redSoft : AuditColors.greenSoft;

    final String response = log[OfflineDBConstants.COL_RESPONSE] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AuditColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log[OfflineDBConstants.COL_ACTION] ?? "SYSTEM",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AuditColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateStr,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AuditColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tileSoft,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  isError ? "ERROR" : "SUCCESS",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                    letterSpacing: .3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            log[OfflineDBConstants.COL_REMARKS] ?? "No remarks provided",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AuditColors.textPrimary,
            ),
          ),
          if (response.isNotEmpty) ...[
            const SizedBox(height: 10),
            _JsonResponseViewer(response: response),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: AuditColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_rounded,
                size: 36, color: AuditColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            "No activity logs found",
            style: GoogleFonts.poppins(
              color: AuditColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _JsonResponseViewer extends StatefulWidget {
  final String response;
  const _JsonResponseViewer({required this.response});

  @override
  State<_JsonResponseViewer> createState() => _JsonResponseViewerState();
}

class _JsonResponseViewerState extends State<_JsonResponseViewer>
    with TickerProviderStateMixin {
  bool expanded = false;
  bool overflow = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkOverflow();
  }

  void _checkOverflow() {
    final span = TextSpan(
      text: _prettyJson(widget.response),
      style: GoogleFonts.firaCode(fontSize: 11.5, height: 1.45),
    );
    final tp = TextPainter(
      text: span,
      maxLines: 4,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width - 80);
    overflow = tp.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final formatted = _prettyJson(widget.response);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Text(
                  formatted,
                  maxLines: expanded ? null : 4,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.firaCode(
                    fontSize: 11.5,
                    height: 1.45,
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              if (!expanded && overflow)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF0F172A).withOpacity(0),
                            const Color(0xFF0F172A),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (overflow)
            GestureDetector(
              onTap: () => setState(() => expanded = !expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  expanded ? "Collapse ▲" : "Expand ▼",
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF38BDF8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _prettyJson(String input) {
    try {
      final decoded = jsonDecode(input);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(decoded);
    } catch (_) {
      return input;
    }
  }
}
