package com.daepa.minimo.api;

import com.daepa.minimo.dto.ChatMessageDto;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@RequiredArgsConstructor
@Controller
public class ChatController {
    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat/sendMessage")
    public ChatMessageDto sendMessage(ChatMessageDto message) {
        
        // 데이터베이스 저장 로직
        
        messagingTemplate.convertAndSend(
                "/queue/room/" + message.getRoomId() + "/receiver/" + message.getReceiverId(),
                message
        );
        return message;
    }
}