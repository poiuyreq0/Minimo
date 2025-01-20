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
    private final ChatRepository chatRepository;

    @Transactional(readOnly = true)
    public Letter findLetter(Long letterId) {
        return letterRepository.findLetter(letterId);
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
        letterRepository.saveReceivedRecord(ReceivedRecord.builder()
                        .letter(findLetter)
                        .receiverId(receiver.getId())
                        .build());
        return findLetter;
    }

    public void sinkLetter(Long letterId) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateLetterNotNull(findLetter);

        letterRepository.deleteLetter(findLetter);
    }

    public void returnLetter(Long letterId) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateLetterNotNull(findLetter);

        findLetter.returnLetter();
        deleteLetterIfOwnerless(findLetter);
    }

    public void disconnectLetter(Long letterId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateLetterNotNull(findLetter);

        if (userRole == UserRole.SENDER) {
            findLetter.removeSender();
        } else {
            findLetter.removeReceiver();
        }
        deleteLetterIfOwnerless(findLetter);
    }

    public Letter connectLetter(Long letterId) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateOwnersNotNull(findLetter);

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

    @Transactional(readOnly = true)
    public Letter findLetterByUser(Long letterId) {
        Letter findLetter = letterRepository.findLetter(letterId);
        validateLetterNotNull(findLetter);

        return findLetter;
    }

    private void validateLetterNotNull(Letter letter) {
        if (letter == null) {
            throw new LetterNotFoundException();
        }
    }

    private void deleteLetterIfOwnerless(Letter letter) {
        if (letter.getSender() == null && letter.getReceiver() == null) {
            letterRepository.deleteLetter(letter);
        }
    }

    private void validateOwnersNotNull(Letter letter) {
        if (letter.getSender() == null || letter.getReceiver() == null) {
            throw new UserNotFoundException();
        }
    }
}
