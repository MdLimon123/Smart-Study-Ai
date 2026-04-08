import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Separate [Get.put] tags so a pushed [AiChatScreen] never deletes the shell tab controller.
class AiChatControllerTags {
  AiChatControllerTags._();
  static const mainTab = 'ai_chat_main_tab';
  static const homeModal = 'ai_chat_home_modal';
}

class AiModel {
  final String name;
  final String subtitle;
  final String icon;

  const AiModel({
    required this.name,
    required this.subtitle,
    required this.icon,
  });
}

class AiChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();

  final List<AiModel> models = const [
    AiModel(
      name: 'GPT-4o',
      subtitle: 'General',
      icon: 'assets/images/gpt.png',
    ),
    AiModel(
      name: 'Gemini Pro',
      subtitle: 'Research',
      icon: 'assets/images/gemini.png',
    ),
    AiModel(
      name: 'Claude 3',
      subtitle: 'Math',
      icon: 'assets/images/phy.png',
    ),
  ];

  final selectedIndex = 0.obs;

  AiModel get selectedModel => models[selectedIndex.value];

  void selectModel(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
