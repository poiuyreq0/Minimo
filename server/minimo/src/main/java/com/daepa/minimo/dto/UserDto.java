package com.daepa.minimo.dto;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.AccountRole;
import com.daepa.minimo.domain.User;
import lombok.*;

import java.util.HashMap;
import java.util.Map;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class UserDto {
    private Long id;
    private String email;
    private String nickname;
    private UserInfo userInfo;
    private Integer netNum;
    private Integer bottleNum;
    private Boolean isProfileImageSet;
    private AccountRole accountRole;
    @Builder.Default
    private Map<Long, UserBanRecordDto> userBanRecordMap = new HashMap<>();

    public User toUser() {
        return User.builder()
                .email(email)
                .nickname(nickname)
                .userInfo(userInfo)
                .build();
    }
}
