package com.daepa.minimo.service;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.domain.ChatRoom;
import com.daepa.minimo.domain.ChatRoomUser;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.exception.ChatRoomNotFoundException;
import com.daepa.minimo.repository.ChatRepository;
import com.daepa.minimo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
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
    public List<ChatMessage> findMessages(Long roomId) {
        ChatRoom findChatRoom = chatRepository.findChatRoom(roomId);
        return findChatRoom.getMessages();
    }

    @Transactional(readOnly = true)
    public Long checkChatRoomByUser(Long roomId, Long userId) {
        User findUser = userRepository.findUser(userId);

        List<ChatRoomUser> chatRoomUsers = findUser.getChatRoomUserList();
        validateChatRoomNotNull(roomId, chatRoomUsers);

        return roomId;
    }

    @Transactional(readOnly = true)
    public List<ChatRoomDto> findChatRooms(Long userId) {
        return chatRepository.findChatRooms(userId);
    }

    public void sendMessage(Long roomId, ChatMessage message) {
        ChatRoom findChatRoom = chatRepository.findChatRoom(roomId);
        message.updateChatRoom(findChatRoom);
        chatRepository.saveChatMessage(message);
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
