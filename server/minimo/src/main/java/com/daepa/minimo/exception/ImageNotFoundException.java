package com.daepa.minimo.exception;

public class ImageNotFoundException extends RuntimeException {
    public ImageNotFoundException() {
        super("이미지를 찾을 수 없습니다.");
    }

    public ImageNotFoundException(String message) {
        super(message);
    }

    public ImageNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }

    public ImageNotFoundException(Throwable cause) {
        super(cause);
    }

    protected ImageNotFoundException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
