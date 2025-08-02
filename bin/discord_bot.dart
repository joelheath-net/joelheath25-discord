import 'dart:io';
import 'dart:async';
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

  // Activities to cycle through
  final activities = [
    ActivityBuilder(name: 'joelheath24 videos', type: ActivityType.watching),
    ActivityBuilder(name: 'JRAJYM theme', type: ActivityType.listening),
    ActivityBuilder(name: 'joelheath.net', type: ActivityType.playing),
  ];
  int currentActivity = 0;

  // Function to update presence
  void updateActivity() {
    client.updatePresence(PresenceBuilder(
      status: Status.online,
      isAfk: false,
      activities: [activities[currentActivity]], // PresenceBuilder expects a List
    ));
  }

  // Set the initial activity
  updateActivity();

  // Cycle through activities every 10 seconds
  Timer.periodic(const Duration(seconds: 10), (timer) {
    currentActivity = (currentActivity + 1) % activities.length;
    updateActivity();
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
      await reply('Available commands:\n- ping\n- /commands\n- Who is joelheath25?\n- Who is joelheath24?\n- Who is joelheath23?\n- Who is Herobrine?\n- Who is joelinaheath24?');
    } else if (content == 'Who is joelheath25?') {
      await reply('The amazing and incredible personal assistant of joelheath24! Try asking: Who is Herobrine?');
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