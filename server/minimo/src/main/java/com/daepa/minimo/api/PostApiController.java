package com.daepa.minimo.api;

import com.daepa.minimo.dto.PostDto;
import com.daepa.minimo.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/post")
public class PostApiController {
    private final PostService postService;

    @PostMapping
    public ResponseEntity<Map<String, Long>> createPost(@RequestBody PostDto postDto) {
        Long postId = postService.createPost(postDto.getWriterId(), postDto.toPost());
        return ResponseEntity.ok(Map.of("postId", postId));
    }

    @GetMapping("/paging")
    public ResponseEntity<List<PostDto>> getPosts(@RequestParam("lastDate") LocalDateTime lastDate) {
        List<PostDto> posts = postService.findPosts(lastDate);
        return ResponseEntity.ok(posts);
    }
}
