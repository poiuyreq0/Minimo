package com.daepa.minimo.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class UserBanRecordDto {
    private Long id;
    private Long targetId;
    private String targetNickname;
    private LocalDateTime createdDate;
}
