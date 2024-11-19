package com.daepa.minimo.service;

import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.common.enums.UserRole;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.domain.ReceivedRecord;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.dto.LetterDto;
import com.daepa.minimo.dto.LetterElementDto;
import com.daepa.minimo.exception.LetterUndeletableException;
import com.daepa.minimo.exception.LetterNotFoundException;
import com.daepa.minimo.exception.UserInvalidException;
import com.daepa.minimo.exception.UserNotFoundException;
import com.daepa.minimo.repository.LetterRepository;
import com.daepa.minimo.repository.ReceivedRecordRepository;
import com.daepa.minimo.repository.UserRepository;
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

    public Long sendLetter(Long senderId, Letter letter) {
        User sender = userRepository.findUser(senderId);
        validateUserNotNull(sender);

        letter.changeSender(sender);
        letterRepository.saveLetter(letter);
        return letter.getId();
    }

    @Transactional(readOnly = true)
    public Letter findLetter(Long id) {
        return letterRepository.findLetter(id);
    }

    @Transactional(readOnly = true)
    public List<LetterElementDto> findLettersByOption(Long userId, LetterOption letterOption, Integer count) {
        User user = userRepository.findUser(userId);
        validateUserNotNull(user);

        return letterRepository.findLettersByOption(user, letterOption, count);
    }

    public Letter receiveLetter(Long receiverId, LetterOption letterOption) {
        User receiver = userRepository.findUser(receiverId);
        validateUserNotNull(receiver);

        Letter findLetter = letterRepository.findLetterByOption(receiver, letterOption);
        validateLetterNotNull(findLetter);
        System.out.println("findLetter: " + findLetter.getUserInfo());

        findLetter.changeReceiver(receiver);
        receivedRecordRepository.saveReceivedRecord(ReceivedRecord.builder()
                        .letter(findLetter)
                        .receiverId(receiver.getId())
                        .build());
        return findLetter;
    }

    public Long sinkLetter(Long id, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(id);
        validateLetterNotNull(findLetter);
        validateLetterDeletableState(findLetter.getLetterState());
        validateLetterOwner(findLetter, userId, userRole);

        letterRepository.deleteLetter(findLetter);
        return findLetter.getId();
    }

    public Long returnLetter(Long id, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(id);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);

        findLetter.returnLetter();
        validateOwnerlessAndDeleteLetter(findLetter);
        return findLetter.getId();
    }

    public Long connectLetter(Long id, Long userId, UserRole userRole) {
        Letter findLetter = letterRepository.findLetter(id);
        validateLetterNotNull(findLetter);
        validateLetterOwner(findLetter, userId, userRole);

        findLetter.connectLetter();
        
        // 채팅방 생성 로직
        // 편지에 연결된 유저가 모두 있는지 점검
        
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
        validateOwnerlessAndDeleteLetter(findLetter);
        return findLetter.getId();
    }

    @Transactional(readOnly = true)
    public List<LetterDto> findLetters(Long userId, UserRole userRole, LetterState letterState) {
        return letterRepository.findLettersByUser(userId, userRole, letterState);
    }

    private void validateUserNotNull(User user) {
        if (user == null) {
            throw new UserNotFoundException();
        }
    }

    private void validateLetterNotNull(Letter letter) {
        if (letter == null) {
            throw new LetterNotFoundException();
        }
    }

    private void validateLetterDeletableState(LetterState letterState) {
        if (letterState != LetterState.SENT) {
            throw new LetterUndeletableException();
        }
    }

    private void validateLetterOwner(Letter letter, Long userId, UserRole userRole) {
        Long ownerId = (userRole == UserRole.SENDER) ? letter.getSender().getId() : letter.getReceiver().getId();
        if (!ownerId.equals(userId)) {
            throw new UserInvalidException();
        }
    }

    private void validateOwnerlessAndDeleteLetter(Letter letter) {
        if (letter.getSender() == null && letter.getReceiver() == null) {
            letterRepository.deleteLetter(letter);
        }
    }
}
