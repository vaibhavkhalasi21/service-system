// ===============================
// SERVICE CATEGORY CONSTANTS
// ===============================

// 🔥 UI-friendly list (USED BY DROPDOWNS)
// Order does NOT matter, values do
const List<String> serviceCategories = [
  "Cleaning",
  "Plumber",
  "Electrician",
  "AC Repair",
  "Painter",
];

// ===============================
// STRING → ENUM INT (API → BACKEND)
// ===============================
// MUST match backend enum values exactly
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
    // 🔥 FAIL FAST (helps catch bugs early)
      throw Exception("Invalid category string: $category");
  }
}

// ===============================
// ENUM INT → STRING (BACKEND → UI)
// ===============================
// MUST match backend enum values exactly
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

  // 🧯 OLD / BAD DATA SAFETY
    case 0:
      return "Unknown (Old Data)";

    default:
      return "Unknown";
  }
}

// ===============================
// SAFETY HELPERS (OPTIONAL BUT RECOMMENDED)
// ===============================

// ✅ Check if enum value is valid
bool isValidCategoryEnum(int value) {
  return value >= 1 && value <= 5;
}

// ✅ Safe enum → string (never crashes UI)
String safeEnumToCategory(int value) {
  return isValidCategoryEnum(value)
      ? mapEnumToCategory(value)
      : "Unknown (Old Data)";
}
