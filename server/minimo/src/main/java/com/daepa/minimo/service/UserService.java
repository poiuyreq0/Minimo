package com.daepa.minimo.service;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.Item;
import com.daepa.minimo.common.enums.ReportReason;
import com.daepa.minimo.domain.*;
import com.daepa.minimo.dto.UserBanRecordDto;
import com.daepa.minimo.dto.UserDto;
import com.daepa.minimo.exception.NicknameConflictException;
import com.daepa.minimo.exception.ReportConflictException;
import com.daepa.minimo.repository.ChatRepository;
import com.daepa.minimo.repository.LetterRepository;
import com.daepa.minimo.repository.UserRepository;
import com.daepa.minimo.repository.FileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@Service
@Transactional
public class UserService {
    private final UserRepository userRepository;
    private final LetterRepository letterRepository;
    private final ChatRepository chatRepository;
    private final FileRepository fileRepository;

    @Transactional(readOnly = true)
    public User findUser(Long userId) {
        return userRepository.findUser(userId);
    }

    @Transactional(readOnly = true)
    public UserDto getUserByEmail(String email) {
        return userRepository.getUserByEmail(email);
    }

    public Long createUser(User user) {
        validateNicknameConflict(user.getNickname());

        userRepository.saveUser(user);
        return user.getId();
    }

    @Transactional(readOnly = true)
    public Integer getItemNum(Long userId, Item item) {
        return userRepository.getItemNum(userId, item);
    }

    public Integer addItemNum(Long userId, Item item, Integer amount) {
        userRepository.addItemNum(userId, item, amount);
        return userRepository.getItemNum(userId, item);
    }

    @Transactional(readOnly = true)
    public String getImageFilePath(Long userId) {
        ImageFile image = userRepository.getImage(userId);

        return fileRepository.getUserImagePath(image);
    }

    public void updateImage(Long userId, MultipartFile image) throws IOException {
        User findUser = userRepository.findUser(userId);
        ImageFile previousImage = findUser.getProfileImage();

        ImageFile savedImage = fileRepository.saveUserImage(image);
        findUser.updateImage(savedImage);

        fileRepository.deleteUserImage(previousImage);
    }

    public void updateUserInfo(Long userId, UserInfo userInfo) {
        userRepository.updateUserInfo(userId, userInfo);
    }

    public void updateNickname(Long userId, String nickname) {
        validateNicknameConflict(nickname);

        userRepository.updateNickname(userId, nickname);
    }

    public void updateFcmToken(Long userId, FcmToken fcmToken) {
        User findUser = userRepository.findUser(userId);
        findUser.updateFcmToken(fcmToken);
    }

    public void deleteFcmToken(Long userId) {
        User findUser = userRepository.findUser(userId);
        findUser.updateFcmToken(null);
    }

    public Map<Long, UserBanRecordDto> banUser(Long userId, Long targetId, String targetNickname) {
        User findUser = userRepository.findUser(userId);

        userRepository.saveUserBanRecord(UserBanRecord.builder()
                        .targetId(targetId)
                        .targetNickname(targetNickname)
                        .user(findUser)
                        .build());

        return userRepository.getUserBanRecordMap(userId);
    }

    public Map<Long, UserBanRecordDto> unbanUser(Long userId, Long targetId) {
        userRepository.unbanUser(userId, targetId);

        return userRepository.getUserBanRecordMap(userId);
    }

    public void reportUser(Long userId, Long targetId, ReportReason reportReason) {
        List<UserReportRecord> userReportRecordList = userRepository.getUserReportRecord(targetId, reportReason);
        validateReportConflict(userId, userReportRecordList);

        User findUser = userRepository.findUser(targetId);
        UserReportRecord userReportRecord = UserReportRecord.builder()
                        .target(findUser)
                        .reporterId(userId)
                        .reportReason(reportReason)
                        .build();
        userRepository.saveUserReportRecord(userReportRecord);

        // 정지 기준
        if (userReportRecordList.size() + 1 >= 3) {
            findUser.suspendAccount(userReportRecord.getCreatedDate());
        }
    }

    public void deleteUser(Long userId) throws IOException {
        ImageFile previousImage = userRepository.getImage(userId);

        userRepository.deleteUserWithRelations(userId);

        fileRepository.deleteUserImage(previousImage);
    }

    private void validateNicknameConflict(String nickname) {
        User findUser = userRepository.getUserByNickname(nickname);
        if (findUser != null) {
            throw new NicknameConflictException();
        }
    }

    private void validateReportConflict(Long userId, List<UserReportRecord> userReportRecords) {
        for (UserReportRecord userReportRecord: userReportRecords) {
            if (userReportRecord.getReporterId().equals(userId)) {
                throw new ReportConflictException();
            }
        }
    }
}
