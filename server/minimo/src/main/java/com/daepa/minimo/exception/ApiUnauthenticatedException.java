package com.daepa.minimo.exception;

public class ApiUnauthenticatedException extends RuntimeException {
    public ApiUnauthenticatedException() {
        super("로그인이 필요합니다.");
    }

    public ApiUnauthenticatedException(String message) {
        super(message);
    }

    public ApiUnauthenticatedException(String message, Throwable cause) {
        super(message, cause);
    }

    public ApiUnauthenticatedException(Throwable cause) {
        super(cause);
    }

    protected ApiUnauthenticatedException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
