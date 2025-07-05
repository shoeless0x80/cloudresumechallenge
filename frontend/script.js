// script.js

// Visitor Counter
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

// Tab Switching for Resume and Blog sections
function setupTabs() {
  const tabButtons = document.querySelectorAll(".tab-button");
  const tabContents = document.querySelectorAll(".tab-content");

  tabButtons.forEach((button) => {
    button.addEventListener("click", () => {
      const target = button.getAttribute("data-tab");

      tabButtons.forEach((btn) => btn.classList.remove("active"));
      button.classList.add("active");

      tabContents.forEach((content) => {
        content.classList.toggle("hidden", content.id !== target);
      });
    });
  });
}

window.addEventListener("DOMContentLoaded", () => {
  updateCounter();
  setupTabs();
});