package com.daepa.minimo.repository;

import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.common.enums.UserRole;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.dto.LetterDto;
import com.daepa.minimo.dto.LetterElementDto;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

import static com.daepa.minimo.domain.QLetter.letter;
import static com.daepa.minimo.domain.QReceivedRecord.receivedRecord;

@RequiredArgsConstructor
@Repository
public class LetterRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void saveLetter(Letter letter) {
        em.persist(letter);
    }

    public Letter findLetter(Long id) {
        return em.find(Letter.class, id);
    }

    // 새로운 편지 목록 조회
    public List<LetterElementDto> findNewLettersByOption(User user, LetterOption letterOption, Integer count) {
        BooleanExpression condition = matchUserInfoByOption(user, letterOption)
                .and(matchNotReceivedLetter(user));

        return queryFactory
                .select(Projections.fields(
                        LetterElementDto.class,
                        letter.id,
                        letter.sender.nickname.as("senderNickname"),
                        letter.letterContent.title,
                        letter.letterState
                ))
                .from(letter)
                .where(condition)
                .orderBy(letter.createdDate.desc())
                .limit(count)
                .fetch();
    }

    // 새로운 편지 단건 조회
    public Letter findNewLetterByOption(User user, LetterOption letterOption) {
        BooleanExpression condition = matchUserInfoByOption(user, letterOption)
                .and(matchNotReceivedLetter(user));

        return queryFactory
                .selectFrom(letter)
                .where(condition)
                .orderBy(letter.createdDate.desc())
                .fetchFirst();
    }

    // 유저 편지 목록 조회
    public List<LetterDto> findLettersByUser(Long userId, UserRole userRole, LetterState letterState) {
        BooleanExpression condition = userRole == UserRole.SENDER ? matchSender(userId, letterState) : matchReceiver(userId, letterState);

        OrderSpecifier<?> orderBy;
        if (letterState == LetterState.CONNECTED) {
            orderBy = letter.connectedDate.desc();
        } else if (userRole == UserRole.SENDER) {
            orderBy = letter.createdDate.desc();
        } else {
            orderBy = letter.receivedDate.desc();
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
                .orderBy(orderBy)
                .fetch();
    }

    public void deleteLetter(Letter letter) {
        em.remove(letter);
    }

    // @Scheduled
    // 받은 편지 24시간 후 되돌리기
    public void returnLetters(LocalDateTime current) {
        queryFactory.update(letter)
                .set(letter.receiver, (User) null)
                .set(letter.receivedDate, (LocalDateTime) null)
                .set(letter.letterState, LetterState.SENT)
                .where(letter.letterState.eq(LetterState.LOCKED)
                        .and(letter.receivedDate.lt(current.minusDays(1))))
                .execute();
    }

    private BooleanExpression matchNotReceivedLetter(User receiver) {
        return letter.id.notIn(
                JPAExpressions
                        .select(receivedRecord.letter.id)
                        .from(receivedRecord)
                        .where(receivedRecord.receiverId.eq(receiver.getId()))
        );
    }

    private BooleanExpression matchUserInfoByOption(User user, LetterOption letterOption) {
        BooleanExpression condition = letter.sender.id.ne(user.getId())
                .and(letter.letterState.eq(LetterState.SENT))
                .and(letter.letterOption.eq(letterOption));

        switch (letterOption) {
            case LetterOption.ALL:
                condition = condition
                        .and(letter.userInfo.name.eq(user.getUserInfo().getName()))
                        .and(letter.userInfo.mbti.eq(user.getUserInfo().getMbti()))
                        .and(letter.userInfo.gender.eq(user.getUserInfo().getGender()))
                        .and(letter.userInfo.birthday.eq(user.getUserInfo().getBirthday()));
                break;
            case LetterOption.NAME:
                condition = condition
                        .and(letter.userInfo.name.eq(user.getUserInfo().getName()));
                break;
            case LetterOption.MBTI:
                condition = condition
                        .and(letter.userInfo.mbti.eq(user.getUserInfo().getMbti()));
                break;
            case LetterOption.GENDER:
                condition = condition
                        .and(letter.userInfo.gender.eq(user.getUserInfo().getGender()));
                break;
            case LetterOption.NONE:
                break;
            default:
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
