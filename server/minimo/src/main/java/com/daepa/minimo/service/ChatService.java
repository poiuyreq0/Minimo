package com.daepa.minimo.service;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.domain.ChatRoom;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.exception.ChatRoomNotFoundException;
import com.daepa.minimo.repository.ChatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@RequiredArgsConstructor
@Service
@Transactional
public class ChatService {
    private final ChatRepository chatRepository;

    @Transactional(readOnly = true)
    public List<ChatMessage> findMessages(Long roomId) {
        ChatRoom findChatRoom = chatRepository.findChatRoom(roomId);
        return findChatRoom.getMessages();
    }

    @Transactional(readOnly = true)
    public Long findChatRoomIdByLetterId(Long letterId) {
        return chatRepository.findChatRoomIdByLetterId(letterId);
    }

    @Transactional(readOnly = true)
    public List<ChatRoomDto> findChatRooms(Long userId) {
        return chatRepository.findChatRooms(userId);
    }

    public void sendMessage(Long roomId, ChatMessage message) {
        ChatRoom findChatRoom = chatRepository.findChatRoom(roomId);
        message.changeChatRoom(findChatRoom);
        chatRepository.saveChatMessage(message);
    }

    private void validateChatRoomNotNull(ChatRoom chatRoom) {
        if (chatRoom == null) {
            throw new ChatRoomNotFoundException();
        }
    }
}
