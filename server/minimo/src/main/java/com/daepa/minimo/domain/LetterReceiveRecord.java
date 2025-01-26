package com.daepa.minimo.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Entity
public class LetterReceiveRecord {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "letter_received_record_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "letter_id")
    private Letter letter;

    private Long receiverId;
}
