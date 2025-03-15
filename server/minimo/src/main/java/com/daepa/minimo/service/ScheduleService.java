package com.daepa.minimo.service;

import com.daepa.minimo.repository.LetterRepository;
import com.daepa.minimo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@RequiredArgsConstructor
@Service
@Transactional
public class ScheduleService {
    private final UserRepository userRepository;
    private final LetterRepository letterRepository;

    @Scheduled(cron = "0 0 * * * *")
    public void returnLetters() {
        letterRepository.returnLetters(LocalDateTime.now());
    }

    @Scheduled(cron = "0 30 * * * *")
    public void reinstateAccountRole() {
        userRepository.reinstateAccountRole(LocalDateTime.now());
    }
}
