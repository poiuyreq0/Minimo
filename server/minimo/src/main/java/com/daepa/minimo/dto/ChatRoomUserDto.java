package com.daepa.minimo.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class ChatRoomUserDto {
    private Long id;
    private Long chatRoomId;
    private String nickname;
}
