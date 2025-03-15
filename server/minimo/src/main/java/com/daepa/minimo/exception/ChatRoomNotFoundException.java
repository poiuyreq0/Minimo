package com.daepa.minimo.exception;

public class ChatRoomNotFoundException extends RuntimeException {
  public ChatRoomNotFoundException() {
    super("채팅방을 찾을 수 없습니다.");
  }

  public ChatRoomNotFoundException(String message) {
    super(message);
  }

  public ChatRoomNotFoundException(String message, Throwable cause) {
    super(message, cause);
  }

  public ChatRoomNotFoundException(Throwable cause) {
    super(cause);
  }

  protected ChatRoomNotFoundException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
    super(message, cause, enableSuppression, writableStackTrace);
  }
}
