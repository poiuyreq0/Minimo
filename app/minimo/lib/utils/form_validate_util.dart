class FormValidateUtil {
  // Dropdown
  static String? validateNotNull<T>(T? value) {
    if (value == null) {
      return '필드가 비어있습니다.';
    }

    return null;
  }

  static String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '필드가 비어있습니다.';
    }

    return null;
  }

  // Text
  static String? validateLength(String? value) {
    int minLength = 2;
    int maxLength = 20;

    if (value == null || value.trim().isEmpty) {
      return '필드가 비어있습니다.';
    } else if (value.trim().length < minLength || value.trim().length > maxLength) {
      return '$minLength~$maxLength자 이내로 입력 바랍니다.';
    }

    return null;
  }

  // Content
  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '필드가 비어있습니다.';
    } else if (value.trim().length < 20) {
      return '조금만 더 마음을 표현해 주세요!';
    }

    return null;
  }

  static String? validatePassword(String? value, String? newPassword) {
    if (value == null || value.trim().isEmpty) {
      return '필드가 비어있습니다.';
    } else if (value != newPassword) {
      return '비밀번호가 서로 다릅니다.';
    }

    return null;
  }
}