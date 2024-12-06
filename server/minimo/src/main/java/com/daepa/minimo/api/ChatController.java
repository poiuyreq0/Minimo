package com.daepa.minimo.api;

import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@RequiredArgsConstructor
@Controller
public class ChatController {
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;

    @MessageMapping("/chat/send")
    public ChatMessageDto sendMessage(ChatMessageDto message) {
        chatService.sendMessage(message.getRoomId(), message.toChatMessage());
        
        messagingTemplate.convertAndSend(
                "/topic/room/" + message.getRoomId(),
                message
        );

        return message;
    }
}
