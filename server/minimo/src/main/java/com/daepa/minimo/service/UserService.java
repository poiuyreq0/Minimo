package com.daepa.minimo.service;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.domain.ImageFile;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.exception.NicknameConflictException;
import com.daepa.minimo.exception.ImageNotFoundException;
import com.daepa.minimo.exception.UserNotFoundException;
import com.daepa.minimo.repository.LetterRepository;
import com.daepa.minimo.repository.UserRepository;
import com.daepa.minimo.util.FileUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RequiredArgsConstructor
@Service
@Transactional
public class UserService {
    private final UserRepository userRepository;
    private final LetterRepository letterRepository;

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

    public Long createUser(User user) {
        validateNicknameConflict(user.getNickname());

        userRepository.saveUser(user);
        return user.getId();
    }

    @Transactional(readOnly = true)
    public Integer findHeartNum(Long id) {
        User findUser = userRepository.findUser(id);
        return findUser.getHeartNum();
    }

    @Transactional(readOnly = true)
    public ImageFile findImageFile(Long id) {
        User findUser = userRepository.findUser(id);
        validateImageNotNull(findUser.getImageFile());

        return findUser.getImageFile();
    }

    public Long updateImage(Long id, MultipartFile image) throws IOException {
        ImageFile imageFile = FileUtil.saveImage(image);
        User findUser = userRepository.findUser(id);
        findUser.updateImage(imageFile);
        return findUser.getId();
    }

    public UserInfo updateUserInfo(Long id, UserInfo userInfo) {
        User findUser = userRepository.findUser(id);
        findUser.updateUserInfo(userInfo);
        return findUser.getUserInfo();
    }

    public User updateNickname(Long id, String nickname) {
        User findUser = userRepository.findUser(id);
        validateNicknameConflict(nickname);

        findUser.updateNickname(nickname);
        return findUser;
    }

    public Long deleteUser(Long id) {
        User findUser = userRepository.findUser(id);

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
        return findUser.getId();
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

    private void validateImageNotNull(ImageFile imageFile) {
        if (imageFile == null) {
            throw new ImageNotFoundException();
        }
    }
}
