package com.daepa.minimo.repository;

import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.domain.ChatRoom;
import com.daepa.minimo.domain.ChatRoomUser;
import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.dto.LetterDto;
import com.querydsl.core.group.GroupBy;
import com.querydsl.core.types.ExpressionUtils;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.daepa.minimo.domain.QChatMessage.chatMessage;
import static com.daepa.minimo.domain.QChatRoom.chatRoom;
import static com.daepa.minimo.domain.QChatRoomUser.chatRoomUser;
import static com.daepa.minimo.domain.QUser.user;

@RequiredArgsConstructor
@Repository
public class ChatRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void saveChatRoom(ChatRoom chatRoom) {
        em.persist(chatRoom);
    }

    public void saveChatRoomUser(ChatRoomUser chatRoomUser) {
        em.persist(chatRoomUser);
    }

    public void saveChatMessage(ChatMessage chatMessage) {
        em.persist(chatMessage);
    }

    public ChatRoom findChatRoom(Long roomId) {
        return em.find(ChatRoom.class, roomId);
    }

    public Long findChatRoomIdByLetterId(Long letterId) {
        return queryFactory
                .select(chatRoom.id)
                .from(chatRoom)
                .where(chatRoom.letterId.eq(letterId))
                .fetchFirst();
    }

    public List<ChatRoomDto> findChatRooms(Long userId) {
        List<ChatRoomDto> chatRooms = queryFactory
                .select(Projections.fields(
                        ChatRoomDto.class,
                        chatRoomUser.chatRoom.id
                ))
                .from(chatRoomUser)
                .join(chatRoom.chatRoomUserList)
                .where(chatRoomUser.user.id.eq(userId))
                .fetch();

        return chatRooms.stream().map(
                chatRoomDto -> {
                    List<String> userNicknames = queryFactory
                            .select(chatRoomUser.user.nickname)
                            .from(chatRoomUser)
                            .join(chatRoomUser.user)
                            .where(chatRoomUser.chatRoom.id.eq(chatRoomDto.getId()))
                            .fetch();

                    ChatMessageDto lastMessage = queryFactory
                            .select(Projections.fields(
                                    ChatMessageDto.class,
                                    chatMessage.id,
                                    chatMessage.chatRoom.id.as("roomId"),
                                    chatMessage.senderId,
                                    chatMessage.content,
                                    chatMessage.timeStamp
                            ))
                            .from(chatMessage)
                            .where(chatMessage.chatRoom.id.eq(chatRoomDto.getId()))
                            .orderBy(chatMessage.timeStamp.desc())
                            .fetchFirst();

                    return ChatRoomDto.builder()
                            .id(chatRoomDto.getId())
                            .userNicknames(userNicknames)
                            .lastMessage(lastMessage)
                            .build();
                }
        ).toList();
    }
}
