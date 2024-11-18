package com.daepa.minimo.component;

import com.daepa.minimo.repository.LetterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@RequiredArgsConstructor
@Component
public class LetterScheduledComponent {
    private final LetterRepository letterRepository;

    @Scheduled(cron = "0 0 * * * *")
    @Transactional
    public void returnLetters() {
        letterRepository.returnLetters(LocalDateTime.now());
    }
}
