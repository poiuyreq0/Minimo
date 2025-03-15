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
@Setter
public class UserInfoDto {
    private String name;
    private Mbti mbti;
    private Gender gender;
    private LocalDateTime birthday;

    public UserInfo toUserInfo() {
        return UserInfo.builder()
                .name(name)
                .mbti(mbti)
                .gender(gender)
                .birthday(birthday)
                .build();
    }
}
