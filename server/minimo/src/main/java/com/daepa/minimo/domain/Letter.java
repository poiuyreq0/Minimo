package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import com.daepa.minimo.common.embeddables.LetterContent;
import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.lang.NonNull;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import static lombok.AccessLevel.PROTECTED;

@NoArgsConstructor(access = PROTECTED)
@Getter
@Entity
@Table(
        indexes = {
            @Index(name = "idx_created_date", columnList = "created_date"),
            @Index(name = "idx_received_date", columnList = "received_date"),
            @Index(name = "idx_connected_date", columnList = "connected_date"),
            @Index(name = "idx_sender_id_and_letter_state", columnList = "sender_id, letter_state"),
            @Index(name = "idx_receiver_id_and_letter_state", columnList = "receiver_id, letter_state"),
            @Index(name = "idx_letter_option_and_letter_state", columnList = "letter_option, letter_state")
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
    private List<ReceivedRecord> receivedRecordList = new ArrayList<>();

    // Letter 생성 시, 초기화
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

        letterState = LetterState.SENT;
    }

    public void updateReceiver(@NonNull User receiver) {
        this.receiver = receiver;
        receiver.getReceivedLetters().add(this);
        receiver.updateHeartNum();

        receivedDate = LocalDateTime.now();
        letterState = LetterState.LOCKED;
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
