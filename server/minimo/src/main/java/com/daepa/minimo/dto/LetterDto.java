package com.daepa.minimo.dto;

import com.daepa.minimo.common.embeddables.LetterContent;
import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.domain.Letter;
import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class LetterDto {
    private Long id;
    private Long senderId;
    private String senderNickname;
    private Long receiverId;
    private String receiverNickname;
    private LetterContent letterContent;
    private LetterOption letterOption;
    private UserInfo userInfo;
    private Long chatRoomId;
    private LetterState letterState;
    private LocalDateTime createdDate;
    private LocalDateTime receivedDate;
    private LocalDateTime connectedDate;

    public static LetterDto fromLetter(@NonNull Letter letter) {
        return LetterDto.builder()
                .id(letter.getId())
                .senderId(letter.getSender() != null ? letter.getSender().getId() : null)
                .senderNickname(letter.getSender() != null ? letter.getSender().getNickname() : null)
                .receiverId(letter.getReceiver() != null ? letter.getReceiver().getId() : null)
                .receiverNickname(letter.getReceiver() != null ? letter.getReceiver().getNickname() : null)
                .letterContent(letter.getLetterContent())
                .letterOption(letter.getLetterOption())
                .userInfo(letter.getUserInfo())
                .chatRoomId(letter.getChatRoomId())
                .letterState(letter.getLetterState())
                .createdDate(letter.getCreatedDate())
                .receivedDate(letter.getReceivedDate())
                .connectedDate(letter.getConnectedDate())
                .build();
    }

    public Letter toLetter() {
        return Letter.builder()
                .letterContent(letterContent)
                .letterOption(letterOption)
                .userInfo(userInfo)
                .build();
    }
}
