(function () {
  var appUrl = "[URL_APP_MASCOTIFY]";
  var navToggle = document.querySelector(".nav-toggle");
  var siteNav = document.querySelector(".site-nav");
  var appLinks = document.querySelectorAll("[data-app-link]");

  appLinks.forEach(function (link) {
    link.setAttribute("href", appUrl);
  });

  if (navToggle && siteNav) {
    navToggle.addEventListener("click", function () {
      var isOpen = siteNav.classList.toggle("is-open");
      navToggle.setAttribute("aria-expanded", String(isOpen));
    });

    siteNav.querySelectorAll("a").forEach(function (link) {
      link.addEventListener("click", function () {
        siteNav.classList.remove("is-open");
        navToggle.setAttribute("aria-expanded", "false");
      });
    });
  }

  var deletionForm = document.querySelector("[data-deletion-form]");

  if (deletionForm) {
    deletionForm.addEventListener("submit", function (event) {
      event.preventDefault();

      var name = (document.getElementById("nombre") || {}).value || "";
      var email = (document.getElementById("email") || {}).value || "";
      var reason = (document.getElementById("motivo") || {}).value || "";
      var confirmed = (document.getElementById("confirmacion") || {}).checked;

      if (!confirmed) {
        window.alert("Necesitas confirmar la solicitud antes de preparar el email.");
        return;
      }

      var supportEmail = "[COMPLETAR EMAIL DE SOPORTE]";
      var subject = "Solicitud de eliminacion de cuenta - Mascotify";
      var body = [
        "Hola,",
        "",
        "Quiero solicitar la eliminacion de mi cuenta y datos asociados en Mascotify.",
        "",
        "Nombre: " + name,
        "Email de cuenta: " + email,
        "Motivo opcional: " + reason,
        "",
        "Confirmo que solicito la eliminacion de mi cuenta y datos asociados.",
        "",
        "Gracias."
      ].join("\n");

      var mailto = "mailto:" + encodeURIComponent(supportEmail) +
        "?subject=" + encodeURIComponent(subject) +
        "&body=" + encodeURIComponent(body);

      window.location.href = mailto;
    });
  }
}());
