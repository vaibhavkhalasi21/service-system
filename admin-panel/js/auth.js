async function login() {
  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value.trim();
  const error = document.getElementById("error");

  if (!email || !password) {
    error.innerText = "Email and password required";
    return;
  }

  try {
    const response = await fetch(`${BASE_URL}/admin/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ email, password })
    });

    if (!response.ok) {
      error.innerText = "Invalid credentials";
      return;
    }

    const data = await response.json();

    saveToken(data.token);

    window.location.href = "dashboard.html";

  } catch (err) {
    error.innerText = "Server error. Try again.";
  }
}
