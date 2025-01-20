package com.daepa.minimo.exception;

public class ApiForbiddenException extends RuntimeException {
    public ApiForbiddenException() {
        super("JWT 검증을 실패했습니다.");
    }

    public ApiForbiddenException(String message) {
        super(message);
    }

    public ApiForbiddenException(String message, Throwable cause) {
        super(message, cause);
    }

    public ApiForbiddenException(Throwable cause) {
        super(cause);
    }

    protected ApiForbiddenException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
