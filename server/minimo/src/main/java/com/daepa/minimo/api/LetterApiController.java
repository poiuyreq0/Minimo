package com.daepa.minimo.api;

import com.daepa.minimo.common.enums.LetterOption;
import com.daepa.minimo.common.enums.LetterState;
import com.daepa.minimo.common.enums.UserRole;
import com.daepa.minimo.domain.Letter;
import com.daepa.minimo.dto.LetterElementDto;
import com.daepa.minimo.dto.LetterDto;
import com.daepa.minimo.dto.UserRoleDto;
import com.daepa.minimo.service.LetterService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/letters")
public class LetterApiController {
    private final LetterService letterService;

    @PostMapping("/send")
    public ResponseEntity<Map<String, Long>> sendLetter(@RequestBody LetterDto letterDto) {
        Letter letter = letterDto.toLetter();
        Long letterId = letterService.sendLetter(letterDto.getSenderId(), letter);
        return ResponseEntity.ok(Map.of("id", letterId));
    }

    @GetMapping("/option/every")
    public ResponseEntity<Map<LetterOption, List<LetterElementDto>>> getLettersByEveryOption(@RequestParam("userId") Long userId, @RequestParam("count") Integer count) {
        Map<LetterOption, List<LetterElementDto>> result = new HashMap<>();
        for (LetterOption letterOption: LetterOption.values()) {
            List<LetterElementDto> letters = letterService.findLettersByOption(userId, letterOption, count);
            result.put(letterOption, letters);
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/receive")
    public ResponseEntity<LetterDto> receiveLetter(@RequestBody LetterDto letterDto) {
        Letter letter = letterService.receiveLetter(letterDto.getReceiverId(), letterDto.getLetterOption());
        return ResponseEntity.ok(LetterDto.fromLetter(letter));
    }

    @PostMapping("/{id}/sink")
    public ResponseEntity<Map<String, Long>> sinkLetter(@PathVariable("id") Long id, @RequestBody UserRoleDto userRoleDto) {
        Long letterId = letterService.sinkLetter(id, userRoleDto.getId(), userRoleDto.getUserRole());
        return ResponseEntity.ok(Map.of("id", letterId));
    }

    @PostMapping("/{id}/return")
    public ResponseEntity<Map<String, Long>> returnLetter(@PathVariable("id") Long id, @RequestBody UserRoleDto userRoleDto) {
        Long letterId = letterService.returnLetter(id, userRoleDto.getId(), userRoleDto.getUserRole());
        return ResponseEntity.ok(Map.of("id", letterId));
    }

    @PostMapping("/{id}/connect")
    public ResponseEntity<Map<String, Long>> connectLetter(@PathVariable("id") Long id, @RequestBody UserRoleDto userRoleDto) {
        Long letterId = letterService.connectLetter(id, userRoleDto.getId(), userRoleDto.getUserRole());
        return ResponseEntity.ok(Map.of("id", letterId));
    }

    @PostMapping("/{id}/disconnect")
    public ResponseEntity<Map<String, Long>> disconnectLetter(@PathVariable("id") Long id, @RequestBody UserRoleDto userRoleDto) {
        Long letterId = letterService.disconnectLetter(id, userRoleDto.getId(), userRoleDto.getUserRole());
        return ResponseEntity.ok(Map.of("id", letterId));
    }

    @GetMapping
    public ResponseEntity<List<LetterDto>> getLetters(@RequestParam("userId") Long userId, @RequestParam("userRole") UserRole userRole, @RequestParam("letterState") LetterState letterState) {
        List<LetterDto> letters = letterService.findLetters(userId, userRole, letterState);
        return ResponseEntity.ok(letters);
    }
}