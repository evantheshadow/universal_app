class ResponseInformation<T> {
  final bool isSuccessful;
  final int statusCode;
  final T data;
  final String errorDescription;

  ResponseInformation(
    this.isSuccessful,
    this.statusCode,
    this.data,
    this.errorDescription,
  );
}
