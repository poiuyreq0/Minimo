package com.daepa.minimo.common.embeddables;

import jakarta.persistence.Embeddable;
import jakarta.persistence.Lob;
import lombok.*;

import java.util.Objects;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Builder
@Embeddable
public class LetterContent {
    private String title;
    @Lob
    private String content;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        LetterContent that = (LetterContent) o;
        return Objects.equals(title, that.title) && Objects.equals(content, that.content);
    }

    @Override
    public int hashCode() {
        return Objects.hash(title, content);
    }
}
