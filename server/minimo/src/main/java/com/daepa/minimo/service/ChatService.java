package com.daepa.minimo.service;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.domain.ChatRoom;
import com.daepa.minimo.domain.ChatRoomUser;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.exception.ChatRoomNotFoundException;
import com.daepa.minimo.repository.ChatRepository;
import com.daepa.minimo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@RequiredArgsConstructor
@Service
@Transactional
public class ChatService {
    private final ChatRepository chatRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public Long checkChatRoomByUser(Long roomId, Long userId) {
        User findUser = userRepository.findUser(userId);

        List<ChatRoomUser> chatRoomUsers = findUser.getChatRoomUserList();
        validateChatRoomNotNull(roomId, chatRoomUsers);

        return roomId;
    }

    @Transactional(readOnly = true)
    public List<ChatRoomDto> findChatRoomsByUser(Long userId) {
        return chatRepository.findChatRoomsByUser(userId);
    }

    public ChatMessage sendMessage(Long roomId, ChatMessage chatMessage) {
        ChatRoom findChatRoom = chatRepository.findChatRoom(roomId);
        chatMessage.updateChatRoom(findChatRoom);
        chatRepository.saveChatMessage(chatMessage);
        return chatMessage;
    }

    public void readMessage(Long messageId) {
        ChatMessage findChatMessage = chatRepository.findChatMessage(messageId);
        findChatMessage.updateIsRead();
    }

    public List<ChatMessageDto> readMessages(Long roomId, Long userId) {
        return chatRepository.readMessages(roomId, userId);
    }

    public Long disconnectChatRoom(Long roomId, Long userId) {
        ChatRoom findChatRoom = chatRepository.findChatRoom(roomId);
        User findUser = userRepository.findUser(userId);

        List<ChatRoomUser> chatRoomUsers = findUser.getChatRoomUserList();
        chatRoomUsers.removeIf(chatRoomUser -> chatRoomUser.getUser().getId().equals(userId));

        deleteChatRoomIfOwnerless(findChatRoom);

        return findChatRoom.getId();
    }

    private void deleteChatRoomIfOwnerless(ChatRoom chatRoom) {
        if (chatRoom.getChatRoomUserList().isEmpty()) {
            chatRepository.deleteChatRoom(chatRoom);
        }
    }

    private void validateChatRoomNotNull(Long roomId, List<ChatRoomUser> chatRoomUsers) {
        ChatRoomUser findChatRoomUser = chatRoomUsers.stream()
                .filter(chatRoomUser -> chatRoomUser.getChatRoom().getId().equals(roomId))
                .findFirst()
                .orElse(null);
        if (findChatRoomUser == null) {
            throw new ChatRoomNotFoundException();
        }
    }
}
