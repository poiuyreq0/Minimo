package com.daepa.minimo.exception;

public class LetterUnconnectableException extends RuntimeException {
    public LetterUnconnectableException() {
        super("편지를 연결할 수 없습니다.");
    }

    public LetterUnconnectableException(String message) {
        super(message);
    }

    public LetterUnconnectableException(String message, Throwable cause) {
        super(message, cause);
    }

    public LetterUnconnectableException(Throwable cause) {
        super(cause);
    }

    protected LetterUnconnectableException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
