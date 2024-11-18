package com.daepa.minimo.exception;

public class UserInvalidException extends RuntimeException {
    public UserInvalidException() {
        super("유효한 사용자가 아닙니다.");
    }

    public UserInvalidException(String message) {
        super(message);
    }

    public UserInvalidException(String message, Throwable cause) {
        super(message, cause);
    }

    public UserInvalidException(Throwable cause) {
        super(cause);
    }

    protected UserInvalidException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
