package com.daepa.minimo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableAspectJAutoProxy
@EnableScheduling
@EnableJpaAuditing
@SpringBootApplication
public class MinimoApplication {

	public static void main(String[] args) {
		SpringApplication.run(MinimoApplication.class, args);
	}

}
