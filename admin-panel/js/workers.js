// 🔒 AUTH GUARD
if (!getToken()) {
  window.location.href = "index.html";
}

// 🔙 Back
function goBack() {
  window.location.href = "dashboard.html";
}

// ===================== LOAD WORKERS =====================
async function loadWorkers() {
  try {
    const res = await fetch(`${BASE_URL}/admin/workers`, {
      headers: {
        "Authorization": `Bearer ${getToken()}`,
        "Content-Type": "application/json"
      }
    });

    if (!res.ok) {
      alert("Failed to fetch workers");
      return;
    }

    const workers = await res.json();
    const table = document.getElementById("workerTable");
    table.innerHTML = "";

    workers.forEach(w => {
      table.innerHTML += `
        <tr>
          <td>${w.id}</td>
          <td>${w.name}</td>
          <td>${w.email}</td>
          <td class="${w.isActive ? "status-active" : "status-blocked"}">
            ${w.isActive ? "Active" : "Blocked"}
          </td>
          <td>
            <button onclick="toggleWorker(${w.id}, ${w.isActive})">
              ${w.isActive ? "Block" : "Unblock"}
            </button>
            <button onclick="editWorker(${w.id})">Edit</button>
            <button onclick="deleteWorker(${w.id})">Delete</button>
          </td>
        </tr>
      `;
    });

  } catch {
    alert("Server error while loading workers");
  }
}

// ===================== CREATE WORKER =====================
async function createWorker() {
  const data = {
    name: wName.value,
    email: wEmail.value,
    phone: wPhone.value,
    Category: wCategory.value,
    address: wAddress.value,
    password: wPassword.value
  };

  const res = await fetch(`${BASE_URL}/admin/workers`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${getToken()}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data)
  });

  if (res.ok) {
    alert("Worker created");
    clearForm();
    loadWorkers();
  } else {
    alert("Failed to create worker");
  }
}

// ===================== UPDATE WORKER =====================
async function editWorker(id) {
  const name = prompt("Enter name:");
  const phone = prompt("Enter phone:");
  const Category = prompt("Enter Category:");
  const address = prompt("Enter address:");

  if (!name || !phone) return;

  const res = await fetch(`${BASE_URL}/admin/workers/${id}`, {
    method: "PUT",
    headers: {
      "Authorization": `Bearer ${getToken()}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ name, phone, skill, address })
  });

  if (res.ok) {
    loadWorkers();
  } else {
    alert("Update failed");
  }
}

// ===================== DELETE WORKER =====================
async function deleteWorker(id) {
  if (!confirm("Disable this worker?")) return;

  const res = await fetch(`${BASE_URL}/admin/workers/${id}`, {
    method: "DELETE",
    headers: {
      "Authorization": `Bearer ${getToken()}`
    }
  });

  if (res.ok) {
    loadWorkers();
  } else {
    alert("Delete failed");
  }
}

// ===================== BLOCK / UNBLOCK =====================
async function toggleWorker(id, isActive) {
  if (!confirm(`Are you sure you want to ${isActive ? "block" : "unblock"} this worker?`))
    return;

  const res = await fetch(
    `${BASE_URL}/admin/workers/${id}/status?isActive=${!isActive}`,
    {
      method: "PUT",
      headers: {
        "Authorization": `Bearer ${getToken()}`
      }
    }
  );

  if (res.ok) {
    loadWorkers();
  } else {
    alert("Status update failed");
  }
}

// ===================== HELPERS =====================
function clearForm() {
  wName.value = "";
  wEmail.value = "";
  wPhone.value = "";
  wCategory.value = "";
  wAddress.value = "";
  wPassword.value = "";
}

// 🚀 Init
loadWorkers();
