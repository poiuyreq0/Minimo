package com.daepa.minimo.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class CommentDto {
    private Long id;
    private Long postId;
    private Long writerId;
    private String writerNickname;
    private List<CommentDto> comments;
    private String content;
    private Integer likeNum;
    private Boolean isLikeSet;
    private Boolean isVisible;
    private LocalDateTime createdDate;
}
