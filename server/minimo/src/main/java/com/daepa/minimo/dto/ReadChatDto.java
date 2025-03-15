package com.daepa.minimo.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class ReadChatDto {
    private Long roomId;
    private Long messageId;
}
