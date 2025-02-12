enum ReportReason {
  ABUSE, OBSCENITY, FRAUD, SPAM, PRIVACY,
}

extension ReportReasonExtension on ReportReason {
  String get description {
    switch (this) {
      case ReportReason.ABUSE:
        return "폭언 / 비하 / 비속어";
      case ReportReason.OBSCENITY:
        return "음란 / 혐오 / 불쾌";
      case ReportReason.FRAUD:
        return "허위 사실 / 사칭 / 사기";
      case ReportReason.SPAM:
        return "도배 / 광고";
      case ReportReason.PRIVACY:
        return "개인 정보 유출";
    }
  }
}