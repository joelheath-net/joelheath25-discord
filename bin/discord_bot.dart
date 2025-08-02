import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:nyxx/nyxx.dart';

// A simple class to hold activity data
class BotActivity {
  final ActivityType type;
  final String message;

  const BotActivity(this.type, this.message);
}

void main() async {
  // A list of activities for the bot to rotate through
  const activities = [
    BotActivity(ActivityType.playing, 'joelheath.net'),
    BotActivity(ActivityType.watching, 'joelheath24 videos'),
    BotActivity(ActivityType.listening, 'JRAJYM Theme'),
    BotActivity(ActivityType.streaming, 'joelheath24 videos'),
  ];

  String token = Platform.environment['TOKEN'] ?? '';
  if (token.isEmpty) {
    print("❌ ERROR: TOKEN environment variable not set.");
    return;
  }

  // Connect to Discord
  final client = await Nyxx.connectGateway(
    token,
    GatewayIntents.allUnprivileged | GatewayIntents.messageContent, // messageContent intent is required to read messages
  );

  print("✅ Bot is online");

  // Set initial activity and start rotation timer
  Timer.periodic(const Duration(seconds: 10), (timer) {
    final random = Random();
    // Select a random activity from the list
    final activity = activities[random.nextInt(activities.length)];

    client.gateway.updatePresence(PresenceBuilder(
      activity: ActivityBuilder(
        name: activity.message,
        type: activity.type,
        // Streaming status requires a URL to be shown correctly
        url: activity.type == ActivityType.streaming ? 'https://www.youtube.com/joelheath24' : null,
      ),
      status: CurrentUserStatus.online,
    ));
  });


  // Listen for new messages
  client.onMessageCreate.listen((event) async {
    final content = event.message.content.trim();

    // Helper function to easily reply to messages
    Future<void> reply(String messageContent) async {
      await event.message.channel.sendMessage(MessageBuilder(
        content: messageContent,
        replyId: event.message.id,
      ));
    }

    // Command handling
    if (content == 'ping') {
      await reply('pong!');
    } else if (content == '/commands') {
      await reply('"Who is joelheath25?", "Who is joelheath24?", "Who is joelheath23?", "Who is Herobrine?"');
    } else if (content == 'Who is joelheath25?') {
      await reply('The amazing and incredible personal assistant of joelheath24! Try asking "Who is Herobrine?"');
    } else if (content == 'Who is joelheath24?') {
      await reply('The best content creator out there!');
    } else if (content == 'Who is joelheath23?') {
      await reply("He is surely joelheath24's arch-nemesis.");
    } else if (content == 'Who is Herobrine?') {
      await reply('Little is known on the origins of Herobrine but currently he seems to be working alongside joelheath23.');
    } else if (content == 'Who is joelinaheath24?') {
      await reply("joelinaheath24 featured as joelheath24's girlfriend in his 20 subscriber special, though she has yet to make another appearance in joelheath24's videos. Little is known on their current relationship status, however it is known that the two are not married, joelinaheath24 *got hasty* with changing her surname.");
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