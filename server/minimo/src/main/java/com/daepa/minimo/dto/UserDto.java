package com.daepa.minimo.dto;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.domain.User;
import lombok.*;

@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Builder
public class UserDto {
    private Long id;
    private String email;
    private String nickname;
    private UserInfo userInfo;
    private Integer heartNum;

    public static UserDto fromUser(@NonNull User user) {
        return UserDto.builder()
                .id(user.getId())
                .email(user.getEmail())
                .nickname(user.getNickname())
                .userInfo(user.getUserInfo())
                .heartNum((user.getHeartNum()))
                .build();
    }

    public User toUser() {
        return User.builder()
                .email(email)
                .nickname(nickname)
                .userInfo(userInfo)
                .build();
    }
}
