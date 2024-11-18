package com.daepa.minimo.common.enums;

// 수신자가 편지 확인 시, LOCKED
// 수신자가 편지 확인 후 연결 시, CONNECTED
public enum LetterState {
    NONE, SENT, LOCKED, CONNECTED,
}
