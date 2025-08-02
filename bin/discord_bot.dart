import 'dart:io';
import 'dart:async';
import 'package:nyxx/nyxx.dart';

class Command {
  final String response;
  final String formattedCommand;

  Command(this.response, this.formattedCommand);
}

String normalizeText(String input) {
  return input
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '');
}

final Map<String, Command> commands = {
  'ping': Command('pong!', 'ping'),
  'who is joelheath25': Command(
    'The amazing and incredible personal assistant of joelheath24! Try asking: Who is Herobrine?',
    'Who is joelheath25?',
  ),
  'who is joelheath24': Command(
    'The best content creator out there!',
    'Who is joelheath24?',
  ),
  'who is joelheath23': Command(
    "He is surely joelheath24's arch-nemesis.",
    'Who is joelheath23?',
  ),
  'who is herobrine': Command(
    'Little is known on the origins of Herobrine but currently he seems to be working alongside joelheath23.',
    'Who is Herobrine?',
  ),
  'who is joelinaheath24': Command(
    "joelinaheath24 featured as joelheath24's girlfriend in his 20 subscriber special, though she has yet to make another appearance in joelheath24's videos. Little is known on their current relationship status, however it is known that the two are not married, joelinaheath24 *got hasty* with changing her surname.",
    'Who is joelinaheath24?',
  ),
};

void main() async {
  String token = Platform.environment['TOKEN'] ?? '';
  if (token.isEmpty) {
    print("❌ ERROR: TOKEN environment variable not set.");
    return;
  }

  final client = await Nyxx.connectGateway(
    token,
    GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
  );

  print("✅ Bot is online and ready for commands.");

  client.onMessageCreate.listen((event) async {
    final normalizedContent = normalizeText(event.message.content);

    Future<void> reply(String messageContent) async {
      await event.message.channel.sendMessage(MessageBuilder(
        content: messageContent,
        replyId: event.message.id,
      ));
    }
    
    if (normalizedContent == '/commands') {
      final commandList = commands.values.map((cmd) => '- ${cmd.formattedCommand}').join('\n');
      await reply('Available commands:\n- /commands\n$commandList');

    } else if (commands.containsKey(normalizedContent)) {
      final command = commands[normalizedContent]!;
      await reply(command.response);
    }
  });

  var port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  var server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print("🌍 Fake server running on port $port");
  await for (var request in server) {
    request.response
      ..write("Bot is running!")
      ..close();
  }
}