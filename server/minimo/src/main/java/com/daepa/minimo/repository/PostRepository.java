package com.daepa.minimo.repository;

import com.daepa.minimo.domain.Post;
import com.daepa.minimo.dto.PostDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

import static com.daepa.minimo.domain.QPost.post;

@RequiredArgsConstructor
@Repository
public class PostRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void savePost(Post post) {
        em.persist(post);
    }

    // createdDate로 페이징
    public List<PostDto> findPosts(LocalDateTime lastDate) {
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
                .where(post.createdDate.lt(lastDate))
                .orderBy(post.createdDate.desc())
                .from(post)
                .limit(20)
                .fetch();
    }
}
