package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import jakarta.persistence.*;
import lombok.*;

@NoArgsConstructor
@Getter
@Entity
public class FcmToken extends BaseTimeEntity {
    @Builder
    public FcmToken(@NonNull String token) {
        this.token = token;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fcm_token_id")
    private Long id;

    @OneToOne(mappedBy = "fcmToken")
    private User user;

    @Column(nullable = false)
    private String token;

    public void updateUser(User user) {
        this.user = user;
    }
}
