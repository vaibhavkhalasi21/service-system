// 🔒 AUTH GUARD
if (!getToken()) {
  window.location.href = "index.html";
}

// 🔙 Back button
function goBack() {
  window.location.href = "dashboard.html";
}

// ===================== LOAD VENDORS =====================
async function loadVendors() {
  try {
    const res = await fetch(`${BASE_URL}/admin/vendors`, {
      method: "GET",
      headers: {
        "Authorization": `Bearer ${getToken()}`,
        "Content-Type": "application/json"
      }
    });

    if (!res.ok) {
      alert("Failed to fetch vendors");
      return;
    }

    const vendors = await res.json();
    const table = document.getElementById("vendorTable");
    table.innerHTML = "";

    vendors.forEach(v => {
      table.innerHTML += `
        <tr>
          <td>${v.id}</td>
          <td>${v.name}</td>
          <td>${v.email}</td>
          <td class="${v.isActive ? "status-active" : "status-blocked"}">
            ${v.isActive ? "Active" : "Blocked"}
          </td>
          <td>
            <button onclick="toggleVendor(${v.id}, ${v.isActive})">
              ${v.isActive ? "Block" : "Unblock"}
            </button>
            <button onclick="editVendor(${v.id})">Edit</button>
            <button onclick="deleteVendor(${v.id})">Delete</button>
          </td>
        </tr>
      `;
    });

  } catch {
    alert("Server error while loading vendors");
  }
}

// ===================== CREATE VENDOR =====================
async function createVendor() {
  const data = {
    name: vName.value,
    email: vEmail.value,
    phone: vPhone.value,
    serviceType: vService.value,
    address: vAddress.value,
    password: vPassword.value
  };

  const res = await fetch(`${BASE_URL}/admin/vendors`, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${getToken()}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data)
  });

  if (res.ok) {
    alert("Vendor created");
    clearForm();
    loadVendors();
  } else {
    alert("Failed to create vendor");
  }
}

// ===================== UPDATE VENDOR =====================
async function editVendor(id) {
  const name = prompt("Enter new name:");
  const phone = prompt("Enter phone:");
  const serviceType = prompt("Enter service type:");
  const address = prompt("Enter address:");

  if (!name || !phone) return;

  const res = await fetch(`${BASE_URL}/admin/vendors/${id}`, {
    method: "PUT",
    headers: {
      "Authorization": `Bearer ${getToken()}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ name, phone, serviceType, address })
  });

  if (res.ok) {
    loadVendors();
  } else {
    alert("Update failed");
  }
}

// ===================== DELETE VENDOR (SOFT) =====================
async function deleteVendor(id) {
  if (!confirm("Disable this vendor?")) return;

  const res = await fetch(`${BASE_URL}/admin/vendors/${id}`, {
    method: "DELETE",
    headers: {
      "Authorization": `Bearer ${getToken()}`
    }
  });

  if (res.ok) {
    loadVendors();
  } else {
    alert("Failed to delete vendor");
  }
}

// ===================== BLOCK / UNBLOCK =====================
async function toggleVendor(id, isActive) {
  if (!confirm(`Are you sure you want to ${isActive ? "block" : "unblock"} this vendor?`))
    return;

  const res = await fetch(
    `${BASE_URL}/admin/vendors/${id}/status?isActive=${!isActive}`,
    {
      method: "PUT",
      headers: {
        "Authorization": `Bearer ${getToken()}`
      }
    }
  );

  if (res.ok) {
    loadVendors();
  } else {
    alert("Failed to update status");
  }
}

// ===================== HELPERS =====================
function clearForm() {
  vName.value = "";
  vEmail.value = "";
  vPhone.value = "";
  vService.value = "";
  vAddress.value = "";
  vPassword.value = "";
}

// 🚀 Initial load
loadVendors();
