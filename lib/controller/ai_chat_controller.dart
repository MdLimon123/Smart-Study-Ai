import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  final String? imagePath;  // local file path for image attachments
  final String? filePath;   // local file path for doc/pdf attachments
  final String? fileName;
  final List<String>? imagePaths;

  const ChatMessage({
    required this.role,
    required this.content,
    this.imagePath,
    this.filePath,
    this.fileName,
    this.imagePaths,
  });
}

class AiChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();

  final List<AiModel> models = const [
    AiModel(
      name: 'Auto-select model',
      subtitle: 'QQA picks best model',
      icon: 'assets/icon/model.svg',
      apiValue: 'gpt',
    ),
    AiModel(
      name: 'GPT-4o',
      subtitle: 'General',
      icon: 'assets/images/gpt_fill.png',
      apiValue: 'gpt',
    ),
    AiModel(
      name: 'Gemini Pro',
      subtitle: 'Research',
      icon: 'assets/images/gemini_fill.png',
      apiValue: 'gemini',
    ),
    AiModel(
      name: 'Claude Sonnet 4.6',
      subtitle: 'Math',
      icon: 'assets/images/claude.jpg',
      apiValue: 'claude',
    ),
      AiModel(
      name: 'QQ AI',
      subtitle: 'Quick Question',
      icon: 'assets/images/app_logo.png',
      apiValue: 'gpt',
    ),
  ];

  final selectedIndex = RxnInt();
  final isSending = false.obs;
  final messages = <ChatMessage>[].obs;

  // Attached file/image
  final attachedFilePath = RxnString();
  final attachedFileName = RxnString();
  final attachedIsImage = false.obs;
  final attachedImages = <String>[].obs;

  // Subjects
  final List<String> subjects = const [
    'All Subjects',
    'Math',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
    'CS',
    'Literature',
    'Economics',
  ];
  final selectedSubject = RxString('All Subjects');

  final _imagePicker = ImagePicker();

  AiModel? get selectedModel {
    final idx = selectedIndex.value;
    // If nothing selected, fall back to first model automatically
    if (idx == null) return models.first;
    if (idx < 0 || idx >= models.length) return models.first;
    return models[idx];
  }

  String get selectedModelName => selectedModel?.name ?? models.first.name;

  void selectModel(int index) {
    selectedIndex.value = index;
  }

  void selectSubject(String subject) {
    selectedSubject.value = subject;
  }

  void clearAttachment() {
    attachedFilePath.value = null;
    attachedFileName.value = null;
    attachedIsImage.value = false;
    attachedImages.clear();
  }

  void removeImage(int index) {
    if (index >= 0 && index < attachedImages.length) {
      attachedImages.removeAt(index);
    }
  }

  Future<void> pickImage() async {
    try {
      final picked = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );
      if (picked.isNotEmpty) {
        attachedImages.addAll(picked.map((e) => e.path));
      }
    } catch (e) {
      showCustomSnackBar('Could not pick images', isError: true);
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null) {
        attachedImages.add(picked.path);
      }
    } catch (e) {
      showCustomSnackBar('Could not capture image', isError: true);
    }
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        attachedFilePath.value = file.path;
        attachedFileName.value = file.name;
        attachedIsImage.value = false;
      }
    } catch (e) {
      showCustomSnackBar('Could not pick file', isError: true);
    }
  }


  Future<void> sendMessage({String? presetMessage}) async {
    final text = (presetMessage ?? messageController.text).trim();
    final hasAttachment = attachedFilePath.value != null || attachedImages.isNotEmpty;
    if (text.isEmpty && !hasAttachment) return;

    final model = selectedModel!; // always non-null — defaults to first model
    if (isSending.value) return;

    // Snapshot attachment before clearing
    final imgPath = attachedIsImage.value ? attachedFilePath.value : null; // Keep for backward compat
    final List<String> imgPaths = List.from(attachedImages);
    final fPath = (!attachedIsImage.value && attachedFilePath.value != null)
        ? attachedFilePath.value
        : null;
    final fName = attachedFileName.value;

    // Build user message content (text only — image shown as thumbnail in UI)
    String userContent = text;
    if (fPath != null) {
      final fname = fName ?? 'attachment';
      userContent = text.isEmpty ? '[File: $fname]' : '$text\n[File: $fname]';
    }

    messages.add(ChatMessage(
      role: 'user',
      content: userContent,
      imagePath: imgPath,
      imagePaths: imgPaths,
      filePath: fPath,
      fileName: fName,
    ));
    messageController.clear();
    clearAttachment();
    isSending.value = true;

    try {
      // Build body fields
      final Map<String, String> body = {
        'message': text,
        'model': model.apiValue,
        if (selectedSubject.value != 'All' && selectedSubject.value != 'All Subjects') 'subject': selectedSubject.value.toLowerCase(),
      };

      // Build multipart body
      final List<MultipartBody> multipartBody = [];
      if (imgPath != null) {
        multipartBody.add(MultipartBody('image', File(imgPath)));
      }
      for (var path in imgPaths) {
        multipartBody.add(MultipartBody('image', File(path)));
      }
      if (fPath != null) {
        multipartBody.add(MultipartBody('file', File(fPath)));
      }

      final response = await ApiClient.postMultipartData(
        ApiConstant.aiResponseEndpoint,
        body,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final raw = response.body is String
              ? jsonDecode(response.body)
              : response.body;

          final content = raw['data']['content']?.toString();

          if (content != null && content.trim().isNotEmpty) {
            messages.add(
              ChatMessage(role: 'assistant', content: content.trim()),
            );
          } else {
            showCustomSnackBar('Invalid AI response', isError: true);
          }
        } catch (e) {
          showCustomSnackBar('Parsing error: $e', isError: true);
        }
      } else {
        try {
          final raw = response.body is String
              ? jsonDecode(response.body)
              : response.body;
          final message = raw is Map ? raw['message']?.toString() : null;
          showCustomSnackBar(
            message ?? 'Failed to get AI response',
            isError: true,
          );
        } catch (_) {
          showCustomSnackBar('Failed to get AI response', isError: true);
        }
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadDefaultModelFromProfile();
  }

  void _loadDefaultModelFromProfile() {
    try {
      final profileController = Get.find<ProfileController>();
      
      // 1. Initial assignment if already loaded
      if (profileController.personalization.value != null) {
        _updateSelectedIndex(profileController.personalization.value!.model);
      } else {
        selectedIndex.value = 0; // Fallback default
      }

      // 2. Reactively listen to future personalization state updates
      ever(profileController.personalization, (personalModel) {
        if (personalModel != null) {
          _updateSelectedIndex(personalModel.model);
        }
      });
    } catch (_) {
      selectedIndex.value = 0;
    }
  }

  void _updateSelectedIndex(String savedModel) {
    int index = 0;
    if (savedModel == 'gpt-4o') {
      index = 0;
    } else if (savedModel == 'gemini-pro') {
      index = 1;
    } else if (savedModel == 'claude-3-5-sonnet') {
      index = 2;
    } else if (savedModel == 'qqai') {
      index = 3;
    }
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
