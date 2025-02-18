package com.daepa.minimo.repository;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import com.daepa.minimo.domain.ImageFile;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

@Repository
public class FileRepository {
    @Value("${file.user-image-path}")
    private String USER_IMAGE_PATH;
    @Value("${file.default-user-image}")
    private String DEFAULT_USER_IMAGE_NAME;

    // image가 null일 때는 icon_default_user 이미지 경로 리턴
    public String getUserImagePath(ImageFile image) {
        if (image == null) {
            return USER_IMAGE_PATH + DEFAULT_USER_IMAGE_NAME;
        }
        return image.getFilePath();
    }

    public void deleteUserImage(ImageFile image) throws IOException {
        if (image == null) {
            return ;
        }

        Path path = Paths.get(image.getFilePath());
        Files.deleteIfExists(path);
    }

    public ImageFile saveUserImage(MultipartFile image) throws IOException {
        if (image == null) {
            return null;
        }

        String fileName = getRandomString() + "_" + image.getOriginalFilename();
        String filePath = USER_IMAGE_PATH + fileName;

        Path path = Paths.get(filePath);
        Files.createDirectories(path.getParent());
        Files.write(path, image.getBytes());

        return ImageFile.builder()
                .fileName(fileName)
                .filePath(filePath)
                .build();
    }

    private String getRandomString() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}

