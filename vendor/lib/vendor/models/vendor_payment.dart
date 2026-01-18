class VendorPayment {
  final int id;
  final int amount;
  final String status;              // SUCCESS
  final String? paymentMethod;      // Cash / Online (Demo) | null
  final String? escrowStatus;       // HELD / RELEASED | null
  final DateTime createdAt;
  final DateTime? releasedAt;

  VendorPayment({
    required this.id,
    required this.amount,
    required this.status,
    this.paymentMethod,
    this.escrowStatus,
    required this.createdAt,
    this.releasedAt,
  });

  factory VendorPayment.fromJson(Map<String, dynamic> json) {
    return VendorPayment(
      id: json['id'] as int,
      amount: (json['amount'] as num).toInt(),
      status: json['status'] as String,

      // ✅ NULL SAFE
      paymentMethod: json['paymentMethod'] as String?,
      escrowStatus: json['escrowStatus'] as String?,

      createdAt: DateTime.parse(json['createdAt'] as String),

      releasedAt: json['releasedAt'] != null
          ? DateTime.parse(json['releasedAt'] as String)
          : null,
    );
  }
}
