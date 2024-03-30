Future<void> main(List<String> arguments) async {
  print('Fetching data...');
  var data = await fetchDataFromServer();
  print('Data received: $data');

  print('Processing data...');
  var processedData = await processData(data);
  print('Data processed: $processedData');
}

Future<String> fetchDataFromServer() {
  return Future.delayed(Duration(seconds: 2), () => 'Sample Data');
}

Future<String> processData(String data) {
  return Future.delayed(Duration(seconds: 2), () => data.toUpperCase());
}
