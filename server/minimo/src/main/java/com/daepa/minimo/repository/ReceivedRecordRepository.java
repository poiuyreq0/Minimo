package com.daepa.minimo.repository;

import com.daepa.minimo.domain.ReceivedRecord;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@RequiredArgsConstructor
@Repository
public class ReceivedRecordRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void saveReceivedRecord(ReceivedRecord receivedRecord) {
        em.persist(receivedRecord);
    }
}
