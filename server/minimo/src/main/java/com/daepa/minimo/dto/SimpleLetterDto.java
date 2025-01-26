package com.daepa.minimo.dto;

import lombok.*;



@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class SimpleLetterDto {
    private Long id;
    private String senderNickname;
    private String title;
}
