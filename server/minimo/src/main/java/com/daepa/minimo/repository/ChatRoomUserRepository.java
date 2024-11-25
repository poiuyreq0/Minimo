package com.daepa.minimo.repository;

import com.daepa.minimo.domain.ChatRoomUser;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@RequiredArgsConstructor
@Repository
public class ChatRoomUserRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void saveChatRoomUser(ChatRoomUser chatRoomUser) {
        em.persist(chatRoomUser);
    }
}
