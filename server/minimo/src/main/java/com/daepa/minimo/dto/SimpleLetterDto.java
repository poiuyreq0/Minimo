package com.daepa.minimo.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class SimpleLetterDto {
    private Long id;
    private String senderNickname;
    private String title;
    private LocalDateTime createdDate;
}
