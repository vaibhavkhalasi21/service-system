// 🔒 AUTH GUARD
if (!getToken()) {
  window.location.href = "index.html";
}

// 🔙 Back button
function goBack() {
  window.location.href = "dashboard.html";
}

// 📦 Load applications
async function loadApplications() {
  try {
    const res = await fetch(`${BASE_URL}/admin/applications`, {
      method: "GET",
      headers: {
        "Authorization": `Bearer ${getToken()}`,
        "Content-Type": "application/json"
      }
    });

    if (!res.ok) {
      alert("Failed to fetch applications");
      return;
    }

    const apps = await res.json();
    const table = document.getElementById("applicationsTable");

    table.innerHTML = "";

    apps.forEach(a => {
      table.innerHTML += `
        <tr>
          <td>${a.id}</td>
          <td>${a.serviceName}</td>
          <td>${a.vendorName}</td>
          <td>${a.workerName ?? "-"}</td>
          <td>${a.status}</td>
          <td>${a.paymentStatus}</td>
          <td>${new Date(a.createdAt).toLocaleDateString()}</td>
        </tr>
      `;
    });

  } catch {
    alert("Server error while loading applications");
  }
}

// 🚀 Initial load
loadApplications();
