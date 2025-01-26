package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.AccountState;
import com.daepa.minimo.common.enums.Item;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;



@NoArgsConstructor
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
    public User(@NonNull String email, @NonNull String nickname, @NonNull UserInfo userInfo) {
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
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChatRoomUser> chatRoomUserList = new ArrayList<>();
    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "profile_image_id")
    private ImageFile profileImage;
    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "fcm_token_id")
    private FcmToken fcmToken;

    @Column(nullable = false)
    private String email;
    @Column(nullable = false)
    private String nickname;
    @Embedded
    private UserInfo userInfo;

    private Integer netNum = 5;
    private Integer bottleNum = 5;
    @Enumerated(EnumType.STRING)
    private AccountState accountState = AccountState.ACTIVE;
    private Integer reportedCount = 0;

    public void updateImage(ImageFile image) {
        this.profileImage = image;
    }

    public void updateUserInfo(UserInfo userInfo) {
        this.userInfo = userInfo;
    }

    public void updateNickname(String nickname) {
        this.nickname = nickname;
    }

    public void updateFcmToken(FcmToken fcmToken) {
        this.fcmToken = fcmToken;
        fcmToken.updateUser(this);
    }

    public Integer getItemNum(Item item) {
        if (item == Item.NET) {
            return netNum;
        } else {
            return bottleNum;
        }
    }

    public void decreaseItemNum(Item item) {
        if (item == Item.NET) {
            netNum -= 1;
        } else if (item == Item.BOTTLE) {
            bottleNum -= 1;
        }
    }

    public void increaseItemNum(Item item, Integer amount) {
        if (item == Item.NET) {
            netNum += amount;
        } else if (item == Item.BOTTLE) {
            bottleNum += amount;
        }
    }

    public void updateAccountState() {
        reportedCount += 1;
        if (reportedCount >= 5) {
            accountState = AccountState.BANNED;
        } else {
            accountState = AccountState.ACTIVE;
        }
    }
}
