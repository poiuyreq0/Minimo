package com.daepa.minimo.api;

import com.daepa.minimo.dto.CommentDto;
import com.daepa.minimo.dto.LikeDto;
import com.daepa.minimo.dto.PostDto;
import com.daepa.minimo.service.FcmService;
import com.daepa.minimo.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api-post")
public class PostApiController {
    private final PostService postService;
    private final FcmService fcmService;

    @PreAuthorize("hasRole('USER')")
    @PostMapping("/posts")
    public ResponseEntity<Map<String, Long>> createPost(@RequestBody PostDto postDto) {
        Long postId = postService.createPost(postDto.getWriterId(), postDto.toPost());
        return ResponseEntity.ok(Map.of("postId", postId));
    }

    @DeleteMapping("/posts/{id}")
    public ResponseEntity<Map<String, Long>> deletePost(@PathVariable("id") Long postId) {
        postService.deletePost(postId);
        return ResponseEntity.ok(Map.of("postId", postId));
    }

    @PreAuthorize("hasRole('USER')")
    @PostMapping("/comments")
    public ResponseEntity<Map<String, Long>> sendComment(@RequestBody CommentDto commentDto) {
        Long commentId = postService.sendComment(commentDto.getPostId(), commentDto.getParentCommentId(), commentDto.toComment());

        fcmService.commentNotification(commentId);

        return ResponseEntity.ok(Map.of("commentId", commentId));
    }

    @DeleteMapping("/comments/{id}")
    public ResponseEntity<Map<String, Long>> deleteComment(@PathVariable("id") Long commentId) {
        postService.deleteComment(commentId);
        return ResponseEntity.ok(Map.of("commentId", commentId));
    }

    @GetMapping("/posts")
    public ResponseEntity<List<PostDto>> getPostsWithPaging(@RequestParam("userId") Long userId, @RequestParam("count") Integer count, @RequestParam(value = "lastDate", required = false) LocalDateTime lastDate, @RequestParam(value = "isPostMine") Boolean isPostMine, @RequestParam(value = "isCommentMine") Boolean isCommentMine) {
        List<PostDto> posts = postService.getPostsWithPaging(userId, count, lastDate, isPostMine, isCommentMine);
        return ResponseEntity.ok(posts);
    }

    @GetMapping("/posts/{id}")
    public ResponseEntity<PostDto> getPost(@PathVariable("id") Long postId, @RequestParam("userId") Long userId) {
        PostDto post = postService.getPost(postId, userId);
        return ResponseEntity.ok(post);
    }

    @PostMapping("/posts/{id}/like")
    public ResponseEntity<LikeDto> updatePostLikeNum(@PathVariable("id") Long postId, @RequestParam("userId") Long userId) {
        LikeDto like = postService.updatePostLikeNum(postId, userId);
        return ResponseEntity.ok(like);
    }

    @PostMapping("/comments/{id}/like")
    public ResponseEntity<LikeDto> updateCommentLikeNum(@PathVariable("id") Long commentId, @RequestParam("userId") Long userId) {
        LikeDto like = postService.updateCommentLikeNum(commentId, userId);
        return ResponseEntity.ok(like);
    }
}
