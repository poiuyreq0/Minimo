package com.daepa.minimo.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class ChatRoomDto {
    private Long id;
    @Builder.Default
    private List<ChatRoomUserDto> userNicknames = new ArrayList<>();
    private ChatMessageDto lastMessage;
    private Long readNum;
    private LocalDateTime createdDate;
}
