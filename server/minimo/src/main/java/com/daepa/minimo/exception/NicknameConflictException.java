package com.daepa.minimo.exception;

public class NicknameConflictException extends RuntimeException {
    public NicknameConflictException() {
        super("이미 사용 중인 닉네임입니다.");
    }

    public NicknameConflictException(String message) {
        super(message);
    }

    public NicknameConflictException(String message, Throwable cause) {
        super(message, cause);
    }

    public NicknameConflictException(Throwable cause) {
        super(cause);
    }

    protected NicknameConflictException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
