package com.daepa.minimo.exception;

public class ReportConflictException extends RuntimeException {
    public ReportConflictException() {
        super("해당 신고는 이미 접수되었습니다.");
    }

    public ReportConflictException(String message) {
        super(message);
    }

    public ReportConflictException(String message, Throwable cause) {
        super(message, cause);
    }

    public ReportConflictException(Throwable cause) {
        super(cause);
    }

    protected ReportConflictException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
