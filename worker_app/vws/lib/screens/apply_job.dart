import 'package:flutter/material.dart';
import 'package:vws/screens/payment_status.dart';

class ApplyJobScreen extends StatefulWidget {
  const ApplyJobScreen({super.key});

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final experienceController = TextEditingController();
  final expectedSalaryController = TextEditingController();

  String selectedAvailability = "Full Time";

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xffF2F3F7),
      body: Column(
        children: [
          /// 🔵 HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2563EB), Color(0xff1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: const [
                BackButton(color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Apply Job",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          /// 📄 FORM
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Personal Details"),

                    _inputField(
                      controller: nameController,
                      label: "Full Name",
                      icon: Icons.person,
                      validator: (v) =>
                      v!.isEmpty ? "Name is required" : null,
                    ),

                    _inputField(
                      controller: phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v!.isEmpty) return "Phone is required";
                        if (v.length < 10) return "Invalid phone number";
                        return null;
                      },
                    ),

                    _sectionTitle("Work Details"),

                    _inputField(
                      controller: experienceController,
                      label: "Experience (years)",
                      icon: Icons.work,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                      v!.isEmpty ? "Experience required" : null,
                    ),

                    _inputField(
                      controller: expectedSalaryController,
                      label: "Expected Salary (₹)",
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                      v!.isEmpty ? "Salary required" : null,
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      "Availability",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedAvailability,
                        decoration:
                        const InputDecoration(border: InputBorder.none),
                        items: const [
                          DropdownMenuItem(
                              value: "Full Time", child: Text("Full Time")),
                          DropdownMenuItem(
                              value: "Part Time", child: Text("Part Time")),
                          DropdownMenuItem(
                              value: "Freelance", child: Text("Freelance")),
                        ],
                        onChanged: (v) =>
                            setState(() => selectedAvailability = v!),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// 🚀 APPLY BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const PaymentStatusScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Apply Job",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 🔹 INPUT FIELD
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }

  /// 🔹 SECTION TITLE
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
