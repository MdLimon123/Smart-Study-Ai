import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/model/scan_result_model.dart';
import 'package:flutter_extension/views/base/custom_snackbar.dart';
import 'package:flutter_extension/views/screen/scan&solve/solutation_screen.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_extension/util/image_utils.dart';
import 'package:file_picker/file_picker.dart';

/// [Get.put] / [Get.delete] tags — shell tab and [Get.to] scan must not share one instance.
class ScanControllerTags {
  ScanControllerTags._();
  static const mainTab = 'scan_main_tab';
  static const homeModal = 'scan_home_modal';
  static const dataControl = 'scan_data_control';
}

class ScanController extends GetxController
    with GetTickerProviderStateMixin, WidgetsBindingObserver {
  ScanController({bool isActive = true}) : _isActive = isActive;

  // ─── State ───
  final selectedSubject = RxnString();
  final isCameraReady = false.obs;
  final hasCameraError = false.obs;
  final isAnalyzing = false.obs;
  final currentStep = 0.obs;
  bool _isActive;

  CameraController? cameraController;

  /// Serializes native CameraX teardown so the next [initialize] runs after the
  /// previous controller is fully disposed — including after pop/replace route.
  static Future<void> _cameraNativeIdle = Future.value();

  // ─── Animations ───
  late AnimationController scanLineController;
  late Animation<double> scanLineAnimation;

  late AnimationController progressController;
  late Animation<double> progressAnimation;
  late AnimationController pulseController;
  late Animation<double> pulseAnimation;

  Timer? _analyzingStepTimer;

  // ─── Data ───
  final List<String> analyzingSteps = [
    'Identifying problem type...',
    'Processing with AI model...',
    'Generating solution...',
    'Formatting steps...',
  ];

  final List<String> subjects = [
    'Math',
    'Physics',
    'Chemistry',
    'Biology',
    'History',
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: scanLineController, curve: Curves.easeInOut),
    );
    scanLineController.repeat(reverse: true);

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: progressController, curve: Curves.easeInOut),
    );

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    if (_isActive) initCamera();
  }

  void setActive(bool active) {
    if (isClosed) return;
    try {
      if (active && !_isActive) {
        initCamera();
        scanLineController.repeat(reverse: true);
      } else if (!active && _isActive) {
        _disposeCamera();
        scanLineController.stop();
      }
      _isActive = active;
    } catch (e, st) {
      debugPrint('setActive: $e\n$st');
      _isActive = active;
    }
  }

  Future<void> initCamera() async {
    await _cameraNativeIdle;
    if (isCameraReady.value) return;

    hasCameraError.value = false;

    CameraController? newController;
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        hasCameraError.value = true;
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        hasCameraError.value = true;
        return;
      }

      newController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await newController.initialize();
      if (isClosed || !_isActive) {
        await _safeDisposeController(newController);
        return;
      }

      cameraController = newController;
      isCameraReady.value = true;
    } catch (e, st) {
      debugPrint('initCamera failed: $e\n$st');
      await _safeDisposeController(newController);
      if (!isClosed) {
        hasCameraError.value = true;
      }
    }
  }

  Future<void> _safeDisposeController(CameraController? c) async {
    if (c == null) return;
    try {
      await c.dispose();
    } catch (e) {
      debugPrint('CameraController.dispose (after error): $e');
    }
  }

  void _disposeCamera() {
    final c = cameraController;
    cameraController = null;
    isCameraReady.value = false;
    hasCameraError.value = false;
    if (c != null) {
      _cameraNativeIdle =
          _cameraNativeIdle.then((_) => _safeDisposeController(c));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isActive) return;
    if (state == AppLifecycleState.inactive) {
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  void selectSubject(String? subject) {
    selectedSubject.value = subject;
  }

  /// API expects lowercase subject (e.g. `math`).
  String _subjectToApi(String display) => display.trim().toLowerCase();

  String? _messageFromBody(dynamic body) {
    if (body is Map) return body['message']?.toString();
    return null;
  }

  void _startAnalyzingUi() {
    isAnalyzing.value = true;
    currentStep.value = 0;
    progressController
      ..reset()
      ..forward();
    pulseController.repeat(reverse: true);
    _analyzingStepTimer?.cancel();
    _analyzingStepTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!isAnalyzing.value) return;
      currentStep.value = (currentStep.value + 1) % analyzingSteps.length;
    });
  }

  void _stopAnalyzingUi() {
    _analyzingStepTimer?.cancel();
    _analyzingStepTimer = null;
    progressController.stop();
    progressController.reset();
    pulseController.stop();
    pulseController.reset();
    isAnalyzing.value = false;
  }

  Future<void> captureAndScan() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await cameraController!.takePicture();
      await _submitScan(image.path, isImage: true);
    } catch (e) {
      debugPrint('Error capturing image: $e');
      showCustomSnackBar('Could not capture image', isError: true);
    }
  }

  Future<void> _submitScan(String filePath, {required bool isImage}) async {
    _disposeCamera();
    scanLineController.stop();
    _startAnalyzingUi();

    try {
      final response = await ApiClient.postMultipartData(
        ApiConstant.scanResultEndpoint,
        {'subject': selectedSubject.value != null ? _subjectToApi(selectedSubject.value!) : ''},
        multipartBody: [MultipartBody(isImage ? 'image' : 'file', File(filePath))],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body is Map && body['data'] is Map) {
          final model = ScanResultModel.fromJson(
            Map<String, dynamic>.from(body['data'] as Map),
          );
          _stopAnalyzingUi();
          await Get.to(() => SolutationScreen(result: model));
        } else {
          showCustomSnackBar('Invalid response', isError: true);
        }
      } else {
        showCustomSnackBar(
          _messageFromBody(response.body) ?? 'Scan failed',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      _stopAnalyzingUi();
      if (!isClosed && _isActive) {
        initCamera();
        try {
          scanLineController.repeat(reverse: true);
        } catch (e) {
          debugPrint('scanLine repeat after scan: $e');
        }
      }
    }
  }

  Future<void> pickAndScanImage() async {
    try {
      final File? image = await ImageUtils.pickAndCropImage(fromCamera: false);
      if (image == null) return;
      await _submitScan(image.path, isImage: true);
    } catch (e) {
      debugPrint('Error picking image: $e');
      showCustomSnackBar('Could not pick image', isError: true);
    }
  }

  Future<void> pickAndScanFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        withData: false,
      );
      if (result == null || result.files.isEmpty) return;
      final path = result.files.single.path;
      if (path == null) return;
      await _submitScan(path, isImage: false);
    } catch (e) {
      debugPrint('Error picking file: $e');
      showCustomSnackBar('Could not pick file', isError: true);
    }
  }


  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _analyzingStepTimer?.cancel();
    progressController.dispose();
    pulseController.dispose();
    scanLineController.dispose();
    final c = cameraController;
    cameraController = null;
    if (c != null) {
      _cameraNativeIdle =
          _cameraNativeIdle.then((_) => _safeDisposeController(c));
    }
    super.onClose();
  }
}
