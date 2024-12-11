package com.daepa.minimo.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import com.daepa.minimo.domain.ImageFile;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileUtil {
    private static final String FILE_PATH = "C:/Users/poiuyreq0/Downloads/Minimo/"; // 윈도우
//    private static final String FILE_PATH = "/usr/local/download/Minimo/";    // 리눅스

    public static ImageFile saveImage(MultipartFile image) throws IOException {
        String fileName = getRandomString() + "_" + image.getOriginalFilename();
        String filePath = FILE_PATH + fileName;

        Path path = Paths.get(filePath);
        Files.createDirectories(path.getParent());
        Files.write(path, image.getBytes());

        return ImageFile.builder()
                .fileName(image.getName())
                .filePath(filePath)
                .build();
    }

    private static String getRandomString() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}

