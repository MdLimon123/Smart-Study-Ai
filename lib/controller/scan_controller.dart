import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/views/screen/scan&solve/solutation_screen.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// [Get.put] / [Get.delete] tags — shell tab and [Get.to] scan must not share one instance.
class ScanControllerTags {
  ScanControllerTags._();
  static const mainTab = 'scan_main_tab';
  static const homeModal = 'scan_home_modal';
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
  AnimationController? progressController;
  Animation<double>? progressAnimation;
  AnimationController? pulseController;
  Animation<double>? pulseAnimation;

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
        ResolutionPreset.medium,
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

  Future<void> captureAndScan() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await cameraController!.takePicture();
      debugPrint('Image captured: ${image.path}');
      _startAnalyzing();
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  void _startAnalyzing() {
    _disposeCamera();
    scanLineController.stop();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: pulseController!, curve: Curves.easeInOut),
    );
    pulseController!.repeat(reverse: true);

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: progressController!, curve: Curves.easeInOut),
    );
    progressController!.addListener(_onProgressUpdate);
    progressController!.forward();

    isAnalyzing.value = true;
    currentStep.value = 0;
  }

  void _onProgressUpdate() {
    final progress = progressAnimation!.value;

    int newStep;
    if (progress < 0.25) {
      newStep = 0;
    } else if (progress < 0.55) {
      newStep = 1;
    } else if (progress < 0.80) {
      newStep = 2;
    } else {
      newStep = 3;
    }

    if (newStep != currentStep.value) {
      currentStep.value = newStep;
    }

    if (progress >= 1.0) {
      progressController!.removeListener(_onProgressUpdate);
      pulseController?.dispose();
      progressController?.dispose();
      pulseController = null;
      progressController = null;
      isAnalyzing.value = false;
      _navigateToResult();
    }
  }

  Future<void> _navigateToResult() async {
    await Get.to(() => const SolutationScreen());
    if (!isClosed && _isActive) {
      initCamera();
      try {
        scanLineController.repeat(reverse: true);
      } catch (e) {
        debugPrint('scanLine repeat after result: $e');
      }
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scanLineController.dispose();
    progressController?.removeListener(_onProgressUpdate);
    progressController?.dispose();
    pulseController?.dispose();
    final c = cameraController;
    cameraController = null;
    // Do not assign .obs here — triggers Obx rebuild while route is unmounting (tree locked).
    if (c != null) {
      _cameraNativeIdle =
          _cameraNativeIdle.then((_) => _safeDisposeController(c));
    }
    super.onClose();
  }
}
