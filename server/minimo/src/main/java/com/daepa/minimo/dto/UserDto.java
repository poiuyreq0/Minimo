package com.daepa.minimo.dto;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.domain.User;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class UserDto {
    private Long id;
    private String email;
    private String nickname;
    private UserInfo userInfo;
    private Integer netNum;
    private Integer bottleNum;
    private Boolean isProfileImageSet;

    public static UserDto fromUser(@NonNull User user) {
        return UserDto.builder()
                .id(user.getId())
                .isProfileImageSet(user.getProfileImage() != null)
                .email(user.getEmail())
                .nickname(user.getNickname())
                .userInfo(user.getUserInfo())
                .netNum((user.getNetNum()))
                .bottleNum((user.getBottleNum()))
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
