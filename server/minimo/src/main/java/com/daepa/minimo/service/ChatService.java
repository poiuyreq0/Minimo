package com.daepa.minimo.service;

import com.daepa.minimo.common.enums.UserRole;
import com.daepa.minimo.domain.*;
import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.exception.ChatRoomNotFoundException;
import com.daepa.minimo.exception.LetterNotFoundException;
import com.daepa.minimo.repository.ChatRepository;
import com.daepa.minimo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Iterator;
import java.util.List;

@RequiredArgsConstructor
@Service
@Transactional
public class ChatService {
    private final ChatRepository chatRepository;
    private final UserRepository userRepository;

    public ChatMessage sendMessage(Long roomId, ChatMessage chatMessage) {
        ChatRoom findChatRoom = chatRepository.findChatRoom(roomId);
        chatMessage.updateChatRoom(findChatRoom);
        chatRepository.saveChatMessage(chatMessage);
        return chatMessage;
    }

    public void readMessage(Long messageId) {
        chatRepository.readMessage(messageId);
    }

    public List<ChatMessageDto> getMessagesByRoomWithPaging(Long roomId, Long userId, Integer count, LocalDateTime lastDate) {
        validateChatRoomOwner(roomId, userId);

        // 처음 채팅방 입장 시 메시지 읽음 표시
        if (lastDate == null) {
            chatRepository.readMessages(roomId, userId);
        }

        return chatRepository.getMessagesByRoomWithPaging(roomId, lastDate, count);
    }

    public void disconnectChatRoom(Long roomId, Long userId) {
        chatRepository.disconnectChatRoom(roomId, userId);
    }

    @Transactional(readOnly = true)
    public List<ChatRoomDto> getChatRoomsByUserWithPaging(Long userId, Integer count, LocalDateTime lastDate) {
        return chatRepository.getChatRoomsByUserWithPaging(userId, count, lastDate);
    }

    private void validateChatRoomOwner(Long roomId, Long userId) {
        ChatRoomUser chatRoomUser = chatRepository.getChatRoomUser(roomId, userId);
        if (chatRoomUser == null) {
            throw new ChatRoomNotFoundException();
        }
    }
}
