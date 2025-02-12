package com.daepa.minimo.service;

import com.daepa.minimo.domain.*;
import com.daepa.minimo.dto.CommentDto;
import com.daepa.minimo.repository.PostRepository;
import com.daepa.minimo.repository.UserRepository;
import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
@Transactional
public class FcmService {
    private final UserRepository userRepository;
    private final PostRepository postRepository;

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

        FcmToken fcmToken = receiver.getFcmToken();
        if (fcmToken != null) {
            try {
                Message message = Message.builder()
                        .putData("tag", "chat")
                        .putData("roomId", chatMessage.getChatRoom().getId().toString())
                        .putData("senderId", sender.getId().toString())
                        .putData("senderNickname", sender.getNickname())
                        .putData("content", chatMessage.getContent())
                        .putData("createdDate", chatMessage.getCreatedDate().toString())
                        .setToken(fcmToken.getToken())
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
    }

    @Transactional(readOnly = true)
    public void letterNotification(Letter letter) {
        FcmToken fcmToken = letter.getSender().getFcmToken();
        if (fcmToken != null) {
            try {
                Message message = Message.builder()
                        .putData("tag", "letter")
                        .putData("letterId", letter.getId().toString())
                        .putData("receiverId", letter.getReceiver().getId().toString())
                        .putData("receiverNickname", letter.getReceiver().getNickname())
                        .putData("letterState", letter.getLetterState().name())
                        .setToken(fcmToken.getToken())
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

    @Transactional(readOnly = true)
    public void commentNotification(Long commentId) {
        try {
            Comment comment = postRepository.findComment(commentId);
            User writer = comment.getWriter();
            
            Post findPost = comment.getPost();
            User receiver = findPost.getWriter();
            
            if (!writer.getId().equals(receiver.getId())) {
                String fcmToken = findPost.getWriter().getFcmToken().getToken();

                Message message = Message.builder()
                        .putData("tag", "comment")
                        .putData("postId", findPost.getId().toString())
                        .putData("writerId", writer.getId().toString())
                        .putData("writerNickname", writer.getNickname())
                        .putData("content", comment.getContent())
                        .setToken(fcmToken)
                        .setAndroidConfig(AndroidConfig.builder()
                                .setPriority(AndroidConfig.Priority.HIGH)
                                .build())
                        .build();

                // 게시글 작성자에게 알림
                String response = FirebaseMessaging.getInstance().send(message);

                log.info("Successfully sent comment notification: {}", response);
            }


            // 대댓글일 경우
            Comment parentComment = comment.getParentComment();
            if (parentComment != null) {
                User subReceiver = parentComment.getWriter();

                if (!writer.getId().equals(subReceiver.getId())) {
                    String subFcmToken = subReceiver.getFcmToken().getToken();

                    Message subMessage = Message.builder()
                            .putData("tag", "subComment")
                            .putData("postId", findPost.getId().toString())
                            .putData("writerId", writer.getId().toString())
                            .putData("writerNickname", writer.getNickname())
                            .putData("content", comment.getContent())
                            .setToken(subFcmToken)
                            .setAndroidConfig(AndroidConfig.builder()
                                    .setPriority(AndroidConfig.Priority.HIGH)
                                    .build())
                            .build();

                    // 댓글 작성자에게 알림
                    String subResponse = FirebaseMessaging.getInstance().send(subMessage);

                    log.info("Successfully sent sub comment notification: {}", subResponse);
                }
            }

        } catch (Exception e) {
            log.error("FcmService commentNotification error: {}", e.getMessage());
        }
    }
}
