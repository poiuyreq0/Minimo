package com.daepa.minimo.repository;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.domain.ChatRoom;
import com.daepa.minimo.domain.ChatRoomUser;
import com.daepa.minimo.domain.QChatMessage;
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

    public ChatMessage findChatMessage(Long messageId) {
        return em.find(ChatMessage.class, messageId);
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
                .leftJoin(chatRoom.messages, chatMessage)
                .where(chatRoomUser.user.id.eq(userId))
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

        QChatMessage subChatMessage = new QChatMessage("subChatMessage");
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
                                .select(subChatMessage.createdDate.max())
                                .from(subChatMessage)
                                .where(subChatMessage.chatRoom.id.eq(chatMessage.chatRoom.id))
                ))
                .fetch();

        for (ChatMessageDto lastMessage: lastMessages) {
            ChatRoomDto chatRoomDto = chatRoomDtoMap.get(lastMessage.getRoomId());
            chatRoomDto.setLastMessage(lastMessage);
        }

        return chatRoomDtos;
    }

    // 페이징: ChatMessage createdDate
    public List<ChatMessageDto> getMessagesByRoomWithPaging(Long roomId, Long userId, LocalDateTime lastDate, Integer count) {
        // 처음 채팅방 입장 시 메시지 읽음 표시
        if (lastDate == null) {
            readMessages(roomId, userId);
        }

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

    private void readMessages(Long roomId, Long userId) {
        queryFactory
                .update(chatMessage)
                .set(chatMessage.isRead, true)
                .where(chatMessage.chatRoom.id.eq(roomId)
                        .and(chatMessage.isRead.eq(false))
                        .and(chatMessage.senderId.ne(userId)))
                .execute();
    }

    public void deleteChatRoom(ChatRoom chatRoom) {
        em.remove(chatRoom);
    }
}
