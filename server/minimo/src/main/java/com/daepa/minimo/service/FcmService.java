package com.daepa.minimo.service;

import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.domain.ChatRoomUser;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.domain.User;
import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
@Transactional
public class FcmService {
    private final UserService userService;

    @Transactional(readOnly = true)
    public void chatNotification(ChatMessage chatMessage) {
        List<ChatRoomUser> chatRoomUsers = chatMessage.getChatRoom().getChatRoomUserList();
        if (chatRoomUsers.size() == 1) {
            return ;
        }

        User sender;
        User receiver;
        if (chatMessage.getSenderId().equals(chatRoomUsers.get(0).getUser().getId())) {
            sender = chatRoomUsers.get(0).getUser();
            receiver = chatRoomUsers.get(1).getUser();
        } else {
            sender = chatRoomUsers.get(1).getUser();
            receiver = chatRoomUsers.get(0).getUser();
        }

        try {
            Message message = Message.builder()
                    .putData("tag", "chat")
                    .putData("roomId", chatMessage.getChatRoom().getId().toString())
                    .putData("senderId", sender.getId().toString())
                    .putData("senderNickname", sender.getNickname())
                    .putData("content", chatMessage.getContent())
                    .putData("createdDate", chatMessage.getCreatedDate().toString())
                    .setToken(receiver.getFcmToken().getToken())
                    .setAndroidConfig(AndroidConfig.builder()
                            .setPriority(AndroidConfig.Priority.HIGH)
                            .build())
                    .build();

            String response = FirebaseMessaging.getInstance().send(message);
            log.info("Successfully sent chat notification: {}", response);

        } catch (FirebaseMessagingException e) {
            log.error("FcmService chatNotification error: {}", e.getMessage());
        }
    }

    @Transactional(readOnly = true)
    public void letterNotification(Letter letter) {
        try {
            Message message = Message.builder()
                    .putData("tag", "letter")
                    .putData("letterId", letter.getId().toString())
                    .putData("receiverId", letter.getReceiver().getId().toString())
                    .putData("receiverNickname", letter.getReceiver().getNickname())
                    .putData("letterState", letter.getLetterState().name())
                    .setToken(letter.getSender().getFcmToken().getToken())
                    .setAndroidConfig(AndroidConfig.builder()
                            .setPriority(AndroidConfig.Priority.HIGH)
                            .build())
                    .build();

            String response = FirebaseMessaging.getInstance().send(message);
            log.info("Successfully sent letter notification: {}", response);

        } catch (FirebaseMessagingException e) {
            log.error("FcmService letterNotification error: {}", e.getMessage());
        }
    }
}
