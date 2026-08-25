// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:axpertflutter/Constants/MyColors.dart';
// import 'package:axpertflutter/Constants/Routes.dart';
// import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/controller/offline_form_controller.dart';

// class OfflineLandingPage extends GetView<OfflineFormController> {
//   const OfflineLandingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bg = const Color(0xFFF8F7F4);

//     return Scaffold(
//       backgroundColor: bg,

//       // ===== APPBAR (VISUALLY FLAT) =====
//       appBar: AppBar(
//         backgroundColor: bg,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.black87),
//       ),

//       // ===== DRAWER =====
//       drawer: _buildDrawer(context),

//       body: Stack(
//         children: [
//           _buildBody(context),

//           // ===== LOADING OVERLAY =====
//           Obx(() {
//             if (!controller.isLoading.value) return const SizedBox.shrink();

//             return Container(
//               color: Colors.black.withOpacity(0.15),
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   // ================= BODY =================

//   Widget _buildBody(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Obx(() {
//           final user = controller.offlineUser;
//           final formCount = controller.offlineFormsCount.value;

//           if (user == null) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final username = user['username']?.toString() ?? '';
//           final project = user['appname']?.toString() ?? '';

//           return Column(
//             children: [
//               const SizedBox(height: 22),

//               Image.asset(
//                 'assets/images/axpert_04.png',
//                 width: MediaQuery.of(context).size.width * 0.24,
//                 fit: BoxFit.fill,
//               ),
//               const SizedBox(height: 12),

//               Text(
//                 "Axpert Offline",
//                 style: GoogleFonts.poppins(
//                   fontSize: 34,
//                   fontWeight: FontWeight.w600,
//                   color: MyColors.AXMDark,
//                 ),
//               ),

//               const SizedBox(height: 6),

//               Text(
//                 "You are currently offline.\nYou can continue working using the last synced data.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: MyColors.AXMGray,
//                 ),
//               ),

//               const SizedBox(height: 28),

//               // ===== USER CARD =====
//               _userCard(username, project),

//               const SizedBox(height: 20),

//               // ===== FORMS COUNT =====
//               _formsCountCard(formCount),

//               const Spacer(),

//               // ===== CONTINUE BUTTON =====
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: MyColors.blue2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     controller.getAllPages();
//                     Get.toNamed(Routes.OfflineListingPage);
//                   },
//                   child: Text(
//                     "Go to Offline Forms",
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // ===== FOOTER =====
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Powered By",
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Image.asset(
//                     'assets/images/axpert_03.png',
//                     height: MediaQuery.of(context).size.height * 0.03,
//                     fit: BoxFit.fill,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 12),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   Widget _userCard(String username, String project) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: MyColors.AXMDark.withOpacity(0.2)),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 52,
//             height: 52,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: MyColors.blue2.withOpacity(0.15),
//             ),
//             child: const Icon(Icons.person, size: 28, color: MyColors.blue2),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   username,
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: MyColors.AXMDark,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   project,
//                   style: GoogleFonts.poppins(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: MyColors.AXMGray,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _formsCountCard(int count) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: const Color(0xffD9D9D9).withAlpha(90),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Center(
//         child: Text(
//           "Available Offline Forms: $count",
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: MyColors.AXMDark,
//           ),
//         ),
//       ),
//     );
//   }

//   // ================= DRAWER =================
//   Widget _buildDrawer(BuildContext context) {
//     final bg = const Color(0xFFF8F7F4);

//     return Drawer(
//       backgroundColor: bg,
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ===== HEADER =====
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//               child: Text(
//                 "Offline Data Manager",
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: MyColors.AXMDark,
//                 ),
//               ),
//             ),
//             const Divider(height: 1),

//             Expanded(
//               child: ListView(
//                 children: [
//                   _sectionHeader("Sync"),
//                   _simpleRow(
//                     icon: Icons.sync,
//                     color: MyColors.blue2,
//                     title: "Sync All",
//                     subtitle: "Push pending & refetch everything",
//                     onTap: controller.actionSyncAll,
//                   ),
//                   _simpleRow(
//                     icon: Icons.description,
//                     color: Colors.indigo,
//                     title: "Refetch Forms",
//                     subtitle: "Reload offline forms",
//                     onTap: controller.actionRefetchForms,
//                   ),
//                   _simpleRow(
//                     icon: Icons.storage,
//                     color: Colors.teal,
//                     title: "Refetch Datasources",
//                     subtitle: "Reload lookup data",
//                     onTap: controller.actionRefetchDatasources,
//                   ),
//                   const Divider(),
//                   _sectionHeader("Queue"),
//                   _simpleRow(
//                     icon: Icons.upload,
//                     color: Colors.deepOrange,
//                     title: "Pending Uploads",
//                     subtitle: "View waiting submissions",
//                     onTap: controller.actionShowPending,
//                   ),
//                   Container(
//                     color: Colors.black38,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         _simpleRow(
//                           icon: Icons.clear_all,
//                           color: Colors.brown,
//                           title: "Clear Pending Queue",
//                           subtitle: "Delete all pending submissions",
//                           onTap: controller.actionClearPending,
//                           // onTap: null
//                         ),
//                         const Divider(),
//                         _sectionHeader("Storage"),
//                         _simpleRow(
//                           icon: Icons.delete_outline,
//                           color: Colors.redAccent,
//                           title: "Clear Forms Cache",
//                           subtitle: "Remove offline forms",
//                           onTap: controller.actionClearForms,
//                         ),
//                         _simpleRow(
//                           icon: Icons.delete_sweep,
//                           color: Colors.red,
//                           title: "Clear Datasources Cache",
//                           subtitle: "Remove cached datasources",
//                           onTap: controller.actionClearDatasources,
//                         ),
//                         const Divider(),
//                         _sectionHeader("Danger Zone"),
//                         _simpleRow(
//                           icon: Icons.warning,
//                           color: Colors.red.shade900,
//                           title: "Clear ALL Offline Data",
//                           subtitle: "Deletes everything except user",
//                           onTap: controller.actionClearAll,
//                           isDanger: true,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _sectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//       child: Text(
//         title.toUpperCase(),
//         style: GoogleFonts.poppins(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: MyColors.AXMGray,
//           letterSpacing: 0.8,
//         ),
//       ),
//     );
//   }

//   Widget _simpleRow({
//     required IconData icon,
//     required Color color,
//     required String title,
//     required String subtitle,
//     required VoidCallback? onTap,
//     bool isDanger = false,
//   }) {
//     return ListTile(
//       dense: true,
//       visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
//       leading: Icon(icon, size: 20, color: color),
//       title: Text(
//         title,
//         style: GoogleFonts.poppins(
//           fontSize: 13.5,
//           fontWeight: FontWeight.w500,
//           color: isDanger ? Colors.red : MyColors.AXMDark,
//         ),
//       ),
//       subtitle: Text(
//         subtitle,
//         style: GoogleFonts.poppins(
//           fontSize: 11,
//           color: MyColors.AXMGray,
//         ),
//       ),
//       trailing: const Icon(Icons.chevron_right, size: 18),
//       onTap: onTap,
//     );
//   }
// }
