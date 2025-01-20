package com.daepa.minimo.api;

import com.daepa.minimo.common.enums.Item;
import com.daepa.minimo.domain.ImageFile;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.dto.FcmTokenDto;
import com.daepa.minimo.dto.UserDto;
import com.daepa.minimo.dto.UserInfoDto;
import com.daepa.minimo.dto.UserNicknameDto;
import com.daepa.minimo.service.FileService;
import com.daepa.minimo.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/user")
public class UserApiController {
    private final UserService userService;
    private final FileService fileService;

    @GetMapping("/email")
    public ResponseEntity<UserDto> getUserByEmail(@RequestParam("email") String email) {
        User user = userService.findUserByEmail(email);
        if (user == null) {
            return ResponseEntity.ok(null);
        }

        return ResponseEntity.ok(UserDto.fromUser(user));
    }

    @PostMapping
    public ResponseEntity<Map<String, Long>> createUser(@RequestBody UserDto userDto) {
        Long userId = userService.createUser(userDto.toUser());
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @GetMapping("/{id}/item-num")
    public ResponseEntity<Map<String, Integer>> getItemNum(@PathVariable("id") Long userId, @RequestParam("item") Item item) {
        Integer itemNum = userService.findItemNum(userId, item);
        return ResponseEntity.ok(Map.of("itemNum", itemNum));
    }

    @PostMapping("/{id}/item-num/add")
    public ResponseEntity<Map<String, Integer>> addItemNum(@PathVariable("id") Long userId, @RequestParam("item") Item item, @RequestParam("amount") Integer amount) {
        Integer itemNum = userService.addItemNum(userId, item, amount);
        return ResponseEntity.ok(Map.of("itemNum", itemNum));
    }

    @GetMapping("/{id}/image")
    public ResponseEntity<Resource> getImage(@PathVariable("id") Long userId) throws IOException {
        ImageFile image = userService.findImage(userId);

        // image가 null일 때는 icon_default_user 이미지 경로 리턴
        String filePath = fileService.findUserImagePath(image);

        MediaType mediaType = MediaType.parseMediaType(Files.probeContentType(Paths.get(filePath)));
        UrlResource resource = new UrlResource("file:" + filePath);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_TYPE, mediaType.toString())
                .body(resource);
    }

    @PostMapping("/{id}/update/image")
    public ResponseEntity<Map<String, Long>> updateImage(@PathVariable("id") Long userId, @RequestParam("image") MultipartFile image) throws IOException {
        ImageFile savedImage = fileService.saveUserImage(image);
        userService.updateImage(userId, savedImage);
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @DeleteMapping("/{id}/delete/image")
    public ResponseEntity<Map<String, Long>> deleteImage(@PathVariable("id") Long userId) {
        userService.deleteImage(userId);
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @PostMapping("/{id}/update/user-info")
    public ResponseEntity<UserInfoDto> updateUserInfo(@PathVariable("id") Long userId, @RequestBody UserInfoDto userInfoDto) {
        userService.updateUserInfo(userId, userInfoDto.toUserInfo());
        return ResponseEntity.ok(userInfoDto);
    }

    @PostMapping("/{id}/update/nickname")
    public ResponseEntity<Map<String, String>> updateNickname(@PathVariable("id") Long userId, @RequestBody UserNicknameDto userNicknameDto) {
        userService.updateNickname(userId, userNicknameDto.getNickname());
        return ResponseEntity.ok(Map.of("nickname", userNicknameDto.getNickname()));
    }

    @PostMapping("/{id}/update/fcm-token")
    public ResponseEntity<Map<String, Long>> updateFcmToken(@PathVariable("id") Long userId, @RequestBody FcmTokenDto fcmTokenDto) {
        userService.updateFcmToken(userId, fcmTokenDto.toFcmToken());
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Long>> deleteUser(@PathVariable("id") Long userId) {
        userService.deleteUser(userId);
        return ResponseEntity.ok(Map.of("userId", userId));
    }
}
