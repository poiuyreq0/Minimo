package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import com.daepa.minimo.common.embeddables.PostContent;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.NonNull;

import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@Getter
@Entity
@Table(
    indexes = {
        @Index(name = "idx_created_date", columnList = "created_date"),
    }
)
public class Post extends BaseTimeEntity {
    @Builder
    public Post(@NonNull PostContent postContent) {
        this.postContent = postContent;
    }

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "writer_id")
    private User writer;
    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> comments = new ArrayList<>();
    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PostLikeRecord> postLikeRecordList = new ArrayList<>();

    @Embedded
    private PostContent postContent;

    private Integer likeNum = 0;
    private Integer commentNum = 0;

    public void updateWriter(User writer) {
        this.writer = writer;
    }

    public void decreaseLikeNum() {
        likeNum -= 1;
    }

    public void increaseLikeNum() {
        likeNum += 1;
    }

    public void decreaseCommentNum() {
        commentNum -= 1;
    }

    public void increaseCommentNum() {
        commentNum += 1;
    }
}
