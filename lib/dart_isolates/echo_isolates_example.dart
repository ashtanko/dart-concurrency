import 'dart:isolate';

void main() async {
  echoIsolate('Hello, World!').then((value) => print(value));
}

Future<String> echoIsolate(String message) async {
  final sendPort = await createIsolate();

  final answer = ReceivePort();

  // Send a message to the isolate.
  sendPort.send([message, answer.sendPort]);

  // Wait for the response.
  final response = await answer.first;

  return response;
}

Future<SendPort> createIsolate() async {
  // Create a receive port to receive messages from the isolate.
  final receivePort = ReceivePort();

  // Create the isolate.
  await Isolate.spawn(echo, receivePort.sendPort);

  // The 'echo' isolate sends its SendPort as the first message.
  final sendPort = await receivePort.first;

  return sendPort;
}

// The entry point for the isolate.
void echo(SendPort sendPort) {
  // Open the ReceivePort for incoming messages.
  final port = ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);

  port.listen((message) {
    // Parse the message.
    final String data = message[0];
    final SendPort replyTo = message[1];

    // Send a message back.
    replyTo.send('Echo: $data');
  });
}
