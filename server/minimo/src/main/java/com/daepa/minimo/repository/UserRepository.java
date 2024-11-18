package com.daepa.minimo.repository;

import com.daepa.minimo.domain.User;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@RequiredArgsConstructor
@Repository
public class UserRepository {
    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    public void createUser(User user) {
        em.persist(user);
    }

    public User findUser(Long id) {
        return em.find(User.class, id);
    }

    public User findUserByEmail(String email) {
        List<User> findUserList =  em.createQuery("select u from User u where u.email = :email", User.class)
                .setParameter("email", email)
                .getResultList();

        if (!findUserList.isEmpty()) {
            return findUserList.getFirst();
        } else {
            return null;
        }
    }

    public User findUserByNickname(String nickname) {
        List<User> findUserList = em.createQuery("select u from User u where u.nickname = :nickname", User.class)
                .setParameter("nickname", nickname)
                .getResultList();

        if (!findUserList.isEmpty()) {
            return findUserList.getFirst();
        } else {
            return null;
        }
    }

    public void deleteUser(User user) {
        em.remove(user);
    }
}
