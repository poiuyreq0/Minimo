package com.daepa.minimo.api;

import com.daepa.minimo.exception.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ApiExceptionHandler {
    @ExceptionHandler(ApiUnauthenticatedException.class)
    public ResponseEntity<RuntimeException> handleApiUnauthorizedException(ApiUnauthenticatedException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e);
    }

    @ExceptionHandler(ReportConflictException.class)
    public ResponseEntity<RuntimeException> handleReportConflictException(ReportConflictException e) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(e);
    }

    @ExceptionHandler(NicknameConflictException.class)
    public ResponseEntity<RuntimeException> handleNicknameConflictException(NicknameConflictException e) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(e);
    }

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<RuntimeException> handleUserNotFoundException(UserNotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
    }

    @ExceptionHandler(LetterNotFoundException.class)
    public ResponseEntity<RuntimeException> handleLetterNotFoundException(LetterNotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
    }

    @ExceptionHandler(ChatRoomNotFoundException.class)
    public ResponseEntity<RuntimeException> handleChatRoomNotFoundException(ChatRoomNotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
    }
}
