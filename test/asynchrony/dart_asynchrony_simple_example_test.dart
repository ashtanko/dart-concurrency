import 'package:test/test.dart';
import 'package:dart_concurrency/asynchrony/dart_asynchrony_simple_example.dart';

void main() {
  test('fetchDataFromServer', () async {
    var data = await fetchDataFromServer();
    expect(data, 'Sample Data');
  });

  test('processData', () async {
    var processedData = await processData('Sample Data');
    expect(processedData, 'SAMPLE DATA');
  });
}
