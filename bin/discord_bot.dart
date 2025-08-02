import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:nyxx/nyxx.dart';

// A simple class to hold activity data
class BotActivity {
  final ActivityType type;
  final String message;

  // Removed 'const' from constructor for safety with final list
  BotActivity(this.type, this.message);
}

void main() async {
  // FIX 1: Changed from 'const' to 'final'. This resolves the 'playing' member not found error.
  final activities = [
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
    GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
  );

  print("✅ Bot is online");

  // Set initial activity and start rotation timer
  Timer.periodic(const Duration(seconds: 10), (timer) {
    final random = Random();
    final activity = activities[random.nextInt(activities.length)];

    client.gateway.updatePresence(PresenceBuilder(
      // FIX 2: Changed 'activity' to 'activities' and wrapped the ActivityBuilder in a list.
      activities: [
        ActivityBuilder(
          name: activity.message,
          type: activity.type,
          url: activity.type == ActivityType.streaming ? 'https://www.youtube.com/@joelheath24' : null,
        ),
      ],
      status: CurrentUserStatus.online,
      // FIX 3: Added the new required parameter 'isAfk'.
      isAfk: false,
    ));
  });

  // Listen for new messages
  client.onMessageCreate.listen((event) async {
    final content = event.message.content.trim();

    Future<void> reply(String messageContent) async {
      await event.message.channel.sendMessage(MessageBuilder(
        content: messageContent,
        replyId: event.message.id,
      ));
    }

    if (content == 'ping') {
      await reply('pong!');
    } else if (content == '/commands') {
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