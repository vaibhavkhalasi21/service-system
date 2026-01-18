// ===============================
// SERVICE CATEGORY CONSTANTS
// ===============================

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
  switch (category.trim().toLowerCase()) {
    case "cleaning":
      return 1;
    case "plumber":
      return 2;
    case "electrician":
      return 3;
    case "ac repair":
      return 4;
    case "painter":
      return 5;
    default:
      return 0; // OLD / UNKNOWN
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
