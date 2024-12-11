package com.daepa.minimo.api;

import com.daepa.minimo.common.embeddables.UserInfo;
import com.daepa.minimo.domain.ImageFile;
import com.daepa.minimo.domain.User;
import com.daepa.minimo.dto.UserDto;
import com.daepa.minimo.dto.UserInfoDto;
import com.daepa.minimo.service.UserService;
import lombok.RequiredArgsConstructor;
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

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/user")
public class UserApiController {
    private final UserService userService;

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

    @PostMapping
    public ResponseEntity<Map<String, Long>> createUser(@RequestBody UserDto userDto) {
        User user = userDto.toUser();
        Long userId = userService.createUser(user);
        return ResponseEntity.ok(Map.of("id", userId));
    }

    @GetMapping("/{id}/heart-num")
    public ResponseEntity<Integer> getHeartNum(@PathVariable("id") Long id) {
        Integer heartNum = userService.findHeartNum(id);
        return ResponseEntity.ok(heartNum);
    }

    @GetMapping("/{id}/image")
    public ResponseEntity<Resource> getImage(@PathVariable("id") Long id) throws IOException {
        ImageFile imageFile = userService.findImageFile(id);
        String filePath = imageFile.getFilePath();

        MediaType mediaType = MediaType.parseMediaType(Files.probeContentType(Paths.get(filePath)));
        UrlResource resource = new UrlResource("file:" + filePath);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_TYPE, mediaType.toString())
                .body(resource);
    }

    @PostMapping("/{id}/update/image")
    public ResponseEntity<Map<String, Long>> updateImage(@PathVariable("id") Long id, @RequestParam("image") MultipartFile image) throws IOException {
        System.out.println("updateImage: " + image.getSize());
        Long userId = userService.updateImage(id, image);
        return ResponseEntity.ok(Map.of("id", userId));
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
        Long deletedId = userService.deleteUser(id);
        return ResponseEntity.ok(Map.of("id", deletedId));
    }
}
