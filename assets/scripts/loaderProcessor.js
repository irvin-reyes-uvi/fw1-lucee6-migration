document.addEventListener("DOMContentLoaded", () => {
  const showLoader = () => {
    const loader = document.getElementById("loader-overlay");
    if (loader) {
      loader.style.display = "flex";
      loader.style.opacity = "0";
      setTimeout(() => (loader.style.opacity = "1"), 10);
    }
  };

  const hideLoader = () => {
    const loader = document.getElementById("loader-overlay");
    if (loader) {
      loader.style.opacity = "0";
      setTimeout(() => (loader.style.display = "none"), 300);
    }
  };

  document.addEventListener("submit", (e) => {
    const form = e.target;
    if (form.method && form.method.toLowerCase() === "post") {
      if (sessionStorage.getItem("form-submitting") !== "false") {
        showLoader();
      }

      form.querySelectorAll('button, input[type="submit"]').forEach((btn) => {
        if (sessionStorage.getItem("form-submitting") !== "false") {
          btn.disabled = true;
        }
      });

      sessionStorage.setItem("form-submitting", "true");
    }
  });

  window.addEventListener("beforeunload", () => {
    if (sessionStorage.getItem("form-submitting") === "true") {
      showLoader();
    }
  });

  window.addEventListener("load", () => {
    hideLoader();
    sessionStorage.removeItem("form-submitting");

    document.querySelectorAll('button, input[type="submit"]').forEach((btn) => {
      btn.disabled = false;
    });
  });

  window.addEventListener("pageshow", (e) => {
    hideLoader();
    sessionStorage.removeItem("form-submitting");
  });

  if (sessionStorage.getItem("form-submitting") === "true") {
    showLoader();
  }
});
