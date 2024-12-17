package com.daepa.minimo.api;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.dto.ReadChatDto;
import com.daepa.minimo.service.ChatService;
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

    @GetMapping("/room/{id}/check")
    public ResponseEntity<Map<String, Long>> checkChatRoomByUser(@PathVariable("id") Long roomId, @RequestParam("userId") Long userId) {
        Long checkedRoomId = chatService.checkChatRoomByUser(roomId, userId);
        return ResponseEntity.ok(Map.of("id", checkedRoomId));
    }

    @GetMapping("/room/user")
    public ResponseEntity<List<ChatRoomDto>> getChatRoomsByUser(@RequestParam("userId") Long userId) {
        List<ChatRoomDto> chatRooms = chatService.findChatRoomsByUser(userId);
        return ResponseEntity.ok(chatRooms);
    }

    @PostMapping("/message/send")
    public ResponseEntity<Map<String, Long>> sendMessage(@RequestBody ChatMessageDto chatMessageDto) {
        ChatMessage chatMessage = chatService.sendMessage(chatMessageDto.getRoomId(), chatMessageDto.toChatMessage());

        messagingTemplate.convertAndSend(
                "/topic/room/" + chatMessageDto.getRoomId(),
                ChatMessageDto.fromChatMessage(chatMessage)
        );

        return ResponseEntity.ok(Map.of("id", chatMessage.getId()));
    }

    @PostMapping("/message/read")
    public ResponseEntity<Map<String, Long>> readMessage(@RequestBody ReadChatDto readChatDto) {
        messagingTemplate.convertAndSend(
                "/topic/room/" + readChatDto.getRoomId() + "/read",
                readChatDto
        );

        chatService.readMessage(readChatDto.getMessageId());
        return ResponseEntity.ok(Map.of("id", readChatDto.getMessageId()));
    }

    @PostMapping("/room/{id}")
    public ResponseEntity<List<ChatMessageDto>> readMessages(@PathVariable("id") Long roomId, @RequestParam("userId") Long userId) {
        messagingTemplate.convertAndSend(
                "/topic/room/" + roomId + "/enter",
                userId
        );

        List<ChatMessageDto> messageDtos = chatService.readMessages(roomId, userId);
        return ResponseEntity.ok(messageDtos);
    }

    @PostMapping("/room/{id}/disconnect")
    public ResponseEntity<Map<String, Long>> disconnectChatRooms(@PathVariable("id") Long roomId, @RequestParam("userId") Long userId) {
        Long disconnectRoomId = chatService.disconnectChatRoom(roomId, userId);
        return ResponseEntity.ok(Map.of("id", disconnectRoomId));
    }
}
