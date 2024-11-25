package com.daepa.minimo.service;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.exception.NicknameConflictException;
import com.daepa.minimo.exception.UserNotFoundException;
import com.daepa.minimo.repository.LetterRepository;
import com.daepa.minimo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
@Transactional
public class UserService {
    private final UserRepository userRepository;
    private final LetterRepository letterRepository;

    public Long createUser(User user) {
        validateNicknameConflict(user.getNickname());

        userRepository.saveUser(user);
        return user.getId();
    }

    @Transactional(readOnly = true)
    public User findUser(Long id) {
        User findUser = userRepository.findUser(id);
        validateUserNotNull(findUser);

        return findUser;
    }

    @Transactional(readOnly = true)
    public User findUserByEmail(String email) {
        User findUser = userRepository.findUserByEmail(email);
        validateUserNotNull(findUser);

        return findUser;
    }

    @Transactional(readOnly = true)
    public Integer findHeartNum(Long id) {
        User findUser = userRepository.findUser(id);
        validateUserNotNull(findUser);

        return findUser.getHeartNum();
    }

    public UserInfo updateUserInfo(Long id, UserInfo userInfo) {
        User findUser = userRepository.findUser(id);
        validateUserNotNull(findUser);

        findUser.updateUserInfo(userInfo);
        return findUser.getUserInfo();
    }

    public User updateNickname(Long id, String nickname) {
        User findUser = userRepository.findUser(id);
        validateUserNotNull(findUser);
        validateNicknameConflict(nickname);

        findUser.updateNickname(nickname);
        return findUser;
    }

    public void deleteUser(Long id) {
        User findUser = userRepository.findUser(id);
        validateUserNotNull(findUser);

        for (Letter letter: findUser.getSentLetters()) {
            letter.removeSender();
            if (letter.getReceiver() == null) {
                letterRepository.deleteLetter(letter);
            }
        }
        for (Letter letter: findUser.getReceivedLetters()) {
            letter.removeReceiver();
            if(letter.getSender() == null) {
                letterRepository.deleteLetter(letter);
            }
        }

        userRepository.deleteUser(findUser);
    }

    private void validateNicknameConflict(String nickname) {
        User findUser = userRepository.findUserByNickname(nickname);
        if (findUser != null) {
            throw new NicknameConflictException();
        }
    }

    private void validateUserNotNull(User user) {
        if (user == null) {
            throw new UserNotFoundException();
        }
    }
}
