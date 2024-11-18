package com.daepa.minimo.api;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.dto.UserDto;
import com.daepa.minimo.dto.UserInfoDto;
import com.daepa.minimo.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/users")
public class UserApiController {
    private final UserService userService;

    @PostMapping
    public ResponseEntity<Map<String, Long>> createUser(@RequestBody UserDto userDto) {
        User user = userDto.toUser();
        Long userId = userService.createUser(user);
        return ResponseEntity.ok(Map.of("id", userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDto> getUser(@PathVariable("id") Long id) {
        User user = userService.findUser(id);
        return ResponseEntity.ok(UserDto.fromUser(user));
    }

    @GetMapping("/email")
    public ResponseEntity<UserDto> getUserByEmail(@RequestParam("email") String email) {
        User user = userService.findUserByEmail(email);
        return ResponseEntity.ok(UserDto.fromUser(user));
    }

    @GetMapping("/{id}/heart-num")
    public ResponseEntity<Map<String, Integer>> getHeartNum(@PathVariable("id") Long id) {
        Integer heartNum = userService.findHeartNum(id);
        return ResponseEntity.ok(Map.of("heartNum", heartNum));
    }

    @PostMapping("/{id}/update/user-info")
    public ResponseEntity<UserInfoDto> updateUserInfo(@PathVariable("id") Long id, @RequestBody UserInfoDto userInfoDto) {
        UserInfo userInfo = userService.updateUserInfo(id, userInfoDto.toUserInfo());
        return ResponseEntity.ok(UserInfoDto.fromUserInfo(userInfo));
    }

    @PostMapping("/{id}/update/nickname")
    public ResponseEntity<UserDto> updateNickname(@PathVariable("id") Long id, @RequestBody UserDto userDto) {
        User user = userService.updateNickname(id, userDto.getNickname());
        return ResponseEntity.ok(UserDto.fromUser(user));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Long>> deleteUser(@PathVariable("id") Long id) {
        userService.deleteUser(id);
        return ResponseEntity.ok(Map.of("id", id));
    }
}
