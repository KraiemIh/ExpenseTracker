import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String webhookUrl = 'https://iheb06.app.n8n.cloud/webhook-test/chat-financial-assistant';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(webhookUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['output'] ?? 'No response from AI';
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error communicating with AI: $e');
    }
  }
}