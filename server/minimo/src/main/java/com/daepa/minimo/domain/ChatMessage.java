package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor
@Getter
@Entity
@Table(
    indexes = {
        @Index(name = "idx_created_date", columnList = "created_date")
    }
)
public class ChatMessage extends BaseTimeEntity {
    @Builder
    public ChatMessage(@NonNull Long senderId, @NonNull String content) {
        this.senderId = senderId;
        this.content = content;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chat_message_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chat_room_id")
    private ChatRoom chatRoom;

    private Long senderId;
    @Lob
    private String content;

    private Boolean isRead = false;

    public void updateChatRoom(@NonNull ChatRoom chatRoom) {
        this.chatRoom = chatRoom;
        chatRoom.getMessages().add(this);
    }
}
