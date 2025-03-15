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
@Setter
public class PostDto {
    private Long id;
    private Long writerId;
    private String writerNickname;
    private PostContent postContent;
    private Integer likeNum;
    private Integer commentNum;
    private LocalDateTime createdDate;
    private Boolean isLikeSet;
    @Builder.Default
    private List<CommentDto> comments = new ArrayList<>();

    public Post toPost() {
        return Post.builder()
                .postContent(postContent)
                .build();
    }
}
