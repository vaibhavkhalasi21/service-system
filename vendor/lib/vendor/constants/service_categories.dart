// ===============================
// SERVICE CATEGORY CONSTANTS
// ===============================

// UI-friendly list
const List<String> serviceCategories = [
  "Cleaning",
  "Plumber",
  "Electrician",
  "AC Repair",
  "Painter",
];

// ===============================
// STRING → ENUM INT (API)
// ===============================
int mapCategoryToEnum(String category) {
  switch (category) {
    case "Cleaning":
      return 1;
    case "Plumber":
      return 2;
    case "Electrician":
      return 3;
    case "AC Repair":
      return 4;
    case "Painter":
      return 5;
    default:
      throw Exception("Invalid category: $category");
  }
}

// ===============================
// ENUM INT → STRING (UI)
// ===============================
String mapEnumToCategory(int category) {
  switch (category) {
    case 1:
      return "Cleaning";
    case 2:
      return "Plumber";
    case 3:
      return "Electrician";
    case 4:
      return "AC Repair";
    case 5:
      return "Painter";
    default:
      return "Unknown";
  }
}
