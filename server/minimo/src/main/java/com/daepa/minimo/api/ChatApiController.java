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

import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/chat")
public class ChatApiController {
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;
    private final FcmService fcmService;

    @PostMapping("/message/send")
    public ResponseEntity<Map<String, Long>> sendMessage(@RequestBody ChatMessageDto chatMessageDto) {
        ChatMessage chatMessage = chatService.sendMessage(chatMessageDto.getRoomId(), chatMessageDto.toChatMessage());

        messagingTemplate.convertAndSend(
                "/topic/room/" + chatMessageDto.getRoomId() + "/send",
                ChatMessageDto.fromChatMessage(chatMessage)
        );

        fcmService.chatNotification(chatMessage);

        return ResponseEntity.ok(Map.of("messageId", chatMessage.getId()));
    }

    @PostMapping("/message/read")
    public ResponseEntity<Map<String, Long>> readMessage(@RequestBody ReadChatDto readChatDto) {
        messagingTemplate.convertAndSend(
                "/topic/room/" + readChatDto.getRoomId() + "/read",
                readChatDto
        );

        chatService.readMessage(readChatDto.getMessageId());
        return ResponseEntity.ok(Map.of("messageId", readChatDto.getMessageId()));
    }

    @PostMapping("/room/{id}")
    public ResponseEntity<List<ChatMessageDto>> getMessagesByRoom(@PathVariable("id") Long roomId, @RequestParam("userId") Long userId) {
        messagingTemplate.convertAndSend(
                "/topic/room/" + roomId + "/enter",
                userId
        );

        List<ChatMessageDto> messageDtos = chatService.findMessagesByRoom(roomId, userId);
        return ResponseEntity.ok(messageDtos);
    }

    @GetMapping("/room/{id}/check")
    public ResponseEntity<Map<String, Long>> checkChatRoomByUser(@PathVariable("id") Long roomId, @RequestParam("userId") Long userId) {
        chatService.checkChatRoomByUser(roomId, userId);
        return ResponseEntity.ok(Map.of("roomId", roomId));
    }

    @GetMapping("/room/user")
    public ResponseEntity<List<ChatRoomDto>> getChatRoomsByUser(@RequestParam("userId") Long userId) {
        List<ChatRoomDto> chatRooms = chatService.findChatRoomsByUser(userId);
        return ResponseEntity.ok(chatRooms);
    }

    @PostMapping("/room/{id}/disconnect")
    public ResponseEntity<Map<String, Long>> disconnectChatRoom(@PathVariable("id") Long roomId, @RequestParam("userId") Long userId) {
        chatService.disconnectChatRoom(roomId, userId);
        return ResponseEntity.ok(Map.of("roomId", roomId));
    }
}
