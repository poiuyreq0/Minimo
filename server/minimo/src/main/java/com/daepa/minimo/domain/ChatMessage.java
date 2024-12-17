package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import jakarta.persistence.*;
import lombok.*;

import static lombok.AccessLevel.PROTECTED;

@AllArgsConstructor
@NoArgsConstructor(access = PROTECTED)
@Builder
@Getter
@Entity
public class ChatMessage extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chat_message_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chat_room_id")
    private ChatRoom chatRoom;

    @Column(nullable = false)
    private Long senderId;
    @Column(nullable = false)
    private String content;
    @Column(nullable = false)
    private Boolean isRead = false;

    public void updateChatRoom(@NonNull ChatRoom chatRoom) {
        this.chatRoom = chatRoom;
        chatRoom.getMessages().add(this);
    }

    public void updateIsRead() {
        isRead = true;
    }
}
