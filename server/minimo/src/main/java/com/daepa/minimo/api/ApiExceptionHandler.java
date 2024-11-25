package com.daepa.minimo.api;

import com.daepa.minimo.exception.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ApiExceptionHandler {
    @ExceptionHandler(NicknameConflictException.class)
    public ResponseEntity<RuntimeException> handleNicknameConflictException(NicknameConflictException e) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(e);
    }

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<RuntimeException> handleUserNotFoundException(UserNotFoundException e) {
        return ResponseEntity.badRequest().body(e);
    }

    @ExceptionHandler(LetterNotFoundException.class)
    public ResponseEntity<RuntimeException> handleLetterNotFoundException(LetterNotFoundException e) {
        return ResponseEntity.badRequest().body(e);
    }

    @ExceptionHandler(LetterUndeletableException.class)
    public ResponseEntity<RuntimeException> handleLetterUndeletableException(LetterUndeletableException e) {
        return ResponseEntity.badRequest().body(e);
    }

    @ExceptionHandler(LetterUnconnectableException.class)
    public ResponseEntity<RuntimeException> handleLetterUnconnectableException(LetterUnconnectableException e) {
        return ResponseEntity.badRequest().body(e);
    }

    @ExceptionHandler(UserInvalidException.class)
    public ResponseEntity<RuntimeException> handleUserInvalidException(UserInvalidException e) {
        return ResponseEntity.badRequest().body(e);
    }

    @ExceptionHandler(ChatRoomNotFoundException.class)
    public ResponseEntity<RuntimeException> handleChatRoomNotFoundException(ChatRoomNotFoundException e) {
        return ResponseEntity.badRequest().body(e);
    }

    @ExceptionHandler(NullPointerException.class)
    public ResponseEntity<RuntimeException> handleNullPointerException(NullPointerException e) {
        return ResponseEntity.badRequest().body(e);
    }
}
