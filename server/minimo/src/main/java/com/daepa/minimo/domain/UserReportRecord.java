package com.daepa.minimo.domain;

import com.daepa.minimo.common.BaseTimeEntity;
import com.daepa.minimo.common.enums.ReportReason;
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
public class UserReportRecord extends BaseTimeEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_report_record_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_id")
    private User target;

    private Long reporterId;

    @Enumerated(EnumType.STRING)
    private ReportReason reportReason;
}
