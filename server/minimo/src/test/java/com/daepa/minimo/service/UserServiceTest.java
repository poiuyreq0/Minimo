package com.daepa.minimo.service;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.Gender;
import com.daepa.minimo.common.enums.Mbti;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.exception.NicknameConflictException;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
class UserServiceTest {
    @Autowired UserService userService;

    @Test
    public void join() throws Exception {
        // given
        UserInfo userInfo = UserInfo.builder()
                .name("ㅎㄱㄷ")
                .mbti(Mbti.ENFJ)
                .gender(Gender.MALE)
                .birthday(LocalDateTime.now())
                .build();
        User user = User.builder()
                .email("asdf@gmail.com")
                .nickname("")
                .userInfo(userInfo)
                .build();

        // when
        Long savedId = userService.createUser(user);

        // then
        assertEquals(user, userService.findUser(savedId));
    }

    @Test
    public void validateDuplicateNickname() throws Exception {
        // given
        UserInfo userInfo1 = UserInfo.builder()
                .name("ㅎㄱㄷ")
                .mbti(Mbti.ENFJ)
                .gender(Gender.MALE)
                .birthday(LocalDateTime.now())
                .build();
        User user1 = User.builder()
                .email("asdf@gmail.com")
                .nickname("asdf")
                .userInfo(userInfo1)
                .build();

        UserInfo userInfo2 = UserInfo.builder()
                .name("ㅎㄱㄷ")
                .mbti(Mbti.ENFJ)
                .gender(Gender.MALE)
                .birthday(LocalDateTime.now())
                .build();
        User user2 = User.builder()
                .email("asdf@gmail.com")
                .nickname("asdf")
                .userInfo(userInfo2)
                .build();

        // when // then
        userService.createUser(user1);
        Exception e = assertThrows(NicknameConflictException.class, () -> {
            userService.createUser(user2);
        });

        assertEquals("이미 존재하는 닉네임입니다.", e.getMessage());
    }
}