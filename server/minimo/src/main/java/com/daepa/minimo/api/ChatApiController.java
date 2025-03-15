package com.daepa.minimo.api;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.dto.ReadChatDto;
import com.daepa.minimo.service.ChatService;
import com.daepa.minimo.service.FcmService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api-chat")
public class ChatApiController {
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;
    private final FcmService fcmService;

    @PostMapping("/messages")
    public ResponseEntity<Map<String, Long>> sendMessage(@RequestBody ChatMessageDto chatMessageDto) {
        ChatMessage chatMessage = chatService.sendMessage(chatMessageDto.getRoomId(), chatMessageDto.toChatMessage());

        messagingTemplate.convertAndSend(
                "/topic/room/" + chatMessageDto.getRoomId() + "/send",
                ChatMessageDto.fromChatMessage(chatMessage)
        );

        fcmService.chatNotification(chatMessage.getId());

        return ResponseEntity.ok(Map.of("messageId", chatMessage.getId()));
    }

    @PostMapping("/messages/read")
    public ResponseEntity<Map<String, Long>> readMessage(@RequestBody ReadChatDto readChatDto) {
        messagingTemplate.convertAndSend(
                "/topic/room/" + readChatDto.getRoomId() + "/read",
                readChatDto
        );

        chatService.readMessage(readChatDto.getMessageId());
        return ResponseEntity.ok(Map.of("messageId", readChatDto.getMessageId()));
    }

    @PostMapping("/rooms/{id}/messages")
    public ResponseEntity<List<ChatMessageDto>> getMessagesByRoomWithPaging(@PathVariable("id") Long roomId, @RequestParam("userId") Long userId, @RequestParam("count") Integer count, @RequestParam(value = "lastDate", required = false) LocalDateTime lastDate) {
        // 처음 채팅방 입장 시 메시지 읽음 표시
        if (lastDate == null) {
            messagingTemplate.convertAndSend(
                    "/topic/room/" + roomId + "/enter",
                    userId
            );
        }

        List<ChatMessageDto> messageDtos = chatService.getMessagesByRoomWithPaging(roomId, userId, count, lastDate);
        return ResponseEntity.ok(messageDtos);
    }

    @GetMapping("/rooms/user")
    public ResponseEntity<List<ChatRoomDto>> getChatRoomsByUserWithPaging(@RequestParam("userId") Long userId, @RequestParam("count") Integer count, @RequestParam(value = "lastDate", required = false) LocalDateTime lastDate) {
        List<ChatRoomDto> chatRooms = chatService.getChatRoomsByUserWithPaging(userId, count, lastDate);
        return ResponseEntity.ok(chatRooms);
    }

    @PostMapping("/rooms/{id}/disconnect")
    public ResponseEntity<Map<String, Long>> disconnectChatRoom(@PathVariable("id") Long roomId, @RequestParam("userId") Long userId) {
        chatService.disconnectChatRoom(roomId, userId);
        return ResponseEntity.ok(Map.of("roomId", roomId));
    }
}
