package com.daepa.minimo.repository;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.common.enums.AccountRole;
import com.daepa.minimo.common.enums.Item;
import com.daepa.minimo.common.enums.ReportReason;
import com.daepa.minimo.domain.*;
import com.daepa.minimo.dto.UserBanRecordDto;
import com.daepa.minimo.dto.UserDto;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.NumberPath;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.daepa.minimo.domain.QChatMessage.chatMessage;
import static com.daepa.minimo.domain.QChatRoom.chatRoom;
import static com.daepa.minimo.domain.QChatRoomUser.chatRoomUser;
import static com.daepa.minimo.domain.QComment.comment;
import static com.daepa.minimo.domain.QCommentLikeRecord.commentLikeRecord;
import static com.daepa.minimo.domain.QImageFile.imageFile;
import static com.daepa.minimo.domain.QLetter.letter;
import static com.daepa.minimo.domain.QLetterReceiveRecord.letterReceiveRecord;
import static com.daepa.minimo.domain.QPost.post;
import static com.daepa.minimo.domain.QPostLikeRecord.postLikeRecord;
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

    public AccountRole getAccountRoleByUserEmail(String email) {
        return queryFactory
                .select(user.accountRole)
                .from(user)
                .where(user.email.eq(email))
                .fetchOne();
    }

    public UserInfo getUserInfo(Long userId) {
        return queryFactory
                .select(user.userInfo)
                .from(user)
                .where(user.id.eq(userId))
                .fetchOne();
    }

    public void updateUserInfo(Long userId, UserInfo userInfo) {
        queryFactory
                .update(user)
                .set(user.userInfo, userInfo)
                .where(user.id.eq(userId))
                .execute();
    }

    public Integer getItemNum(Long userId, Item item) {
        return queryFactory
                .select(item == Item.NET ? user.netNum : user.bottleNum)
                .from(user)
                .where(user.id.eq(userId))
                .fetchOne();
    }

    public void addItemNum(Long userId, Item item, Integer amount) {
        NumberPath<Integer> target = item == Item.NET ? user.netNum : user.bottleNum;

        queryFactory
                .update(user)
                .set(target, target.add(amount))
                .where(user.id.eq(userId))
                .execute();
    }

    public ImageFile getImage(Long userId) {
        return queryFactory
                .select(user.profileImage)
                .from(user)
                .where(user.id.eq(userId))
                .fetchOne();
    }

    public void updateNickname(Long userId, String nickname) {
        queryFactory
                .update(user)
                .set(user.nickname, nickname)
                .where(user.id.eq(userId))
                .execute();
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

    public void deleteUserWithRelations(Long userId) {
        /*
        Letter
         */

        // 연관된 편지 연결 끊기
        queryFactory
                .update(letter)
                .set(letter.sender, (User) null)
                .where(letter.sender.id.eq(userId))
                .execute();
        queryFactory
                .update(letter)
                .set(letter.receiver, (User) null)
                .where(letter.receiver.id.eq(userId))
                .execute();

        // 주인 없는 편지 삭제
        queryFactory
                .delete(letterReceiveRecord)
                .where(letterReceiveRecord.letter.sender.isNull()
                        .and(letterReceiveRecord.letter.receiver.isNull()))
                .execute();
        queryFactory
                .delete(letter)
                .where(letter.sender.isNull()
                        .and(letter.receiver.isNull()))
                .execute();

//        List<Letter> ownerlessLetters = queryFactory
//                .selectFrom(letter)
//                .where(letter.sender.isNull()
//                        .and(letter.receiver.isNull()))
//                .fetch();
//        for (Letter letter: ownerlessLetters) {
//            em.remove(letter);
//        }



        /*
        Chat
         */

        // 연관된 채팅방 나가기
        queryFactory
                .delete(chatRoomUser)
                .where(chatRoomUser.user.id.eq(userId))
                .execute();

        // 주인 없는 채팅방 삭제
        queryFactory
                .delete(chatMessage)
                .where(chatMessage.chatRoom.chatRoomUserList.isEmpty())
                .execute();
        queryFactory
                .delete(chatRoom)
                .where(chatRoom.chatRoomUserList.isEmpty())
                .execute();

//        List<ChatRoom> ownerlessChatRooms = queryFactory
//                .selectFrom(chatRoom)
//                .where(chatRoom.chatRoomUserList.isEmpty())
//                .fetch();
//        for (ChatRoom chatRoom: ownerlessChatRooms) {
//            em.remove(chatRoom);
//        }



        /*
        Post
         */

        // 작성한 게시글 삭제
        List<Long> postIds = queryFactory
                .select(post.id)
                .from(post)
                .where(post.writer.id.eq(userId))
                .fetch();
        queryFactory
                .delete(commentLikeRecord)
                .where(commentLikeRecord.comment.post.id.in(postIds))
                .execute();
        queryFactory
                .delete(comment)
                .where(comment.post.id.in(postIds)
                        .and(comment.parentComment.isNotNull()))
                .execute();
        queryFactory
                .delete(comment)
                .where(comment.post.id.in(postIds)
                        .and(comment.parentComment.isNull()))
                .execute();
        queryFactory
                .delete(postLikeRecord)
                .where(postLikeRecord.post.id.in(postIds))
                .execute();
        queryFactory
                .delete(post)
                .where(post.id.in(postIds))
                .execute();

//        List<Post> writtenPosts = queryFactory
//                .selectFrom(post)
//                .where(post.writer.id.eq(userId))
//                .fetch();
//        for (Post post: writtenPosts) {
//            em.remove(post);
//        }

        // 다른 사용자 게시물의 댓글은 안 보이도록 처리
        queryFactory
                .update(comment)
                .set(comment.isVisible, false)
                .where(comment.writerId.eq(userId))
                .execute();
        queryFactory
                .update(post)
                .set(post.commentNum, post.commentNum.subtract(
                        JPAExpressions
                                .select(comment.count())
                                .from(comment)
                                .where(comment.post.id.eq(post.id)
                                        .and(comment.writerId.eq(userId)))
                ))
                .where(post.id.in(
                        JPAExpressions
                                .select(comment.post.id)
                                .from(comment)
                                .where(comment.writerId.eq(userId))
                ))
                .execute();

//        List<Comment> ownerlessComments = queryFactory
//                .selectFrom(comment)
//                .where(comment.writerId.eq(userId))
//                .fetch();
//        for (Comment comment: ownerlessComments) {
//            comment.updateIsVisible();
//        }



        /*
        User
         */

        // 사용자 삭제
        User target = queryFactory
                .selectFrom(user)
                .where(user.id.eq(userId))
                .fetchOne();

        em.remove(target);
    }

    public void reinstateAccountRole(LocalDateTime currentDate) {
        queryFactory
                .update(user)
                .set(user.accountRole, AccountRole.USER)
                .where(user.suspendedDate.lt(currentDate.minusDays(30)))
                .execute();
    }
}
