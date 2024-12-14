package com.daepa.minimo.service;

import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.common.enums.UserRole;
import com.daepa.minimo.domain.*;
import com.daepa.minimo.dto.LetterDto;
import com.daepa.minimo.dto.LetterElementDto;
import com.daepa.minimo.exception.*;
import com.daepa.minimo.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@RequiredArgsConstructor
@Service
@Transactional
public class LetterService {
    private final LetterRepository letterRepository;
    private final UserRepository userRepository;
    private final ReceivedRecordRepository receivedRecordRepository;
    private final ChatRepository chatRepository;

    @Transactional(readOnly = true)
    public Letter findLetter(Long id) {
        return letterRepository.findLetter(id);
    }

    public Long sendLetter(Long senderId, Letter letter) {
        User sender = userRepository.findUser(senderId);
        letter.updateSender(sender);
        letterRepository.saveLetter(letter);
        return letter.getId();
    }

    @Transactional(readOnly = true)
    public List<LetterElementDto> findNewLettersByOption(Long userId, LetterOption letterOption, Integer count) {
        User user = userRepository.findUser(userId);
        return letterRepository.findNewLettersByOption(user, letterOption, count);
    }

    public Letter receiveLetter(Long receiverId, LetterOption letterOption) {
        User receiver = userRepository.findUser(receiverId);
        Letter findLetter = letterRepository.findNewLetterByOption(receiver, letterOption);
        validateLetterNotNull(findLetter);

        findLetter.updateReceiver(receiver);
        receivedRecordRepository.saveReceivedRecord(ReceivedRecord.builder()
                        .letter(findLetter)
                        .receiverId(receiver.getId())
                        .build());
        return findLetter;
    }

    public Long sinkLetter(Long id, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(id);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);

        letterRepository.deleteLetter(findLetter);
        return findLetter.getId();
    }

    public Long returnLetter(Long id, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(id);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);

        findLetter.returnLetter();
        deleteLetterIfOwnerless(findLetter);

        return findLetter.getId();
    }

    public Long disconnectLetter(Long id, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(id);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);

        if (userRole == UserRole.SENDER) {
            findLetter.removeSender();
        } else {
            findLetter.removeReceiver();
        }
        deleteLetterIfOwnerless(findLetter);

        return findLetter.getId();
    }

    public Letter connectLetter(Long id, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(id);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);
        validateOtherOwnerNotNull(findLetter);

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

        return findLetter;
    }

    @Transactional(readOnly = true)
    public List<LetterDto> findLettersByUser(Long userId, UserRole userRole, LetterState letterState) {
        return letterRepository.findLettersByUser(userId, userRole, letterState);
    }

    private void validateLetterNotNull(Letter letter) {
        if (letter == null) {
            throw new LetterNotFoundException();
        }
    }

    private void validateLetterOwner(Letter letter, Long userId, UserRole userRole) {
        Long ownerId = (userRole == UserRole.SENDER) ? letter.getSender().getId() : letter.getReceiver().getId();
        if (!ownerId.equals(userId)) {
            throw new UserInvalidException();
        }
    }

    private void deleteLetterIfOwnerless(Letter letter) {
        if (letter.getSender() == null && letter.getReceiver() == null) {
            letterRepository.deleteLetter(letter);
        }
    }

    private void validateOtherOwnerNotNull(Letter letter) {
        if (letter.getSender() == null || letter.getReceiver() == null) {
            throw new UserNotFoundException();
        }
    }
}
