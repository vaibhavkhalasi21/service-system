// =============================================
// 🔒 AUTH GUARD
// =============================================
if (!getToken()) {
  window.location.href = "index.html";
}

// =============================================
// 📦 LOAD SERVICES
// =============================================
async function loadServices() {
  try {
    const res = await fetch(`${BASE_URL}/admin/services`, {
      headers: {
        Authorization: `Bearer ${getToken()}`
      }
    });

    if (!res.ok) {
      alert("Failed to fetch services");
      return;
    }

    const services = await res.json();
    const table = document.getElementById("serviceTable");
    table.innerHTML = "";

    services.forEach(s => {
      const statusClass =
        s.status === "Active" ? "status-active" : "status-blocked";

      table.innerHTML += `
        <tr>
          <td>${s.id}</td>

          <td>
            <strong>${s.serviceName}</strong><br/>
            ${
              s.imageUrl
                ? `<img src="http://localhost:5244${s.imageUrl}"
                       width="60"
                       style="margin-top:6px;border-radius:6px;">`
                : ""
            }
          </td>

          <td>${s.category ?? "-"}</td>
          <td>₹${s.price}</td>

          <td class="${statusClass}">
            ${s.status}
          </td>

          <td>
            <button onclick="editService(${s.id})">Edit</button>
            <button onclick="deleteService(${s.id})">Disable</button>
          </td>
        </tr>
      `;
    });
  } catch (err) {
    console.error(err);
    alert("Server error while loading services");
  }
}

// =============================================
// ➕ CREATE SERVICE (MATCHES ServiceCreateDto)
// =============================================
async function createService() {
  const name = document.getElementById("sName").value;
  const category = document.getElementById("sCategory").value;
  const price = document.getElementById("sPrice").value;
  const image = document.getElementById("sImage").files[0];

  if (!name || !category || !price) {
    alert("Please fill all required fields");
    return;
  }

  const formData = new FormData();
  formData.append("serviceName", name);
  formData.append("category", category);
  formData.append("price", price);
  formData.append("serviceDateTime", new Date().toISOString());

  // Optional fields (DTO supported)
  const addressEl = document.getElementById("sAddress");
  const latEl = document.getElementById("sLatitude");
  const lngEl = document.getElementById("sLongitude");

  if (addressEl && addressEl.value)
    formData.append("address", addressEl.value);

  if (latEl && latEl.value)
    formData.append("latitude", latEl.value);

  if (lngEl && lngEl.value)
    formData.append("longitude", lngEl.value);

  if (image) {
    formData.append("image", image);
  }

  try {
    const res = await fetch(`${BASE_URL}/admin/services`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${getToken()}`
      },
      body: formData
    });

    if (res.ok) {
      alert("Service added successfully");
      clearForm();
      loadServices();
    } else {
      alert("Failed to add service");
    }
  } catch (err) {
    console.error(err);
    alert("Server error while adding service");
  }
}

// =============================================
// ✏️ UPDATE SERVICE (TEXT ONLY)
// =============================================
async function editService(id) {
  const serviceName = prompt("Service name:");
  const category = prompt("Category:");
  const price = prompt("Price:");

  if (!serviceName || !price) return;

  try {
    const res = await fetch(`${BASE_URL}/admin/services/${id}`, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${getToken()}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        serviceName,
        category,
        price: Number(price)
      })
    });

    if (res.ok) {
      loadServices();
    } else {
      alert("Update failed");
    }
  } catch (err) {
    console.error(err);
    alert("Server error while updating service");
  }
}

// =============================================
// ❌ DISABLE SERVICE (SOFT DELETE)
// =============================================
async function deleteService(id) {
  if (!confirm("Disable this service?")) return;

  try {
    const res = await fetch(`${BASE_URL}/admin/services/${id}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${getToken()}`
      }
    });

    if (res.ok) {
      loadServices();
    } else {
      alert("Failed to disable service");
    }
  } catch (err) {
    console.error(err);
    alert("Server error while disabling service");
  }
}

// =============================================
// 🧹 HELPERS
// =============================================
function clearForm() {
  document.getElementById("sName").value = "";
  document.getElementById("sCategory").value = "";
  document.getElementById("sPrice").value = "";
  document.getElementById("sImage").value = "";

  const addressEl = document.getElementById("sAddress");
  const latEl = document.getElementById("sLatitude");
  const lngEl = document.getElementById("sLongitude");

  if (addressEl) addressEl.value = "";
  if (latEl) latEl.value = "";
  if (lngEl) lngEl.value = "";
}

// =============================================
// 🚀 INIT
// =============================================
loadServices();
