package com.daepa.minimo.exception;

public class LetterNotFoundException extends RuntimeException {
    public LetterNotFoundException() {
        super("편지를 찾을 수 없습니다.");
    }

    public LetterNotFoundException(String message) {
        super(message);
    }

    public LetterNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }

    public LetterNotFoundException(Throwable cause) {
        super(cause);
    }

    protected LetterNotFoundException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
