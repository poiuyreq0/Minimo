package com.daepa.minimo.repository;

import com.daepa.minimo.domain.Comment;
import com.daepa.minimo.domain.CommentLikeRecord;
import com.daepa.minimo.domain.Post;
import com.daepa.minimo.domain.PostLikeRecord;
import com.daepa.minimo.dto.*;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.daepa.minimo.domain.QComment.comment;
import static com.daepa.minimo.domain.QCommentLikeRecord.commentLikeRecord;
import static com.daepa.minimo.domain.QPost.post;
import static com.daepa.minimo.domain.QPostLikeRecord.postLikeRecord;
import static com.daepa.minimo.domain.QUser.user;
import static com.daepa.minimo.domain.QUserBanRecord.userBanRecord;

@RequiredArgsConstructor
@Repository
public class PostRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public Post findPost(Long postId) {
        return em.find(Post.class, postId);
    }

    public Comment findComment(Long commentId) {
        return em.find(Comment.class, commentId);
    }

    public void savePost(Post post) {
        em.persist(post);
    }

    public void saveComment(Comment comment) {
        em.persist(comment);
    }

    // 페이징: Post createdDate
    public List<PostDto> getPostsWithPaging(Long userId, Integer count, LocalDateTime lastDate) {
        return queryFactory
                .select(Projections.fields(
                        PostDto.class,
                        post.id,
                        post.writer.id.as("writerId"),
                        post.writer.nickname.as("writerNickname"),
                        post.postContent,
                        post.likeNum,
                        post.commentNum,
                        post.createdDate
                ))
                .from(post)
                .leftJoin(userBanRecord)
                .on(userBanRecord.user.id.eq(userId)
                        .and(userBanRecord.targetId.eq(post.writer.id)))
                .where(lastDate != null ? post.createdDate.lt(lastDate) : null)
                .where(userBanRecord.id.isNull())
                .orderBy(post.createdDate.desc())
                .limit(count)
                .fetch();
    }

    // 페이징: Post createdDate
    public List<PostDto> getPostsByUserWithPaging(Long userId, Integer count, LocalDateTime lastDate) {
        return queryFactory
                .select(Projections.fields(
                        PostDto.class,
                        post.id,
                        post.writer.id.as("writerId"),
                        post.writer.nickname.as("writerNickname"),
                        post.postContent,
                        post.likeNum,
                        post.commentNum,
                        post.createdDate
                ))
                .from(post)
                .where(lastDate != null ? post.createdDate.lt(lastDate) : null)
                .where(post.writer.id.eq(userId))
                .orderBy(post.createdDate.desc())
                .limit(count)
                .fetch();
    }

    // 페이징: Post createdDate
    public List<PostDto> getPostsByUserCommentWithPaging(Long userId, Integer count, LocalDateTime lastDate) {
        return queryFactory
                .select(Projections.fields(
                        PostDto.class,
                        post.id,
                        post.writer.id.as("writerId"),
                        post.writer.nickname.as("writerNickname"),
                        post.postContent,
                        post.likeNum,
                        post.commentNum,
                        post.createdDate
                ))
                .from(post)
                .join(post.comments, comment)
                .on(comment.post.id.eq(post.id)
                        .and(comment.writerId.eq(userId)))
                .leftJoin(userBanRecord)
                .on(userBanRecord.user.id.eq(userId)
                        .and(userBanRecord.targetId.eq(post.writer.id)))
                .where(userBanRecord.id.isNull())
                .groupBy(post.id)
                .having(lastDate != null ? comment.createdDate.max().lt(lastDate) : null)
                .orderBy(comment.createdDate.max().desc())
                .limit(count)
                .fetch();
    }

    public PostDto getPost(Long postId, Long userId) {
        // 모든 댓글 조회
        List<CommentDto> commentDtos = queryFactory
                .select(Projections.fields(
                        CommentDto.class,
                        comment.id,
                        comment.post.id.as("postId"),
                        comment.parentComment.id.as("parentCommentId"),
                        comment.writerId.as("writerId"),
                        comment.writerNickname.as("writerNickname"),
                        comment.content,
                        comment.likeNum,
                        comment.isVisible,
                        comment.createdDate,
                        commentLikeRecord.id.isNotNull().as("isLikeSet")
                ))
                .from(comment)
                .leftJoin(comment.commentLikeRecordList, commentLikeRecord)
                .on(commentLikeRecord.comment.id.eq(comment.id)
                        .and(commentLikeRecord.likerId.eq(userId)))
                .where(comment.post.id.eq(postId))
                .orderBy(comment.createdDate.asc())
                .fetch();

        Map<Long, CommentDto> parentCommentMap = new HashMap<>();
        List<CommentDto> parentComments = new ArrayList<>();
        for (CommentDto commentDto: commentDtos) {
            // 부모 댓글인 경우
            if (commentDto.getParentCommentId() == null) {
                parentCommentMap.put(commentDto.getId(), commentDto);
                parentComments.add(commentDto);
                
            // 자식 댓글인 경우
            } else {
                CommentDto parentComment = parentCommentMap.get(commentDto.getParentCommentId());
                parentComment.getComments().add(commentDto);
            }
        }

        PostDto postDto = queryFactory
                .select(Projections.fields(
                        PostDto.class,
                        post.id,
                        post.writer.id.as("writerId"),
                        post.writer.nickname.as("writerNickname"),
                        post.postContent,
                        post.likeNum,
                        post.commentNum,
                        post.createdDate,
                        postLikeRecord.id.isNotNull().as("isLikeSet")
                ))
                .from(post)
                .leftJoin(post.postLikeRecordList, postLikeRecord)
                .on(postLikeRecord.post.id.eq(post.id)
                        .and(postLikeRecord.likerId.eq(userId)))
                .leftJoin(userBanRecord)
                .on(userBanRecord.user.id.eq(userId)
                        .and(userBanRecord.targetId.eq(post.writer.id)))
                .where(post.id.eq(postId))
                .where(userBanRecord.id.isNull())
                .fetchOne();

        if (postDto != null) {
            postDto.setComments(parentComments);
        }

        return postDto;
    }

    public LikeDto getPostLikeNum(Long postId, Long userId) {
        return queryFactory
                .select(Projections.fields(
                        LikeDto.class,
                        post.likeNum,
                        postLikeRecord.id.isNotNull().as("isLikeSet")
                ))
                .from(post)
                .leftJoin(post.postLikeRecordList, postLikeRecord)
                .on(postLikeRecord.post.id.eq(post.id)
                        .and(postLikeRecord.likerId.eq(userId)))
                .where(post.id.eq(postId))
                .fetchOne();
    }

    public LikeDto getCommentLikeNum(Long commentId, Long userId) {
        return queryFactory
                .select(Projections.fields(
                        LikeDto.class,
                        comment.likeNum,
                        commentLikeRecord.id.isNotNull().as("isLikeSet")
                ))
                .from(comment)
                .leftJoin(comment.commentLikeRecordList, commentLikeRecord)
                .on(commentLikeRecord.comment.id.eq(comment.id)
                        .and(commentLikeRecord.likerId.eq(userId)))
                .where(comment.id.eq(commentId))
                .fetchOne();
    }

    public void deletePostLikeRecord(Long userId) {
        queryFactory
                .delete(postLikeRecord)
                .where(postLikeRecord.likerId.eq(userId))
                .execute();
    }

    public void savePostLikeRecord(PostLikeRecord postLikeRecord) {
        em.persist(postLikeRecord);
    }

    public void deleteCommentLikeRecord(Long userId) {
        queryFactory
                .delete(commentLikeRecord)
                .where(commentLikeRecord.likerId.eq(userId))
                .execute();
    }

    public void saveCommentLikeRecord(CommentLikeRecord commentLikeRecord) {
        em.persist(commentLikeRecord);
    }

    public void deleteComment(Long commentId) {
        queryFactory
                .update(comment)
                .set(comment.isVisible, false)
                .where(comment.id.eq(commentId))
                .execute();
    }

    public void deletePost(Post post) {
        em.remove(post);
    }

    public Comment getCommentForNotification(Long commentId) {
        return queryFactory
                .selectFrom(comment)
                .leftJoin(comment.post, post).fetchJoin()
                .leftJoin(post.writer, user).fetchJoin()
                .leftJoin(user.fcmToken).fetchJoin()
                .where(comment.id.eq(commentId))
                .fetchOne();
    }
}
