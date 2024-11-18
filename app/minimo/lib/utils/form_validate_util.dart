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
      return '조금 더 길게 마음을 표현해 보세요!';
    }

    return null;
  }
}