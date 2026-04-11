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
}
