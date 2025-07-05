// frontend/script.js

// Replace with your real API endpoint after terraform apply
const API_URL = "https://1leelherld.execute-api.us-west-2.amazonaws.com/prod/visitors";

async function updateCounter() {
  try {
    const response = await fetch(API_URL);
    const { count } = await response.json();
    document.getElementById("visits").innerText = count;
  } catch (err) {
    console.error("Failed to fetch visitor count:", err);
    document.getElementById("visits").innerText = "Error";
  }
}

window.addEventListener("DOMContentLoaded", updateCounter);