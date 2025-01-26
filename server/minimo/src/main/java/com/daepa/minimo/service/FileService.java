package com.daepa.minimo.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import com.daepa.minimo.domain.ImageFile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileService {
    private final String USER_IMAGE_PATH = "C:/Users/poiuyreq0/Downloads/Minimo/minimo_storage/user_image/"; // 윈도우
//    private static final String USER_IMAGE_PATH = "/home/ec2-user/minimo_storage/user_image/"; // 리눅스

    private final String DEFAULT_USER_IMAGE_PATH = USER_IMAGE_PATH + "icon_default_user.jpg";

    public String findUserImagePath(ImageFile image) {
        if (image == null) {
            return DEFAULT_USER_IMAGE_PATH;
        }
        return image.getFilePath();
    }

    public ImageFile saveUserImage(MultipartFile image) throws IOException {
        String fileName = getRandomString() + "_" + image.getOriginalFilename();
        String filePath = USER_IMAGE_PATH + fileName;

        Path path = Paths.get(filePath);
        Files.createDirectories(path.getParent());
        Files.write(path, image.getBytes());

        return ImageFile.builder()
                .fileName(image.getName())
                .filePath(filePath)
                .build();
    }

    private String getRandomString() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}

