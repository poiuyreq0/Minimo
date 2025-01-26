package com.daepa.minimo.dto;

import com.daepa.minimo.domain.FcmToken;
import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
public class FcmTokenDto {
    private String token;

    public FcmToken toFcmToken() {
        return FcmToken.builder()
                .token(token)
                .build();
    }
}
