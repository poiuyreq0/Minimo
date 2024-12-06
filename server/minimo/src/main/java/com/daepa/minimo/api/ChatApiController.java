package com.daepa.minimo.api;

import com.daepa.minimo.domain.ChatMessage;
import com.daepa.minimo.dto.ChatMessageDto;
import com.daepa.minimo.dto.ChatRoomDto;
import com.daepa.minimo.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/chat")
public class ChatApiController {
    private final ChatService chatService;

    @GetMapping("/room/{id}")
    public ResponseEntity<List<ChatMessageDto>> getMessages(@PathVariable("id") Long roomId) {
        List<ChatMessage> messages = chatService.findMessages(roomId);
        List<ChatMessageDto> messageDtos = messages.stream()
                .map(ChatMessageDto::fromChatMessage)
                .toList();
        return ResponseEntity.ok(messageDtos);
    }

    @GetMapping("/room/letter")
    public ResponseEntity<Map<String, Long>> getchatRoomIdByLetterId(@RequestParam("letterId") Long letterId) {
        Long chatRoomId = chatService.findChatRoomIdByLetterId(letterId);
        return ResponseEntity.ok(Map.of("id", chatRoomId));
    }

    @GetMapping("/rooms")
    public ResponseEntity<List<ChatRoomDto>> getChatRooms(@RequestParam("userId") Long userId) {
        List<ChatRoomDto> chatRooms = chatService.findChatRooms(userId);

        System.out.println("getChatRooms: " + chatRooms);

        return ResponseEntity.ok(chatRooms);
    }
}
