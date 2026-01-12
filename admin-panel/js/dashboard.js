// =============================================
// 🔒 AUTH GUARD
// =============================================
if (!getToken()) {
  window.location.href = "index.html";
}

// =============================================
// 🔢 ANIMATED COUNTER
// =============================================
function animateCounter(element, target) {
  let current = 0;
  const increment = Math.max(1, Math.floor(target / 40));
  const interval = setInterval(() => {
    current += increment;
    if (current >= target) {
      element.innerText = target;
      clearInterval(interval);
    } else {
      element.innerText = current;
    }
  }, 20);
}

// =============================================
// 📊 LOAD DASHBOARD STATS
// =============================================
async function loadDashboard() {
  try {
    const res = await fetch(`${BASE_URL}/admin/dashboard`, {
      headers: {
        Authorization: `Bearer ${getToken()}`
      }
    });

    if (!res.ok) {
      throw new Error("Failed to load dashboard");
    }

    const data = await res.json();

    animateCounter(vendorCount, data.vendors);
    animateCounter(workerCount, data.workers);
    animateCounter(bookingCount, data.bookings);

    loadCharts(data);

  } catch (err) {
    console.error(err);
    alert("Error loading dashboard data");
  }
}

// =============================================
// 📈 CHARTS
// =============================================
function loadCharts(data) {

  // Overview doughnut
  new Chart(document.getElementById("overviewChart"), {
    type: "doughnut",
    data: {
      labels: ["Vendors", "Workers", "Bookings"],
      datasets: [{
        data: [data.vendors, data.workers, data.bookings],
        backgroundColor: ["#42a5f5", "#66bb6a", "#ffa726"]
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { position: "bottom" }
      }
    }
  });

  // Booking trend (sample data)
  new Chart(document.getElementById("bookingChart"), {
    type: "bar",
    data: {
      labels: ["Mon", "Tue", "Wed", "Thu", "Fri"],
      datasets: [{
        label: "Bookings",
        data: [5, 9, 7, 12, 10],
        backgroundColor: "#1976d2",
        borderRadius: 6
      }]
    },
    options: {
      responsive: true,
      scales: {
        y: { beginAtZero: true }
      }
    }
  });
}

// =============================================
// 🚀 INIT
// =============================================
loadDashboard();
