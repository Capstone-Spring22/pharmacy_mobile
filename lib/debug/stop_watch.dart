void measureFunctionExecutionTime(Function function) {
  Stopwatch stopwatch = Stopwatch()..start(); // Create and start the stopwatch
  function(); // Call your function
  stopwatch.stop(); // Stop the stopwatch
  print(
      'Function execution time: ${stopwatch.elapsedMilliseconds} milliseconds'); // Print the elapsed time in milliseconds
}
