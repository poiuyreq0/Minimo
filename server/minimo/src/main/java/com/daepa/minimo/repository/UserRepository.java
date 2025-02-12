package com.daepa.minimo.repository;

import com.daepa.minimo.common.enums.AccountRole;
import com.daepa.minimo.common.enums.ReportReason;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.domain.UserBanRecord;
import com.daepa.minimo.domain.UserReportRecord;
import com.daepa.minimo.dto.UserBanRecordDto;
import com.daepa.minimo.dto.UserDto;
import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.daepa.minimo.domain.QUser.user;
import static com.daepa.minimo.domain.QUserBanRecord.userBanRecord;
import static com.daepa.minimo.domain.QUserReportRecord.userReportRecord;

@RequiredArgsConstructor
@Repository
public class UserRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void saveUser(User user) {
        em.persist(user);
    }

    public void saveUserBanRecord(UserBanRecord userBanRecord) {
        em.persist(userBanRecord);
    }

    public void saveUserReportRecord(UserReportRecord userReportRecord) {
        em.persist(userReportRecord);
    }

    public User findUser(Long userId) {
        return em.find(User.class, userId);
    }

    public UserDto getUserByEmail(String email) {
        UserDto userDto = queryFactory
                .select(Projections.fields(
                        UserDto.class,
                        user.id,
                        user.profileImage.isNotNull().as("isProfileImageSet"),
                        user.email,
                        user.nickname,
                        user.userInfo,
                        user.netNum,
                        user.bottleNum,
                        user.accountRole
                ))
                .from(user)
                .where(user.email.eq(email))
                .fetchOne();

        if (userDto != null) {
            userDto.setUserBanRecordMap(getUserBanRecordMap(userDto.getId()));
        }

        return userDto;
    }

    public Map<Long, UserBanRecordDto> getUserBanRecordMap(Long userId) {
        List<UserBanRecordDto> userBanRecordDtoList = queryFactory
                .select(Projections.fields(
                        UserBanRecordDto.class,
                        userBanRecord.id,
                        userBanRecord.targetId,
                        userBanRecord.targetNickname,
                        userBanRecord.createdDate
                ))
                .from(userBanRecord)
                .where(userBanRecord.user.id.eq(userId))
                .fetch();

        Map<Long, UserBanRecordDto> userBanRecordDtoMap = new HashMap<>();
        for (UserBanRecordDto userBanRecordDto: userBanRecordDtoList) {
            userBanRecordDtoMap.put(userBanRecordDto.getTargetId(), userBanRecordDto);
        }

        return userBanRecordDtoMap;
    }

    public void unbanUser(Long userId, Long targetId) {
        queryFactory
                .delete(userBanRecord)
                .where(userBanRecord.user.id.eq(userId)
                        .and(userBanRecord.targetId.eq(targetId)))
                .execute();
    }

    public List<UserReportRecord> getUserReportRecord(Long targetId, ReportReason reportReason) {
        return queryFactory
                .selectFrom(userReportRecord)
                .where(userReportRecord.target.id.eq(targetId)
                        .and(userReportRecord.reportReason.eq(reportReason)))
                .fetch();
    }

    public User getUserByNickname(String nickname) {
        return queryFactory
                .selectFrom(user)
                .where(user.nickname.eq(nickname))
                .fetchOne();
    }

    public void deleteUser(User user) {
        em.remove(user);
    }

    public void reinstateAccountRole(LocalDateTime currentDate) {
        queryFactory
                .update(user)
                .set(user.accountRole, AccountRole.USER)
                .where(user.suspendedDate.lt(currentDate.minusDays(30)))
                .execute();
    }
}
