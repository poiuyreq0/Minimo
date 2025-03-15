package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import com.daepa.minimo.common.embeddables.LetterContent;
import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.Item;
import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.lang.NonNull;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@Getter
@Entity
@Table(
    indexes = {
        @Index(name = "idx_letter_state", columnList = "letter_state"),
        @Index(name = "idx_sender_id_and_letter_state_and_letter_option", columnList = "sender_id, letter_state, letter_option"),
        @Index(name = "idx_created_date", columnList = "created_date"),
        @Index(name = "idx_received_date", columnList = "received_date"),
        @Index(name = "idx_connected_date", columnList = "connected_date")
    }
)
public class Letter extends BaseTimeEntity {
    @Builder
    public Letter(@NonNull LetterContent letterContent, @NonNull LetterOption letterOption, @NonNull UserInfo userInfo) {
        this.letterContent = letterContent;
        this.letterOption = letterOption;
        this.userInfo = userInfo;
    }

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "letter_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id")
    private User sender;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "receiver_id")
    private User receiver;
    @OneToMany(mappedBy = "letter", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LetterReceiveRecord> letterReceiveRecordList = new ArrayList<>();

    @Embedded
    private LetterContent letterContent;
    @Enumerated(EnumType.STRING)
    private LetterOption letterOption = LetterOption.NONE;
    @Embedded
    private UserInfo userInfo;

    private Long chatRoomId;
    @Enumerated(EnumType.STRING)
    private LetterState letterState = LetterState.NONE;
    private LocalDateTime receivedDate;
    private LocalDateTime connectedDate;

    public void updateSender(@NonNull User sender) {
        this.sender = sender;
        sender.getSentLetters().add(this);
        sender.decreaseItemNum(Item.BOTTLE);

        letterState = LetterState.SENT;
    }

    public void updateReceiver(@NonNull User receiver) {
        this.receiver = receiver;
        receiver.getReceivedLetters().add(this);
        receiver.decreaseItemNum(Item.NET);

        receivedDate = LocalDateTime.now();
        letterState = LetterState.RECEIVED;
    }

    public void returnLetter() {
        receiver = null;
        receivedDate = null;
        letterState = LetterState.SENT;
    }

    public void connectLetter(Long chatRoomId) {
        connectedDate = LocalDateTime.now();
        letterState = LetterState.CONNECTED;
        this.chatRoomId = chatRoomId;
    }

    public void removeSender() {
        sender = null;
    }

    public void removeReceiver() {
        receiver = null;
    }
}
