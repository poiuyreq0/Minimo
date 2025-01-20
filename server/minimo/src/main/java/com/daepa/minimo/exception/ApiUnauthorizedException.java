package com.daepa.minimo.exception;

public class ApiUnauthorizedException extends RuntimeException {
    public ApiUnauthorizedException() {
        super("JWT 토큰이 필요합니다.");
    }

    public ApiUnauthorizedException(String message) {
        super(message);
    }

    public ApiUnauthorizedException(String message, Throwable cause) {
        super(message, cause);
    }

    public ApiUnauthorizedException(Throwable cause) {
        super(cause);
    }

    protected ApiUnauthorizedException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
