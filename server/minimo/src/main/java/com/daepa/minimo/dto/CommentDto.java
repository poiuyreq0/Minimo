package com.daepa.minimo.dto;

import com.daepa.minimo.domain.Comment;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class CommentDto {
    private Long id;
    private Long postId;
    private Long parentCommentId;
    private Long writerId;
    private String writerNickname;
    private String content;
    private Integer likeNum;
    private Boolean isVisible;
    private LocalDateTime createdDate;
    private Boolean isLikeSet;
    @Builder.Default
    private List<CommentDto> comments = new ArrayList<>();

    public Comment toComment() {
        return Comment.builder()
                .writerId(writerId)
                .writerNickname(writerNickname)
                .content(content)
                .build();
    }
}
