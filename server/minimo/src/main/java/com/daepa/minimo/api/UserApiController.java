package com.daepa.minimo.api;

import com.daepa.minimo.common.enums.Item;
import com.daepa.minimo.common.enums.ReportReason;
import com.daepa.minimo.domain.ImageFile;
import com.daepa.minimo.dto.*;
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
@RequestMapping("/api-user")
public class UserApiController {
    private final UserService userService;

    @GetMapping("/users/email")
    public ResponseEntity<UserDto> getUserByEmail(@RequestParam("email") String email) {
        UserDto user = userService.getUserByEmail(email);
        if (user == null) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(user);
    }

    @PostMapping("/users")
    public ResponseEntity<Map<String, Long>> createUser(@RequestBody UserDto userDto) {
        Long userId = userService.createUser(userDto.toUser());
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @GetMapping("/users/{id}/item-num")
    public ResponseEntity<Map<String, Integer>> getItemNum(@PathVariable("id") Long userId, @RequestParam("item") Item item) {
        Integer itemNum = userService.getItemNum(userId, item);
        return ResponseEntity.ok(Map.of("itemNum", itemNum));
    }

    @PostMapping("/users/{id}/item-num/add")
    public ResponseEntity<Map<String, Integer>> addItemNum(@PathVariable("id") Long userId, @RequestParam("item") Item item, @RequestParam("amount") Integer amount) {
        Integer itemNum = userService.addItemNum(userId, item, amount);
        return ResponseEntity.ok(Map.of("itemNum", itemNum));
    }

    @GetMapping("/users/{id}/image")
    public ResponseEntity<Resource> getImage(@PathVariable("id") Long userId) throws IOException {
        String filePath = userService.getImageFilePath(userId);

        MediaType mediaType = MediaType.parseMediaType(Files.probeContentType(Paths.get(filePath)));
        UrlResource resource = new UrlResource("file:" + filePath);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_TYPE, mediaType.toString())
                .body(resource);
    }

    @PostMapping("/users/{id}/image/update")
    public ResponseEntity<Map<String, Long>> updateImage(@PathVariable("id") Long userId, @RequestParam("image") MultipartFile image) throws IOException {
        userService.updateImage(userId, image);
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @DeleteMapping("/users/{id}/image")
    public ResponseEntity<Map<String, Long>> deleteImage(@PathVariable("id") Long userId) throws IOException {
        userService.updateImage(userId, null);
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @PostMapping("/users/{id}/user-info/update")
    public ResponseEntity<Map<String, Long>> updateUserInfo(@PathVariable("id") Long userId, @RequestBody UserInfoDto userInfoDto) {
        userService.updateUserInfo(userId, userInfoDto.toUserInfo());
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @PostMapping("/users/{id}/nickname/update")
    public ResponseEntity<Map<String, Long>> updateNickname(@PathVariable("id") Long userId, @RequestParam("nickname") String nickname) {
        userService.updateNickname(userId, nickname);
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @PostMapping("/users/{id}/fcm-token/update")
    public ResponseEntity<Map<String, Long>> updateFcmToken(@PathVariable("id") Long userId, @RequestBody FcmTokenDto fcmTokenDto) {
        userService.updateFcmToken(userId, fcmTokenDto.toFcmToken());
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @DeleteMapping("/users/{id}/fcm-token")
    public ResponseEntity<Map<String, Long>> deleteFcmToken(@PathVariable("id") Long userId) {
        userService.deleteFcmToken(userId);
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @PostMapping("/users/{id}/ban")
    public ResponseEntity<Map<Long, UserBanRecordDto>> banUser(@PathVariable("id") Long userId, @RequestParam("targetId") Long targetId, @RequestParam("targetNickname") String targetNickname) {
        Map<Long, UserBanRecordDto> userBanRecordMap = userService.banUser(userId, targetId, targetNickname);
        return ResponseEntity.ok(userBanRecordMap);
    }

    @PostMapping("/users/{id}/unban")
    public ResponseEntity<Map<Long, UserBanRecordDto>> unbanUser(@PathVariable("id") Long userId, @RequestParam("targetId") Long targetId) {
        Map<Long, UserBanRecordDto> userBanRecordMap = userService.unbanUser(userId, targetId);
        return ResponseEntity.ok(userBanRecordMap);
    }

    @PostMapping("/users/{id}/report")
    public ResponseEntity<Map<String, Long>> reportUser(@PathVariable("id") Long userId, @RequestParam("targetId") Long targetId, @RequestParam("reportReason") ReportReason reportReason) {
        userService.reportUser(userId, targetId, reportReason);
        return ResponseEntity.ok(Map.of("userId", userId));
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<Map<String, Long>> deleteUser(@PathVariable("id") Long userId) throws IOException {
        userService.deleteUser(userId);
        return ResponseEntity.ok(Map.of("userId", userId));
    }
}
