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
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/letter")
public class LetterApiController {
    private final LetterService letterService;
    private final FcmService fcmService;

    @PostMapping("/send")
    public ResponseEntity<Map<String, Long>> sendLetter(@RequestBody LetterDto letterDto) {
        Long letterId = letterService.sendLetter(letterDto.getSenderId(), letterDto.toLetter());
        return ResponseEntity.ok(Map.of("letterId", letterId));
    }

    @GetMapping("/new/every")
    public ResponseEntity<Map<LetterOption, List<SimpleLetterDto>>> getEveryNewLetters(@RequestParam("userId") Long userId, @RequestParam("count") Integer count) {
        Map<LetterOption, List<SimpleLetterDto>> result = new HashMap<>();
        for (LetterOption letterOption: LetterOption.values()) {
            List<SimpleLetterDto> letters = letterService.findNewLettersByOption(userId, letterOption, count);
            result.put(letterOption, letters);
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/receive")
    public ResponseEntity<LetterDto> receiveLetter(@RequestParam("receiverId") Long receiverId, @RequestParam("letterOption") LetterOption letterOption) {
        Letter letter = letterService.receiveLetter(receiverId, letterOption);

        fcmService.letterNotification(letter);

        return ResponseEntity.ok(LetterDto.fromLetter(letter));
    }

    @PostMapping("/{id}/sink")
    public ResponseEntity<Map<String, Long>> sinkLetter(@PathVariable("id") Long letterId) {
        letterService.sinkLetter(letterId);
        return ResponseEntity.ok(Map.of("letterId", letterId));
    }

    @PostMapping("/{id}/return")
    public ResponseEntity<Map<String, Long>> returnLetter(@PathVariable("id") Long letterId) {
        letterService.returnLetter(letterId);
        return ResponseEntity.ok(Map.of("letterId", letterId));
    }

    @PostMapping("/{id}/disconnect")
    public ResponseEntity<Map<String, Long>> disconnectLetter(@PathVariable("id") Long letterId, @RequestParam("userId") Long userId, @RequestParam("userRole") UserRole userRole) {
        letterService.disconnectLetter(letterId, userId, userRole);
        return ResponseEntity.ok(Map.of("letterId", letterId));
    }

    @PostMapping("/{id}/connect")
    public ResponseEntity<Map<String, Long>> connectLetter(@PathVariable("id") Long letterId) {
        Letter letter = letterService.connectLetter(letterId);

        fcmService.letterNotification(letter);

        return ResponseEntity.ok(Map.of("chatRoomId", letter.getChatRoomId()));
    }

    @GetMapping("/user")
    public ResponseEntity<List<LetterDto>> getLettersByUser(@RequestParam("userId") Long userId, @RequestParam("userRole") UserRole userRole, @RequestParam("letterState") LetterState letterState) {
        List<LetterDto> letters = letterService.findLettersByUser(userId, userRole, letterState);
        return ResponseEntity.ok(letters);
    }

    @GetMapping("/{id}/user")
    public ResponseEntity<LetterDto> getLetterByUser(@PathVariable("id") Long letterId) {
        Letter letter = letterService.findLetterByUser(letterId);
        return ResponseEntity.ok(LetterDto.fromLetter(letter));
    }
}
