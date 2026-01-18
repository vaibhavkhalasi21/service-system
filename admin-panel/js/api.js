// =============================================
// 🔗 BACKEND CONFIG
// =============================================
const BASE_URL = "http://172.20.253.37:5244/api";

// =============================================
// 🔐 AUTH TOKEN HELPERS
// =============================================
function saveToken(token) {
  localStorage.setItem("admin_token", token);
}

function getToken() {
  return localStorage.getItem("admin_token");
}

// =============================================
// 🚪 LOGOUT
// =============================================
function logout() {
  localStorage.removeItem("admin_token");
  window.location.href = "index.html";
}

// =============================================
// 🌙 DARK MODE (GLOBAL)
// =============================================
function toggleDarkMode() {
  document.body.classList.toggle("dark");
  localStorage.setItem(
    "darkMode",
    document.body.classList.contains("dark")
  );
}

// Apply dark mode on every page load
(function applyDarkMode() {
  const isDark = localStorage.getItem("darkMode") === "true";
  if (isDark) {
    document.body.classList.add("dark");
  }
})();

// =============================================
// 📐 COLLAPSIBLE SIDEBAR (GLOBAL)
// =============================================
function toggleSidebar() {
  document.body.classList.toggle("sidebar-collapsed");
  localStorage.setItem(
    "sidebarCollapsed",
    document.body.classList.contains("sidebar-collapsed")
  );
}

// Restore sidebar state on page load
(function applySidebarState() {
  const isCollapsed = localStorage.getItem("sidebarCollapsed") === "true";
  if (isCollapsed) {
    document.body.classList.add("sidebar-collapsed");
  }
})();

// =============================================
// 🔁 SIMPLE NAVIGATION HELPER
// =============================================
function goTo(page) {
  window.location.href = page;
}
