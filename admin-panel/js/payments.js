// 🔒 AUTH GUARD
if (!getToken()) {
  window.location.href = "index.html";
}

// 🔙 Back
function goBack() {
  window.location.href = "dashboard.html";
}

// 💳 Load payments
async function loadPayments() {
  try {
    const res = await fetch(`${BASE_URL}/admin/payments`, {
      headers: {
        "Authorization": `Bearer ${getToken()}`
      }
    });

    if (!res.ok) {
      alert("Failed to load payments");
      return;
    }

    const payments = await res.json();
    const table = document.getElementById("paymentsTable");
    table.innerHTML = "";

    payments.forEach(p => {
      table.innerHTML += `
        <tr>
          <td>${p.applicationId}</td>
          <td>${p.vendorName}</td>
          <td>${p.workerName}</td>
          <td>${p.paymentMethod}</td>
          <td class="${p.paymentStatus === "Paid" ? "payment-paid" : "payment-pending"}">
            ${p.paymentStatus}
          </td>
          <td class="${p.status === "Completed" ? "status-completed" : "status-pending"}">
            ${p.status}
          </td>
          <td>${new Date(p.createdAt).toLocaleDateString()}</td>
        </tr>
      `;
    });

  } catch (err) {
    alert("Server error while loading payments");
  }
}

// 🚀 Initial load
loadPayments();
