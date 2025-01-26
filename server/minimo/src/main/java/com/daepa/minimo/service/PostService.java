package com.daepa.minimo.service;

import com.daepa.minimo.domain.Post;
import com.daepa.minimo.domain.User;
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

    @Transactional(readOnly = true)
    public List<PostDto> findPosts(LocalDateTime lastDate) {
        return postRepository.findPosts(lastDate);
    }
}
