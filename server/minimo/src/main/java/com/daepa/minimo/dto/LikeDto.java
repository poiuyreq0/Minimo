package com.daepa.minimo.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class LikeDto {
    private Boolean isLikeSet;
    private Integer likeNum;
}
