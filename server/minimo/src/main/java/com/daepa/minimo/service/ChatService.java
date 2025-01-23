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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
        ChatMessage findChatMessage = chatRepository.findChatMessage(messageId);
        findChatMessage.updateIsRead();
    }

    public List<ChatMessageDto> findMessagesByRoom(Long roomId, Long userId) {
        return chatRepository.findMessagesByRoom(roomId, userId);
    }

    public void disconnectChatRoom(Long roomId, Long userId) {
        ChatRoom findChatRoom = chatRepository.findChatRoom(roomId);
        User findUser = userRepository.findUser(userId);

        List<ChatRoomUser> chatRoomUsers = findUser.getChatRoomUserList();
        Iterator<ChatRoomUser> iterator = chatRoomUsers.iterator();
        while (iterator.hasNext()) {
            ChatRoomUser chatRoomUser = iterator.next();
            if (chatRoomUser.getChatRoom().getId().equals(roomId)) {
                iterator.remove();
                findChatRoom.getChatRoomUserList().remove(chatRoomUser);
                break;
            }
        }

        deleteChatRoomIfOwnerless(findChatRoom);
    }

    @Transactional(readOnly = true)
    public void checkChatRoomByUser(Long roomId, Long userId) {
        User findUser = userRepository.findUser(userId);
        List<ChatRoomUser> chatRoomUsers = findUser.getChatRoomUserList();
        validateChatRoomNotNull(roomId, chatRoomUsers);
    }

    @Transactional(readOnly = true)
    public List<ChatRoomDto> findChatRoomsByUser(Long userId) {
        return chatRepository.findChatRoomsByUser(userId);
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
