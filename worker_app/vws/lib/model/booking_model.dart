class Booking {
  final String jobTitle;
  final String location;
  final String date;
  final String status; // Pending, Accepted, Rejected

  Booking({
    required this.jobTitle,
    required this.location,
    required this.date,
    required this.status,
  });
}
