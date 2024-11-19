package com.daepa.minimo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
public class ChatMessageDto {
    private Long roomId;
    private Long senderId;
    private Long receiverId;
    private String content;
    private LocalDateTime timeStamp;
    private Boolean isRead;
}
