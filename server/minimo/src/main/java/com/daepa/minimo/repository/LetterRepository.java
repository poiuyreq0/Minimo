package com.daepa.minimo.repository;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.common.enums.UserRole;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.domain.LetterReceiveRecord;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.dto.LetterDto;
import com.daepa.minimo.dto.SimpleLetterDto;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.DateTimePath;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.daepa.minimo.domain.QLetter.letter;
import static com.daepa.minimo.domain.QLetterReceiveRecord.letterReceiveRecord;
import static com.daepa.minimo.domain.QUserBanRecord.userBanRecord;

@RequiredArgsConstructor
@Repository
public class LetterRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void saveLetter(Letter letter) {
        em.persist(letter);
    }

    public void saveLetterReceiveRecord(LetterReceiveRecord letterReceiveRecord) {
        em.persist(letterReceiveRecord);
    }

    public Letter findLetter(Long letterId) {
        return em.find(Letter.class, letterId);
    }

    // 새로운 편지 목록 조회
    public Map<LetterOption, List<SimpleLetterDto>> getSimpleLetters(Long userId, UserInfo userInfo, Integer count) {
        Map<LetterOption, List<SimpleLetterDto>> simpleLettersMap = new HashMap<>();

        for (LetterOption letterOption: LetterOption.values()) {
            List<SimpleLetterDto> simpleLetters = queryFactory
                    .select(Projections.fields(
                            SimpleLetterDto.class,
                            letter.id,
                            letter.sender.nickname.as("senderNickname"),
                            letter.letterContent.title,
                            letter.createdDate
                    ))
                    .from(letter)
                    .leftJoin(letter.letterReceiveRecordList, letterReceiveRecord)
                    .on(letterReceiveRecord.letter.id.eq(letter.id)
                            .and(letterReceiveRecord.receiverId.eq(userId)))
                    .leftJoin(userBanRecord)
                    .on(userBanRecord.user.id.eq(userId)
                            .and(userBanRecord.targetId.eq(letter.sender.id)))
                    .where(letter.sender.id.ne(userId)
                            .and(letter.letterState.eq(LetterState.SENT)))
                    .where(matchUserInfoByOption(userInfo, letterOption))
                    .where(letterReceiveRecord.id.isNull())
                    .where(userBanRecord.id.isNull())
                    .orderBy(letter.createdDate.desc())
                    .limit(count)
                    .fetch();

            simpleLettersMap.put(letterOption, simpleLetters);
        }

        return simpleLettersMap;
    }

    // 새로운 편지 단건 조회
    public Letter getLetterByOption(Long userId, UserInfo userInfo, LetterOption letterOption) {
        return queryFactory
                .selectFrom(letter)
                .leftJoin(letter.letterReceiveRecordList, letterReceiveRecord)
                .on(letterReceiveRecord.letter.id.eq(letter.id)
                        .and(letterReceiveRecord.receiverId.eq(userId)))
                .leftJoin(userBanRecord)
                .on(userBanRecord.user.id.eq(userId)
                        .and(userBanRecord.targetId.eq(letter.sender.id)))
                .where(letter.sender.id.ne(userId)
                        .and(letter.letterState.eq(LetterState.SENT)))
                .where(matchUserInfoByOption(userInfo, letterOption))
                .where(letterReceiveRecord.id.isNull())
                .where(userBanRecord.id.isNull())
                .orderBy(letter.createdDate.desc())
                .fetchFirst();
    }

    // 유저 편지 목록 조회
    // 페이징: Letter createdDate, receivedDate, connectedDate
    public List<LetterDto> getLettersByUserWithPaging(Long userId, UserRole userRole, LetterState letterState, Integer count, LocalDateTime lastDate) {
        BooleanExpression condition = userRole == UserRole.SENDER ? matchSender(userId, letterState) : matchReceiver(userId, letterState);

        DateTimePath<LocalDateTime> targetDate;
        if (letterState == LetterState.CONNECTED) {
            targetDate = letter.connectedDate;
        } else if (userRole == UserRole.SENDER) {
            targetDate = letter.createdDate;
        } else {
            targetDate = letter.receivedDate;
        }

        return queryFactory
                .select(Projections.fields(
                        LetterDto.class,
                        letter.id,
                        letter.sender.id.as("senderId"),
                        letter.sender.nickname.as("senderNickname"),
                        letter.receiver.id.as("receiverId"),
                        letter.receiver.nickname.as("receiverNickname"),
                        letter.letterContent,
                        letter.letterOption,
                        letter.userInfo,
                        letter.chatRoomId,
                        letter.letterState,
                        letter.createdDate,
                        letter.receivedDate,
                        letter.connectedDate
                ))
                .from(letter)
                .leftJoin(letter.sender)
                .leftJoin(letter.receiver)
                .where(condition)
                .where(lastDate != null ? targetDate.lt(lastDate) : null)
                .orderBy(targetDate.desc())
                .limit(count)
                .fetch();
    }

    public void deleteLetter(Letter letter) {
        em.remove(letter);
    }

    // LetterScheduleService @Scheduled
    // 받은 편지 24시간 후 되돌리기
    public void returnLetters(LocalDateTime currentDate) {
        queryFactory
                .update(letter)
                .set(letter.receiver, (User) null)
                .set(letter.receivedDate, (LocalDateTime) null)
                .set(letter.letterState, LetterState.SENT)
                .where(letter.letterState.eq(LetterState.RECEIVED)
                        .and(letter.receivedDate.lt(currentDate.minusDays(1))))
                .execute();
    }

    public Letter getLetterForNotification(Long letterId) {
        return queryFactory
                .selectFrom(letter)
                .leftJoin(letter.sender).fetchJoin()
                .leftJoin(letter.receiver).fetchJoin()
                .leftJoin(letter.sender.fcmToken).fetchJoin()
                .where(letter.id.eq(letterId))
                .fetchOne();
    }

    private BooleanExpression matchUserInfoByOption(UserInfo userInfo, LetterOption letterOption) {
        BooleanExpression condition = letter.letterOption.eq(letterOption);

        if (letterOption == LetterOption.ALL || letterOption == LetterOption.NAME) {
            condition = condition.and(letter.userInfo.name.eq(userInfo.getName()));
        }
        if (letterOption == LetterOption.ALL || letterOption == LetterOption.MBTI) {
            condition = condition.and(letter.userInfo.mbti.eq(userInfo.getMbti()));
        }
        if (letterOption == LetterOption.ALL || letterOption == LetterOption.GENDER) {
            condition = condition.and(letter.userInfo.gender.eq(userInfo.getGender()));
        }
        if (letterOption == LetterOption.ALL) {
            condition = condition.and(letter.userInfo.birthday.eq(userInfo.getBirthday()));
        }

        return condition;
    }

    private BooleanExpression matchSender(Long senderId, LetterState letterState) {
        return letter.sender.id.eq(senderId)
                .and(letter.letterState.eq(letterState));
    }

    private BooleanExpression matchReceiver(Long receiverId, LetterState letterState) {
        return letter.receiver.id.eq(receiverId)
                .and(letter.letterState.eq(letterState));
    }
}
