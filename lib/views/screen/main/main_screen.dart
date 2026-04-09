import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/profile_activity_controller.dart';
import 'package:flutter_extension/views/base/bottom_menu.dart';
import 'package:flutter_extension/views/screen/chat/ai_chat_screen.dart';
import 'package:flutter_extension/views/screen/home/home_screen.dart';
import 'package:flutter_extension/views/screen/library/library_screen.dart';
import 'package:flutter_extension/views/screen/profile/profile_screen.dart';
import 'package:flutter_extension/controller/scan_controller.dart';
import 'package:flutter_extension/views/screen/scan&solve/scan_screen.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Get.find<ProfileActivityController>().startTracking();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.find<ProfileActivityController>().stopTracking();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = Get.find<ProfileActivityController>();
    if (state == AppLifecycleState.resumed) {
      c.onResume();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      c.onPause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          ScanScreen(
            isActive: _currentIndex == 1,
            controllerTag: ScanControllerTags.mainTab,
          ),
          const AiChatScreen(),
          const LibraryScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomMenu(
        menuIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
