class BookingRequest {
  final String workerName;
  final String serviceName;
  final int price;
  final String date;
  final String time;

  BookingRequest({
    required this.workerName,
    required this.serviceName,
    required this.price,
    required this.date,

    required this.time,
  });
}