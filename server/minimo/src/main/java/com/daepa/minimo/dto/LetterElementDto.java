package com.daepa.minimo.dto;

import com.daepa.minimo.common.enums.LetterState;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
public class LetterElementDto {
    private Long id;
    private String senderNickname;
    private String title;
    private LetterState letterState;
}
