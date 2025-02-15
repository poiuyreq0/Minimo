package com.daepa.minimo.service;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.common.enums.UserRole;
import com.daepa.minimo.domain.*;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.domain.LetterReceiveRecord;
import com.daepa.minimo.dto.LetterDto;
import com.daepa.minimo.dto.SimpleLetterDto;
import com.daepa.minimo.exception.*;
import com.daepa.minimo.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@Service
@Transactional
public class LetterService {
    private final LetterRepository letterRepository;
    private final UserRepository userRepository;
    private final ChatRepository chatRepository;
    private final ChatService chatService;

    public Long sendLetter(Long senderId, Letter letter) {
        User sender = userRepository.findUser(senderId);
        letter.updateSender(sender);
        letterRepository.saveLetter(letter);
        return letter.getId();
    }

    @Transactional(readOnly = true)
    public Map<LetterOption, List<SimpleLetterDto>> getSimpleLetters(Long userId, Integer count) {
        UserInfo userInfo = userRepository.getUserInfo(userId);
        return letterRepository.getSimpleLetters(userId, userInfo, count);
    }

    public Letter receiveLetter(Long receiverId, LetterOption letterOption) {
        User receiver = userRepository.findUser(receiverId);
        Letter findLetter = letterRepository.getLetterByOption(receiverId, receiver.getUserInfo(), letterOption);
        validateLetterNotNull(findLetter);

        findLetter.updateReceiver(receiver);
        letterRepository.saveLetterReceiveRecord(LetterReceiveRecord.builder()
                        .letter(findLetter)
                        .receiverId(receiver.getId())
                        .build());
        return findLetter;
    }

    public void returnLetter(Long letterId, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);

        findLetter.returnLetter();
        deleteLetterIfOwnerless(findLetter);
    }

    public void disconnectLetter(Long letterId, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);

        // 편지 연결 끊기
        if (userRole == UserRole.SENDER) {
            findLetter.removeSender();
        } else {
            findLetter.removeReceiver();
        }
        deleteLetterIfOwnerless(findLetter);

        // 채팅방 나가기
        if (findLetter.getChatRoomId() != null) {
            chatService.disconnectChatRoom(findLetter.getChatRoomId(), userId);
        }
    }

    public void connectLetter(Long letterId, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);
        validateLetterOwnersNotNull(findLetter);

        // 채팅방 생성 로직
        ChatRoom chatRoom = ChatRoom.builder().build();
        chatRepository.saveChatRoom(chatRoom);

        for (User user : List.of(findLetter.getSender(), findLetter.getReceiver())) {
            ChatRoomUser chatRoomUser = ChatRoomUser.builder()
                    .chatRoom(chatRoom)
                    .user(user)
                    .build();
            chatRepository.saveChatRoomUser(chatRoomUser);
        }

        findLetter.connectLetter(chatRoom.getId());
    }

    @Transactional(readOnly = true)
    public List<LetterDto> getLettersByUserWithPaging(Long userId, UserRole userRole, LetterState letterState, Integer count, LocalDateTime lastDate) {
        return letterRepository.getLettersByUserWithPaging(userId, userRole, letterState, count, lastDate);
    }

    @Transactional(readOnly = true)
    public Letter getLetterByUser(Long letterId, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);

        return findLetter;
    }

    private void deleteLetterIfOwnerless(Letter letter) {
        if (letter.getSender() == null && letter.getReceiver() == null) {
            letterRepository.deleteLetter(letter);
        }
    }

    private void validateLetterNotNull(Letter letter) {
        if (letter == null) {
            throw new LetterNotFoundException();
        }
    }

    private void validateLetterOwner(Letter letter, Long userId, UserRole userRole) {
        if (userRole == UserRole.SENDER && letter.getSender() != null) {
            if (!letter.getSender().getId().equals(userId)) {
                throw new LetterNotFoundException();
            }
        }
        if (userRole == UserRole.RECEIVER && letter.getReceiver() != null) {
            if (!letter.getReceiver().getId().equals(userId)) {
                throw new LetterNotFoundException();
            }
        }
    }

    private void validateLetterOwnersNotNull(Letter letter) {
        if (letter.getSender() == null || letter.getReceiver() == null) {
            throw new UserNotFoundException();
        }
    }
}
