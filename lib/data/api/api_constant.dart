class ApiConstant {
  static const String BASE_URL = 'https://6zpmb4x8-8025.inc1.devtunnels.ms';
  static const String imageBaseUrl = 'https://6zpmb4x8-8025.inc1.devtunnels.ms';

  ///
  static const String login = '/auth/login/';
  static const String register = '/auth/signup/';
  static const String forgotPassword = '/auth/forgot-password/';
  static const String resetPassword = '/auth/reset-password/';
  static const String verifyEmail = '/auth/verify-otp/';
  static const String resendOTP = '/auth/resend-otp/';
  static const String profileSetup = '/profile/setup/';

  static const String getProfile = '/profile/';

  static const String updateProfile = '/profile/';

  static const String profileActivity = '/profile/activity/';

  static const String scanResultEndpoint = '/scan/';
  static const String aiResponseEndpoint = '/chat/ask/';
  /// GET ask history (same path as POST ask in some backends).
  static const String chatHistoryEndpoint = '/chat/ask/';

  static const String folderCreateEndpoint = '/library/folders/';
  static const String getFoldersEndpoint = '/library/folders/';
  static const String notesCreateEndpoint = '/library/notes/';
  static const String getNotesEndpoint = '/library/notes/';

  static const String imageUploadEndpoint = '/library/images/';
  static const String getImagesEndpoint = '/library/images/';
  static const String fileUploadEndpoint = '/library/files/';

  static const String getFilesEndpoint = '/library/files/';

  static String deleteFolderEndpoint({required String id}) =>
      '/library/folders/$id/';

  static String deleteFileEndpoint({required String id}) =>
      '/library/files/$id/';

  static String deleteImageEndpoint({required String id}) =>
      '/library/images/$id/';

  static String deleteNoteEndpoint({required String id}) =>
      '/library/notes/$id/';

  /// PATCH rename / partial update — each library type has its own URL (body e.g. `{ "title": "..." }`).
  static String editFolderEndpoint({required String id}) =>
      '/library/folders/$id/';

  static String editNoteEndpoint({required String id}) =>
      '/library/notes/$id/';

  static String editImageEndpoint({required String id}) =>
      '/library/images/$id/';

  static String editFileEndpoint({required String id}) =>
      '/library/files/$id/';


  static const String twoFactorAuthEndpoint = '/2fa/send/';

  static const String twoFactorVerifyEndpoint = '/2fa/verify/';

  static String searchEndpoint({required String query}) =>
      '/library/search/?q=$query';

  static String getFolderDetailsEndpoint({required String id}) =>
      '/library/folders/$id/contents/';

  static const String getAllLibraryItemsEndpoint = '/library/overview/';

  static String getSpecificNoteEndpoint({required String id}) =>
      '/library/notes/$id/';

  static String getSpecificImageEndpoint({required String id}) =>
      '/library/images/$id/';

  static String getSpecificFileEndpoint({required String id}) =>
      '/library/files/$id/';

static const String chatHistoryDeleteEndpoint = '/chat/ask/';   

static const String scanHistoryEndpoint = '/scan/history/';

static const String aiPersonalizationEndpoint = '/scan/ai-personalization/';


}
