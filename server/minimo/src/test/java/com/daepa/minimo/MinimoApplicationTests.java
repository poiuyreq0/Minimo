package com.daepa.minimo;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest
@Transactional
class MinimoApplicationTests {
	@PersistenceContext	private EntityManager em;

	@Test
	@Rollback(value = false)
	void contextLoads() {

	}
}
