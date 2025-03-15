package com.daepa.minimo.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ReportReason {
    ABUSE("폭언 / 비하 / 비속어"),
    OBSCENITY("음란 / 혐오 / 불쾌"),
    FRAUD("허위 사실 / 사칭 / 사기"),
    SPAM("도배 / 광고"),
    PRIVACY("개인 정보 유출");

    private final String description;
}
