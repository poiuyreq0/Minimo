package com.daepa.minimo.dto;

import com.daepa.minimo.domain.ChatMessage;
import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class ChatMessageDto {
    private Long id;
    private Long roomId;
    private Long senderId;
    private String content;
    private Boolean isRead;
    private LocalDateTime createdDate;

    public static ChatMessageDto fromChatMessage(@NonNull ChatMessage chatMessage) {
        return ChatMessageDto.builder()
                .id(chatMessage.getId())
                .roomId(chatMessage.getChatRoom().getId())
                .senderId(chatMessage.getSenderId())
                .content(chatMessage.getContent())
                .isRead(chatMessage.getIsRead())
                .createdDate(chatMessage.getCreatedDate())
                .build();
    }

    public ChatMessage toChatMessage() {
        return ChatMessage.builder()
                .senderId(senderId)
                .content(content)
                .build();
    }
}
