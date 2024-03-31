import 'dart:async';
import 'dart:isolate';

/// Generates a large list of numbers and calculates the squares of each number in parallel using isolates.
void main() async {
  final List<int> data = List.generate(
      1000000, (index) => index); // Generating a large list of numbers

  final List<int> squares = await calculateSquaresParallel(data);

  // Print the squared numbers
  print('Squared numbers: $squares');
}

/// Calculates the squares of each number in the given [data] list in parallel using isolates.
/// Returns a list of squared numbers.
Future<List<int>> calculateSquaresParallel(List<int> data) async {
  final ReceivePort mainReceivePort = ReceivePort();
  List<Isolate> isolates = [];

  final chunkSize = (data.length / 4).ceil(); // Dividing data into 4 chunks
  final chunks = List.generate(4, (index) {
    int start = index * chunkSize;
    int end = (index + 1) * chunkSize;
    return data.sublist(start, end);
  });

  for (var chunk in chunks) {
    final isolate = await Isolate.spawn(
        isolateFunction, {'data': chunk, 'sendPort': mainReceivePort.sendPort});
    isolates.add(isolate);
  }

  final squares = <int>[];
  await mainReceivePort.forEach((message) {
    if (message is List<int>) {
      squares.addAll(message);
      if (squares.length == data.length) {
        // All chunks have been processed
        print('All chunks processed!');
        mainReceivePort.close();
        // Terminate isolates
        for (var isolate in isolates) {
          isolate.kill();
        }
      }
    }
  });

  return squares;
}

/// The function executed by each isolate to calculate the squares of the numbers in the given [chunk].
/// The calculated squares are sent back to the main isolate using the [sendPort].
void isolateFunction(Map<String, dynamic> message) {
  final List<int> chunk = message['data'];
  final SendPort sendPort = message['sendPort'];
  final List<int> squaredChunk =
      chunk.map((number) => number * number).toList();
  sendPort.send(squaredChunk);
}
