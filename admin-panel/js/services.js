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
      let statusClass = "status-blocked";
      if (s.status === "Active") statusClass = "status-active";
      if (s.status === "Completed") statusClass = "status-completed";

      table.innerHTML += `
        <tr>
          <td>${s.id}</td>

          <td>
            <strong>${s.serviceName}</strong><br/>
            ${s.imageUrl
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
// ➕ CREATE SERVICE (FILE UPLOAD)
// =============================================
async function createService() {
  const name = document.getElementById("sName").value;
  const category = document.getElementById("sCategory").value;
  const price = document.getElementById("sPrice").value;
  const imageFile = document.getElementById("sImage").files[0];

  if (!name || !price || !imageFile) {
    alert("Please fill all fields and select an image");
    return;
  }

  const formData = new FormData();
  formData.append("serviceName", name);
  formData.append("category", category);
  formData.append("price", price);
  formData.append("image", imageFile);

  try {
    const res = await fetch(`${BASE_URL}/admin/services`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${getToken()}`
      },
      body: formData
    });

    if (res.ok) {
      alert("Service added");
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
// NOTE: Image update should be a separate flow
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
}

// =============================================
// 🚀 INIT
// =============================================
loadServices();
