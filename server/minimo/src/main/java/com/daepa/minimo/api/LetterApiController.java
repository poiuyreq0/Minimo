package com.daepa.minimo.api;

import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.common.enums.UserRole;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.dto.SimpleLetterDto;
import com.daepa.minimo.dto.LetterDto;
import com.daepa.minimo.service.FcmService;
import com.daepa.minimo.service.LetterService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api-letter")
public class LetterApiController {
    private final LetterService letterService;
    private final FcmService fcmService;

    @PreAuthorize("hasRole('USER')")
    @PostMapping("/letters")
    public ResponseEntity<Map<String, Long>> sendLetter(@RequestBody LetterDto letterDto) {
        Long letterId = letterService.sendLetter(letterDto.getSenderId(), letterDto.toLetter());
        return ResponseEntity.ok(Map.of("letterId", letterId));
    }

    @GetMapping("/letters/simple")
    public ResponseEntity<Map<LetterOption, List<SimpleLetterDto>>> getSimpleLetters(@RequestParam("userId") Long userId, @RequestParam("count") Integer count) {
        Map<LetterOption, List<SimpleLetterDto>> simpleLetters = letterService.getSimpleLetters(userId, count);
        return ResponseEntity.ok(simpleLetters);
    }

    @PostMapping("/letters/receive")
    public ResponseEntity<LetterDto> receiveLetter(@RequestParam("receiverId") Long receiverId, @RequestParam("letterOption") LetterOption letterOption) {
        Letter letter = letterService.receiveLetter(receiverId, letterOption);

        fcmService.letterNotification(letter.getId());

        return ResponseEntity.ok(LetterDto.fromLetter(letter));
    }

    @PostMapping("/letters/{id}/return")
    public ResponseEntity<Map<String, Long>> returnLetter(@PathVariable("id") Long letterId, @RequestParam("userId") Long userId, @RequestParam("userRole") UserRole userRole) {
        letterService.returnLetter(letterId, userId, userRole);
        return ResponseEntity.ok(Map.of("letterId", letterId));
    }

    @PostMapping("/letters/{id}/disconnect")
    public ResponseEntity<Map<String, Long>> disconnectLetter(@PathVariable("id") Long letterId, @RequestParam("userId") Long userId, @RequestParam("userRole") UserRole userRole) {
        letterService.disconnectLetter(letterId, userId, userRole);
        return ResponseEntity.ok(Map.of("letterId", letterId));
    }

    @PostMapping("/letters/{id}/connect")
    public ResponseEntity<Map<String, Long>> connectLetter(@PathVariable("id") Long letterId, @RequestParam("userId") Long userId, @RequestParam("userRole") UserRole userRole) {
        letterService.connectLetter(letterId, userId, userRole);

        fcmService.letterNotification(letterId);

        return ResponseEntity.ok(Map.of("letterId", letterId));
    }

    @GetMapping("/letters/user")
    public ResponseEntity<List<LetterDto>> getLettersByUserWithPaging(@RequestParam("userId") Long userId, @RequestParam("userRole") UserRole userRole, @RequestParam("letterState") LetterState letterState, @RequestParam("count") Integer count, @RequestParam(value = "lastDate", required = false) LocalDateTime lastDate) {
        List<LetterDto> letters = letterService.getLettersByUserWithPaging(userId, userRole, letterState, count, lastDate);
        return ResponseEntity.ok(letters);
    }

    @GetMapping("/letters/{id}/user")
    public ResponseEntity<LetterDto> getLetterByUser(@PathVariable("id") Long letterId, @RequestParam("userId") Long userId, @RequestParam("userRole") UserRole userRole) {
        Letter letter = letterService.getLetterByUser(letterId, userId, userRole);
        return ResponseEntity.ok(LetterDto.fromLetter(letter));
    }
}
