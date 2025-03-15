package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
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
public class Comment extends BaseTimeEntity {
    @Builder
    public Comment(@NonNull Long writerId, @NonNull String writerNickname, @NonNull String content) {
        this.writerId = writerId;
        this.writerNickname = writerNickname;
        this.content = content;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id")
    private Post post;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_comment_id")
    private Comment parentComment;
    @OneToMany(mappedBy = "parentComment", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> childComments = new ArrayList<>();
    @OneToMany(mappedBy = "comment", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CommentLikeRecord> commentLikeRecordList = new ArrayList<>();

    private Long writerId;
    private String writerNickname;

    @Lob
    private String content;

    private Integer likeNum = 0;
    private Boolean isVisible = true;

    public void updatePost(Post post) {
        this.post = post;
    }

    public void updateParentComment(Comment parentComment) {
        this.parentComment = parentComment;
        parentComment.childComments.add(this);
    }

    public void decreaseLikeNum() {
        likeNum -= 1;
    }

    public void increaseLikeNum() {
        likeNum += 1;
    }

    public void updateIsVisible() {
        isVisible = false;
        post.decreaseCommentNum();
    }
}
