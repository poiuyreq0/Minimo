package com.daepa.minimo.dto;

import com.daepa.minimo.common.embeddables.PostContent;
import com.daepa.minimo.domain.Post;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class PostDto {
    private Long id;
    private Long writerId;
    private String writerNickname;
    private List<CommentDto> comments;
    private PostContent postContent;
    private Integer likeNum;
    private Boolean isLikeSet;
    private Integer commentNum;
    private LocalDateTime createdDate;

    public Post toPost() {
        return Post.builder()
                .postContent(postContent)
                .build();
    }
}
