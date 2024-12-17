package com.daepa.minimo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class ChatRoomDto {
    private Long id;
    private List<UserNicknameDto> userNicknames;
    private ChatMessageDto lastMessage;
    private Long readNum;
    private LocalDateTime createdDate;
}
