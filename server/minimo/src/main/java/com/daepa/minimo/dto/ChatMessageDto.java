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
    private Long id;
    private Long roomId;
    private Long senderId;
    private String content;
    private LocalDateTime timeStamp;
}
