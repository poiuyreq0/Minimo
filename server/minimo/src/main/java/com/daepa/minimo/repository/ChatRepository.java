package com.daepa.minimo.repository;

import com.daepa.minimo.domain.*;
import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.dto.ChatRoomUserDto;
import com.querydsl.core.types.ExpressionUtils;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.daepa.minimo.domain.QChatMessage.chatMessage;
import static com.daepa.minimo.domain.QChatRoom.chatRoom;
import static com.daepa.minimo.domain.QChatRoomUser.chatRoomUser;
import static com.daepa.minimo.domain.QLetter.letter;
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

    // 페이징: ChatMessage createdDate, ChatRoom createdDate
    public List<ChatRoomDto> getChatRoomsByUserWithPaging(Long userId, Integer count, LocalDateTime lastDate) {
        List<ChatRoomDto> chatRoomDtos = queryFactory
                .select(Projections.fields(
                        ChatRoomDto.class,
                        chatRoom.id,
                        chatRoom.createdDate,
                        ExpressionUtils.as(
                                JPAExpressions
                                        .select(chatMessage.count())
                                        .from(chatMessage)
                                        .where(chatMessage.chatRoom.id.eq(chatRoom.id)
                                                .and(chatMessage.isRead.eq(false))
                                                .and(chatMessage.senderId.ne(userId))),
                                "readNum"
                        )
                ))
                .from(chatRoom)
                .join(chatRoom.chatRoomUserList, chatRoomUser)
                .on(chatRoomUser.chatRoom.id.eq(chatRoom.id)
                        .and(chatRoomUser.user.id.eq(userId)))
                .leftJoin(chatRoom.messages, chatMessage)
                .groupBy(chatRoom.id)
                .having(lastDate != null ? chatMessage.createdDate.max().coalesce(chatRoom.createdDate).lt(lastDate) : null)
                .orderBy(chatMessage.createdDate.max().coalesce(chatRoom.createdDate).desc())
                .limit(count)
                .fetch();

        Map<Long, ChatRoomDto> chatRoomDtoMap = new HashMap<>();
        for (ChatRoomDto chatRoomDto: chatRoomDtos) {
            chatRoomDtoMap.put(chatRoomDto.getId(), chatRoomDto);
        }

        List<ChatRoomUserDto> chatRoomUserDtos = queryFactory
                .select(Projections.fields(
                        ChatRoomUserDto.class,
                        chatRoomUser.user.id,
                        chatRoomUser.chatRoom.id.as("chatRoomId"),
                        chatRoomUser.user.nickname
                ))
                .from(chatRoomUser)
                .where(chatRoomUser.chatRoom.id.in(chatRoomDtoMap.keySet()))
                .fetch();

        for (ChatRoomUserDto chatRoomUserDto : chatRoomUserDtos) {
            ChatRoomDto chatRoomDto = chatRoomDtoMap.get(chatRoomUserDto.getChatRoomId());
            chatRoomDto.getUserNicknames().add(chatRoomUserDto);
        }

        QChatMessage subqueryChatMessage = new QChatMessage("subqueryChatMessage");
        List<ChatMessageDto> lastMessages = queryFactory
                .select(Projections.fields(
                        ChatMessageDto.class,
                        chatMessage.id,
                        chatMessage.chatRoom.id.as("roomId"),
                        chatMessage.senderId,
                        chatMessage.content,
                        chatMessage.isRead,
                        chatMessage.createdDate
                ))
                .from(chatMessage)
                .where(chatMessage.chatRoom.id.in(chatRoomDtoMap.keySet()))
                .where(chatMessage.createdDate.eq(
                        JPAExpressions
                                .select(subqueryChatMessage.createdDate.max())
                                .from(subqueryChatMessage)
                                .where(subqueryChatMessage.chatRoom.id.eq(chatMessage.chatRoom.id))
                ))
                .fetch();

        for (ChatMessageDto lastMessage: lastMessages) {
            ChatRoomDto chatRoomDto = chatRoomDtoMap.get(lastMessage.getRoomId());
            chatRoomDto.setLastMessage(lastMessage);
        }

        return chatRoomDtos;
    }

    // 페이징: ChatMessage createdDate
    public List<ChatMessageDto> getMessagesByRoomWithPaging(Long roomId, LocalDateTime lastDate, Integer count) {
        return queryFactory
                .select(Projections.fields(
                        ChatMessageDto.class,
                        chatMessage.id,
                        chatMessage.chatRoom.id.as("roomId"),
                        chatMessage.senderId,
                        chatMessage.content,
                        chatMessage.isRead,
                        chatMessage.createdDate
                ))
                .from(chatMessage)
                .where(chatMessage.chatRoom.id.eq(roomId))
                .where(lastDate != null ? chatMessage.createdDate.lt(lastDate) : null)
                .orderBy(chatMessage.createdDate.desc())
                .limit(count)
                .fetch();
    }

    public ChatRoomUser getChatRoomUser(Long roomId, Long userId) {
        return queryFactory
                .selectFrom(chatRoomUser)
                .where(chatRoomUser.chatRoom.id.eq(roomId)
                        .and(chatRoomUser.user.id.eq(userId)))
                .fetchOne();
    }

    public void readMessage(Long messageId) {
        queryFactory
                .update(chatMessage)
                .set(chatMessage.isRead, true)
                .where(chatMessage.id.eq(messageId))
                .execute();
    }

    public void readMessages(Long roomId, Long userId) {
        queryFactory
                .update(chatMessage)
                .set(chatMessage.isRead, true)
                .where(chatMessage.chatRoom.id.eq(roomId)
                        .and(chatMessage.isRead.eq(false))
                        .and(chatMessage.senderId.ne(userId)))
                .execute();
    }

    public void disconnectChatRoom(Long roomId, Long userId) {
        // 채팅방 나가기
        queryFactory
                .delete(chatRoomUser)
                .where(chatRoomUser.chatRoom.id.eq(roomId)
                        .and(chatRoomUser.user.id.eq(userId)))
                .execute();

        // 주인 없는 채팅방 삭제
        queryFactory
                .delete(chatRoom)
                .where(chatRoom.chatRoomUserList.isEmpty())
                .execute();
    }

    public ChatMessage getMessageForNotification(Long messageId) {
        return queryFactory
                .selectFrom(chatMessage)
                .leftJoin(chatMessage.chatRoom, chatRoom).fetchJoin()
                .leftJoin(chatRoom.chatRoomUserList, chatRoomUser).fetchJoin()
                .leftJoin(chatRoomUser.user, user).fetchJoin()
                .leftJoin(user.fcmToken).fetchJoin()
                .where(chatMessage.id.eq(messageId))
                .fetchOne();
    }
}
