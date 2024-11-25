package com.daepa.minimo.repository;

import com.daepa.minimo.domain.ChatRoom;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@RequiredArgsConstructor
@Repository
public class ChatRoomRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void saveChatRoom(ChatRoom chatRoom) {
        em.persist(chatRoom);
    }
}
