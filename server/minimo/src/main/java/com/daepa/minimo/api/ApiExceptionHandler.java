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
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
    }

    @ExceptionHandler(ImageNotFoundException.class)
    public ResponseEntity<RuntimeException> handleImageNotFoundException(ImageNotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
    }

    @ExceptionHandler(LetterNotFoundException.class)
    public ResponseEntity<RuntimeException> handleLetterNotFoundException(LetterNotFoundException e) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e);
    }

    @ExceptionHandler(UserInvalidException.class)
    public ResponseEntity<RuntimeException> handleUserInvalidException(UserInvalidException e) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e);
    }

    @ExceptionHandler(ChatRoomNotFoundException.class)
    public ResponseEntity<RuntimeException> handleChatRoomNotFoundException(ChatRoomNotFoundException e) {
        return ResponseEntity.badRequest().body(e);
    }
}
