import 'dart:isolate';

import 'package:dart_concurrency/dart_concurrency.dart';
import 'package:dart_concurrency/dart_isolates/echo_isolates_example.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });

  test('echoIsolate', () async {
    final result = await echoIsolate('Hello, World!');
    expect(result, 'Echo: Hello, World!');
  });

  test('createIsolate', () async {
    final sendPort = await createIsolate();
    expect(sendPort, isA<SendPort>());
  });

  test('echo', () async {
    final receivePort = ReceivePort();
    final sendPort = receivePort.sendPort;

    await Isolate.spawn(echo, sendPort);

    final echoPort = await receivePort.first;
    expect(echoPort, isA<SendPort>());

    final answer = ReceivePort();
    echoPort.send(['Hello from test', answer.sendPort]);

    final response = await answer.first;
    expect(response, 'Echo: Hello from test');
  });
}