package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.AccountRole;
import com.daepa.minimo.common.enums.Item;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
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
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserBanRecord> userBanRecordList = new ArrayList<>();
    @OneToMany(mappedBy = "target", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserReportRecord> userReportRecordList = new ArrayList<>();

    @Column(nullable = false)
    private String email;
    @Column(nullable = false)
    private String nickname;
    @Embedded
    private UserInfo userInfo;

    private Integer netNum = 5;
    private Integer bottleNum = 5;

    @Enumerated(EnumType.STRING)
    private AccountRole accountRole = AccountRole.USER;
    private LocalDateTime suspendedDate;

    public void updateImage(ImageFile image) {
        this.profileImage = image;
    }

    public void updateFcmToken(FcmToken fcmToken) {
        this.fcmToken = fcmToken;
    }

    public void decreaseItemNum(Item item) {
        if (item == Item.NET) {
            netNum -= 1;
        } else if (item == Item.BOTTLE) {
            bottleNum -= 1;
        }
    }

    public void suspendAccount(LocalDateTime suspendedDate) {
        accountRole = AccountRole.GHOST;
        this.suspendedDate = suspendedDate;
    }
}
