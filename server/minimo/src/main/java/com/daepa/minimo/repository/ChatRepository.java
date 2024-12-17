package com.daepa.minimo.repository;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.domain.ChatRoom;
import com.daepa.minimo.domain.ChatRoomUser;
import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.dto.UserNicknameDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

import static com.daepa.minimo.domain.QChatMessage.chatMessage;
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

    public List<ChatRoomDto> findChatRoomsByUser(Long userId) {
        List<ChatRoomDto> chatRooms = queryFactory
                .select(Projections.fields(
                        ChatRoomDto.class,
                        chatRoomUser.chatRoom.id,
                        chatRoomUser.chatRoom.createdDate
                ))
                .from(chatRoomUser)
                .where(chatRoomUser.user.id.eq(userId))
                .fetch();

        return chatRooms.stream().map(
                chatRoomDto -> {
                    List<UserNicknameDto> userNicknameDtos = queryFactory
                            .select(Projections.fields(
                                    UserNicknameDto.class,
                                    chatRoomUser.user.id,
                                    chatRoomUser.user.nickname
                            ))
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
                                    chatMessage.isRead,
                                    chatMessage.createdDate
                            ))
                            .from(chatMessage)
                            .where(chatMessage.chatRoom.id.eq(chatRoomDto.getId()))
                            .orderBy(chatMessage.createdDate.desc())
                            .fetchFirst();

                    Long readNum = queryFactory
                            .select(chatMessage.count())
                            .from(chatMessage)
                            .where(chatMessage.chatRoom.id.eq(chatRoomDto.getId())
                                    .and(chatMessage.isRead.eq(false))
                                    .and(chatMessage.senderId.ne(userId)))
                            .fetchOne();

                    return ChatRoomDto.builder()
                            .id(chatRoomDto.getId())
                            .userNicknames(userNicknameDtos)
                            .lastMessage(lastMessage)
                            .readNum(readNum)
                            .createdDate(chatRoomDto.getCreatedDate())
                            .build();
                }
        ).toList();
    }

    public List<ChatMessageDto> readMessages(Long roomId, Long userId) {
        queryFactory
                .update(chatMessage)
                .set(chatMessage.isRead, true)
                .where(chatMessage.chatRoom.id.eq(roomId)
                        .and(chatMessage.isRead.eq(false))
                        .and(chatMessage.senderId.ne(userId)))
                .execute();

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
                .fetch();
    }

    public void deleteChatRoom(ChatRoom chatRoom) {
        em.remove(chatRoom);
    }
}
