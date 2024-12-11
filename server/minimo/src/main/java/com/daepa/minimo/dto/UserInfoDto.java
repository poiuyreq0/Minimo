package com.daepa.minimo.dto;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.Gender;
import com.daepa.minimo.common.enums.Mbti;
import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class UserInfoDto {
    private String name;
    private Mbti mbti;
    private Gender gender;
    private LocalDateTime birthday;

    public static UserInfoDto fromUserInfo(@NonNull UserInfo userInfo) {
        return UserInfoDto.builder()
                .name(userInfo.getName())
                .mbti(userInfo.getMbti())
                .gender(userInfo.getGender())
                .birthday(userInfo.getBirthday())
                .build();
    }

    public UserInfo toUserInfo() {
        return UserInfo.builder()
                .name(name)
                .mbti(mbti)
                .gender(gender)
                .birthday(birthday)
                .build();
    }
}
