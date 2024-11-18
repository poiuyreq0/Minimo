package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.AccountState;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

import static lombok.AccessLevel.PROTECTED;

@NoArgsConstructor(access = PROTECTED)
@Getter
@Entity
@Table(
    uniqueConstraints = {
        @UniqueConstraint(name = "uq_email", columnNames = "email"),
        @UniqueConstraint(name = "uq_nickname", columnNames = "nickname")
    }
)
public class User extends BaseTimeEntity {
    @Builder
    public User(@NonNull String email, @NonNull String nickname, UserInfo userInfo) {
        this.email = email;
        this.nickname = nickname;
        this.userInfo = userInfo;
    }

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    @OneToMany(mappedBy = "sender")
    private List<Letter> sentLetters = new ArrayList<>();
    @OneToMany(mappedBy = "receiver")
    private List<Letter> receivedLetters = new ArrayList<>();

    // User 생성 시, 초기화
    @Column(nullable = false)
    private String email;
    @Column(nullable = false)
    private String nickname;
    @Embedded
    private UserInfo userInfo;

    private Integer heartNum = 5;
    @Enumerated(EnumType.STRING)
    private AccountState accountState = AccountState.ACTIVE;
    private Integer reportedCount = 0;

    public void updateUserInfo(UserInfo userInfo) {
        this.userInfo = userInfo;
    }

    public void updateNickname(String nickname) {
        this.nickname = nickname;
    }

    public void changeHeartNum() {
        heartNum -= 1;
    }

    public void increaseReportedCount() {
        reportedCount += 1;
        if (reportedCount >= 5) {
            accountState = AccountState.BANNED;
        } else {
            accountState = AccountState.ACTIVE;
        }
    }
}
