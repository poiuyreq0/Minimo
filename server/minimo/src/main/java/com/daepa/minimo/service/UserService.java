package com.daepa.minimo.service;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.Item;
import com.daepa.minimo.domain.FcmToken;
import com.daepa.minimo.domain.ImageFile;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.exception.NicknameConflictException;
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

    @Transactional(readOnly = true)
    public User findUser(Long userId) {
        return userRepository.findUser(userId);
    }

    @Transactional(readOnly = true)
    public User findUserByEmail(String email) {
        return userRepository.findUserByEmail(email);
    }

    public Long createUser(User user) {
        validateNicknameConflict(user.getNickname());

        userRepository.saveUser(user);
        return user.getId();
    }

    @Transactional(readOnly = true)
    public Integer findItemNum(Long userId, Item item) {
        User findUser = userRepository.findUser(userId);
        return findUser.getItemNum(item);
    }

    public Integer addItemNum(Long userId, Item item, Integer amount) {
        User findUser = userRepository.findUser(userId);
        findUser.increaseItemNum(item, amount);
        return findUser.getItemNum(item);
    }

    @Transactional(readOnly = true)
    public ImageFile findImage(Long userId) {
        User findUser = userRepository.findUser(userId);
        if (findUser == null) {
            return null;
        }

        return findUser.getProfileImage();
    }

    public void updateImage(Long userId, ImageFile image) {
        User findUser = userRepository.findUser(userId);
        findUser.updateImage(image);
    }

    public void deleteImage(Long userId) {
        User findUser = userRepository.findUser(userId);
        findUser.updateImage(null);
    }

    public void updateUserInfo(Long userId, UserInfo userInfo) {
        User findUser = userRepository.findUser(userId);
        findUser.updateUserInfo(userInfo);
    }

    public void updateNickname(Long userId, String nickname) {
        validateNicknameConflict(nickname);

        User findUser = userRepository.findUser(userId);
        findUser.updateNickname(nickname);
    }

    public void updateFcmToken(Long userId, FcmToken fcmToken) {
        User findUser = userRepository.findUser(userId);
        if (findUser.getFcmToken() == null || !findUser.getFcmToken().getToken().equals(fcmToken.getToken())) {
            findUser.updateFcmToken(fcmToken);
        }
    }

    public void deleteUser(Long userId) {
        User findUser = userRepository.findUser(userId);

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
}
