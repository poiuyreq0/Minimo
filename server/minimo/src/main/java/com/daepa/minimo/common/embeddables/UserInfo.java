package com.daepa.minimo.common.embeddables;

import com.daepa.minimo.common.enums.Gender;
import com.daepa.minimo.common.enums.Mbti;
import jakarta.persistence.Embeddable;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Objects;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
@Embeddable
public class UserInfo {
    private String name;

    @Enumerated(EnumType.STRING)
    private Mbti mbti;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    private LocalDateTime birthday;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserInfo that = (UserInfo) o;
        return Objects.equals(name, that.name) && mbti == that.mbti && gender == that.gender && Objects.equals(birthday, that.birthday);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, mbti, gender, birthday);
    }
}
