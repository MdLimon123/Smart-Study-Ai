import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';

/// Separate [Get.put] tags so a pushed [AiChatScreen] never deletes the shell tab controller.
class AiChatControllerTags {
  AiChatControllerTags._();
  static const mainTab = 'ai_chat_main_tab';
  static const homeModal = 'ai_chat_home_modal';
  static const dataControl = 'ai_chat_data_control';
}

class AiModel {
  final String name;
  final String subtitle;
  final String icon;
  final String apiValue;

  const AiModel({
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.apiValue,
  });
}

class ChatMessage {
  final String role; // user | assistant
  final String content;

  const ChatMessage({required this.role, required this.content});
}

class AiChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();

  final List<AiModel> models = const [
    AiModel(
      name: 'GPT-4o',
      subtitle: 'General',
      icon: 'assets/images/gptPro.png',
      apiValue: 'gpt',
    ),
    AiModel(
      name: 'Gemini Pro',
      subtitle: 'Research',
      icon: 'assets/images/geminiPro.png',
      apiValue: 'gemini',
    ),
    AiModel(
      name: 'Claude 3',
      subtitle: 'Math',
      icon: 'assets/images/claudePro.png',
      apiValue: 'claude',
    ),
  ];

  final selectedIndex = RxnInt();
  final isSending = false.obs;
  final messages = <ChatMessage>[].obs;

  AiModel? get selectedModel {
    final idx = selectedIndex.value;
    if (idx == null) return null;
    if (idx < 0 || idx >= models.length) return null;
    return models[idx];
  }

  String get selectedModelName => selectedModel?.name ?? 'Select Model';

  void selectModel(int index) {
    selectedIndex.value = index;
  }

  Future<void> sendMessage({String? presetMessage}) async {
    final text = (presetMessage ?? messageController.text).trim();
    if (text.isEmpty) return;

    final model = selectedModel;
    if (model == null) {
      showCustomSnackBar('Please select a model first', isError: true);
      return;
    }
    if (isSending.value) return;

    messages.add(ChatMessage(role: 'user', content: text));
    messageController.clear();
    isSending.value = true;

    try {
      final response = await ApiClient.postData(
        ApiConstant.aiResponseEndpoint,
        {'message': text, 'model': model.apiValue},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        String? content;
        if (body is Map && body['data'] is Map) {
          final data = body['data'] as Map;
          content = data['content']?.toString();
        }

        if (content != null && content.trim().isNotEmpty) {
          messages.add(ChatMessage(role: 'assistant', content: content.trim()));
        } else {
          showCustomSnackBar('Invalid AI response', isError: true);
        }
      } else {
        final body = response.body;
        final message = body is Map ? body['message']?.toString() : null;
        showCustomSnackBar(
          message ?? 'Failed to get AI response',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
