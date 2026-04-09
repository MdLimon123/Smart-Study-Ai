import 'dart:async';

import 'package:flutter_extension/controller/profile_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/api_constant.dart';
import 'package:flutter_extension/data/model/profile_model.dart';
import 'package:flutter_extension/helper/prefs_helper.dart';
import 'package:flutter_extension/util/app_constants.dart';
import 'package:get/get.dart';

/// Foreground study time + daily active streak — syncs with `PATCH /profile/activity/`.
class ProfileActivityController extends GetxController {
  static const int _flushEveryMinutes = 1;

  Timer? _tick;
  int _pendingMinutes = 0;
  bool _tracking = false;

  String _todayKey() {
    final n = DateTime.now();
    return '${n.year.toString().padLeft(4, '0')}-'
        '${n.month.toString().padLeft(2, '0')}-'
        '${n.day.toString().padLeft(2, '0')}';
  }

  Future<bool> _hasToken() async {
    final t = await PrefsHelper.getString(AppConstants.TOKEN);
    return t.isNotEmpty;
  }

  /// Call when [MainScreen] is shown (logged-in shell).
  Future<void> startTracking() async {
    if (_tracking) return;
    if (!await _hasToken()) return;
    _tracking = true;
    _scheduleTick();
  }

  void _scheduleTick() {
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(minutes: 1), (_) => _onMinuteTick());
  }

  void _onMinuteTick() {
    if (!_tracking) return;
    _pendingMinutes++;
    if (_pendingMinutes >= _flushEveryMinutes) {
      unawaited(_flush());
    }
  }

  /// App returned to foreground.
  void onResume() {
    if (!_tracking) return;
    _scheduleTick();
  }

  /// App backgrounded / inactive — flush pending time.
  void onPause() {
    _tick?.cancel();
    _tick = null;
    unawaited(_flush());
  }

  /// Tear down when leaving main shell (e.g. logout).
  Future<void> stopTracking() async {
    _tracking = false;
    _tick?.cancel();
    _tick = null;
    await _flush();
  }

  Future<void> _flush() async {
    if (!await _hasToken()) {
      _pendingMinutes = 0;
      return;
    }

    final today = _todayKey();
    final last = await PrefsHelper.getString(AppConstants.profileLastActiveDay);
    final activeDaysAdd = last != today ? 1 : 0;

    final minutes = _pendingMinutes;
    if (minutes == 0 && activeDaysAdd == 0) return;

    final body = <String, int>{
      'study_minutes_add': minutes,
      'active_days_add': activeDaysAdd,
    };

    _pendingMinutes = 0;

    try {
      final res = await ApiClient.patchData(
        ApiConstant.profileActivity,
        body,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        if (activeDaysAdd == 1) {
          await PrefsHelper.setString(AppConstants.profileLastActiveDay, today);
        }
        _mergeActivityIntoProfile(res.body);
      }
    } catch (_) {
      _pendingMinutes += minutes;
    }
  }

  /// Keeps profile tab stats in sync without hot restart / full GET.
  void _mergeActivityIntoProfile(dynamic body) {
    if (body is! Map || body['data'] == null || body['data'] is! Map) {
      if (Get.isRegistered<ProfileController>()) {
        unawaited(Get.find<ProfileController>().fetchProfile());
      }
      return;
    }
    final d = Map<String, dynamic>.from(body['data'] as Map);
    if (!Get.isRegistered<ProfileController>()) return;
    final pc = Get.find<ProfileController>();
    final p = pc.profile.value;
    if (p == null) {
      unawaited(pc.fetchProfile());
      return;
    }
    if (d['study_minutes'] == null && d['active_days'] == null) {
      unawaited(pc.fetchProfile());
      return;
    }
    pc.profile.value = p.copyWith(
      studyMinutes: d['study_minutes'] != null
          ? ProfileModel.parseInt(d['study_minutes'])
          : null,
      activeDays:
          d['active_days'] != null ? ProfileModel.parseInt(d['active_days']) : null,
    );
  }
}
