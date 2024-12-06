package com.daepa.minimo.dto;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.domain.Letter;
import lombok.*;

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

    public static ChatMessageDto fromChatMessage(@NonNull ChatMessage chatMessage) {
        return ChatMessageDto.builder()
                .id(chatMessage.getId())
                .roomId(chatMessage.getChatRoom().getId())
                .senderId(chatMessage.getSenderId())
                .content(chatMessage.getContent())
                .timeStamp(chatMessage.getTimeStamp())
                .build();
    }

    public ChatMessage toChatMessage() {
        return ChatMessage.builder()
                .senderId(senderId)
                .content(content)
                .timeStamp(timeStamp)
                .build();
    }
}
