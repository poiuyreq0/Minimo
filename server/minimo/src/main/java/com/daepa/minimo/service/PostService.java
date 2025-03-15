package com.daepa.minimo.service;

import com.daepa.minimo.domain.*;
import com.daepa.minimo.dto.LikeDto;
import com.daepa.minimo.dto.PostDto;
import com.daepa.minimo.repository.PostRepository;
import com.daepa.minimo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@RequiredArgsConstructor
@Service
@Transactional
public class PostService {
    private final PostRepository postRepository;
    private final UserRepository userRepository;

    public Long createPost(Long writerId, Post post) {
        User writer = userRepository.findUser(writerId);
        post.updateWriter(writer);

        postRepository.savePost(post);
        return post.getId();
    }

    public void deletePost(Long postId) {
        Post post = postRepository.findPost(postId);
        postRepository.deletePost(post);
    }

    public Long sendComment(Long postId, Long parentCommentId, Comment comment) {
        Post findPost = postRepository.findPost(postId);
        comment.updatePost(findPost);

        if (parentCommentId != null) {
            Comment parentComment = postRepository.findComment(parentCommentId);
            comment.updateParentComment(parentComment);
        }

        postRepository.saveComment(comment);
        findPost.increaseCommentNum();

        return comment.getId();
    }

    public void deleteComment(Long commentId) {
        Comment findComment = postRepository.findComment(commentId);
        findComment.updateIsVisible();
    }

    @Transactional(readOnly = true)
    public List<PostDto> getPostsWithPaging(Long userId, Integer count, LocalDateTime lastDate, Boolean isPostMine, Boolean isCommentMine) {
        if (isPostMine) {
            return postRepository.getPostsByUserWithPaging(userId, count, lastDate);
        } else if (isCommentMine) {
            return postRepository.getPostsByUserCommentWithPaging(userId, count, lastDate);
        } else {
            return postRepository.getPostsWithPaging(userId, count, lastDate);
        }
    }

    @Transactional(readOnly = true)
    public PostDto getPost(Long postId, Long userId) {
        return postRepository.getPost(postId, userId);
    }

    public LikeDto updatePostLikeNum(Long postId, Long userId) {
        Post findPost = postRepository.findPost(postId);
        LikeDto like = postRepository.getPostLikeNum(postId, userId);

        // 좋아요 - 1
        if (like.getIsLikeSet()) {
            postRepository.deletePostLikeRecord(userId);
            findPost.decreaseLikeNum();

            like.setLikeNum(findPost.getLikeNum());
            like.setIsLikeSet(false);

        // 좋아요 + 1
        } else {
            PostLikeRecord likeRecord = PostLikeRecord.builder()
                            .post(findPost)
                            .likerId(userId)
                            .build();

            postRepository.savePostLikeRecord(likeRecord);
            findPost.increaseLikeNum();

            like.setLikeNum(findPost.getLikeNum());
            like.setIsLikeSet(true);
        }

        return like;
    }

    public LikeDto updateCommentLikeNum(Long commentId, Long userId) {
        Comment findComment = postRepository.findComment(commentId);
        LikeDto like = postRepository.getCommentLikeNum(commentId, userId);

        // 좋아요 - 1
        if (like.getIsLikeSet()) {
            postRepository.deleteCommentLikeRecord(userId);
            findComment.decreaseLikeNum();

            like.setLikeNum(findComment.getLikeNum());
            like.setIsLikeSet(false);

        // 좋아요 + 1
        } else {
            CommentLikeRecord likeRecord = CommentLikeRecord.builder()
                    .comment(findComment)
                    .likerId(userId)
                    .build();

            postRepository.saveCommentLikeRecord(likeRecord);
            findComment.increaseLikeNum();

            like.setLikeNum(findComment.getLikeNum());
            like.setIsLikeSet(true);
        }

        return like;
    }
}
