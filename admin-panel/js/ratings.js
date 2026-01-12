// 🔒 AUTH GUARD
if (!getToken()) {
  window.location.href = "index.html";
}

// 🔙 Back
function goBack() {
  window.location.href = "dashboard.html";
}

// ⭐ Load ratings
async function loadRatings() {
  try {
    const res = await fetch(`${BASE_URL}/admin/ratings`, {
      headers: {
        "Authorization": `Bearer ${getToken()}`
      }
    });

    if (!res.ok) {
      alert("Failed to load ratings");
      return;
    }

    const ratings = await res.json();
    const table = document.getElementById("ratingsTable");
    table.innerHTML = "";

    ratings.forEach(r => {
      table.innerHTML += `
        <tr>
          <td>${r.applicationId}</td>
          <td>${r.serviceName}</td>
          <td>${r.vendorName}</td>
          <td>${r.workerName}</td>
          <td class="rating">${r.vendorRating ?? "-"}</td>
          <td class="rating">${r.workerRating ?? "-"}</td>
          <td>${new Date(r.createdAt).toLocaleDateString()}</td>
        </tr>
      `;
    });

  } catch (err) {
    alert("Server error while loading ratings");
  }
}

// 🚀 Initial load
loadRatings();
