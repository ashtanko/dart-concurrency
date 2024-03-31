import 'package:dart_concurrency/dart_isolates/parallel_data_processing/large_list_of_numbers.dart';
import 'package:test/test.dart';

void main() {
  test('calculateSquaresParallel', () async {
    final List<int> data = List.generate(1000000, (index) => index);
    final List<int> squares = await calculateSquaresParallel(data);

    // Verify that the length of the squares list is the same as the data list
    expect(squares.length, data.length);

    // Verify that each element in the squares list is the square of the corresponding element in the data list
    for (int i = 0; i < data.length; i++) {
      expect(
          BigInt.from(squares[i]), BigInt.from(data[i]) * BigInt.from(data[i]));
    }
  });
}
