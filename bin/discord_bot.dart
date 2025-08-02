import 'dart:io';
import 'dart:async'; // Still needed for the web server
import 'package:nyxx/nyxx.dart';

void main() async {
  String token = Platform.environment['TOKEN'] ?? '';
  if (token.isEmpty) {
    print("❌ ERROR: TOKEN environment variable not set.");
    return;
  }

  // Connect to Discord with the required intents
  final client = await Nyxx.connectGateway(
    token,
    GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
  );

  print("✅ Bot is online and ready for commands.");

  // Listen for new messages
  client.onMessageCreate.listen((event) async {
    // Ignore messages from other bots to prevent loops
    if (event.message.author.isBot) {
      return;
    }
    
    final content = event.message.content.trim();

    // Helper function to easily reply to messages
    Future<void> reply(String messageContent) async {
      await event.message.channel.sendMessage(MessageBuilder(
        content: messageContent,
        replyId: event.message.id,
      ));
    }

    // Command handling using if/else if statements
    if (content == 'ping') {
      await reply('pong!');
    } else if (content == '/commands') {
      // This replicates the "fall-through" behavior from your original JS code
      await reply('"Who is joelheath25? Who is joelheath24? Who is joelheath24? Who is Herobrine?"');
      await reply('The amazing and incredible personal assistant of joelheath24! Try asking: Who is Herobrine?');
    } else if (content == 'Who is joelheath25?') {
      await reply('The amazing and incredible personal assistant of joelheath24! Try asking: Who is Herobrine?');
    } else if (content == 'Who is joelheath24?') {
      await reply('The best content creator out there!');
    } else if (content == 'Who is joelheath23?') {
      await reply("He is surely joelheath24's arch-nemesis.");
    } else if (content == 'Who is Herobrine?') {
      await reply('Little is known on the origins of Herobrine but currently he seems to be working alongside joelheath23.');
    } else if (content == 'Who is joelinaheath24?') {
      await reply("As late as 23 Oct 2020 joelinaheath24 has been joelheath24's girlfriend, though she is yet to make another appearance in joelheath24's videos, so little is known on their current relationship status. However what is known is that the two are not married, and joelinaheath24 'got hasty' with changing her surname.");
    }
  });

  // Fake Web Server to Keep a hosting service like Render alive
  var port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  var server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print("🌍 Fake server running on port $port");
  await for (var request in server) {
    request.response
      ..write("Bot is running!")
      ..close();
  }
}