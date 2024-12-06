package com.daepa.minimo.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

import static lombok.AccessLevel.PROTECTED;

@AllArgsConstructor
@NoArgsConstructor(access = PROTECTED)
@Getter
@Entity
@Builder
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chat_message_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chat_room_id")
    private ChatRoom chatRoom;

    private Long senderId;
    private String content;
    private LocalDateTime timeStamp;

    public void changeChatRoom(@NonNull ChatRoom chatRoom) {
        this.chatRoom = chatRoom;
        chatRoom.getMessages().add(this);
    }
}
