package com.daepa.minimo.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class SimpleLetterDto {
    private Long id;
    private String senderNickname;
    private String title;
}
