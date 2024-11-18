package com.daepa.minimo.exception;

public class LetterUndeletableException extends RuntimeException {
    public LetterUndeletableException() {
        super("편지를 삭제할 수 없습니다.");
    }

    public LetterUndeletableException(String message) {
        super(message);
    }

    public LetterUndeletableException(String message, Throwable cause) {
        super(message, cause);
    }

    public LetterUndeletableException(Throwable cause) {
        super(cause);
    }

    protected LetterUndeletableException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
