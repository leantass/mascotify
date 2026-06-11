(function () {
  var navToggle = document.querySelector(".nav-toggle");
  var siteNav = document.querySelector(".site-nav");

  if (navToggle && siteNav) {
    navToggle.addEventListener("click", function () {
      var isOpen = siteNav.classList.toggle("is-open");
      navToggle.setAttribute("aria-expanded", String(isOpen));
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
        window.alert("Necesitás confirmar la solicitud antes de preparar el email.");
        return;
      }

      var supportEmail = "[COMPLETAR EMAIL DE SOPORTE]";
      var subject = "Solicitud de eliminación de cuenta - Mascotify";
      var body = [
        "Hola,",
        "",
        "Quiero solicitar la eliminación de mi cuenta y datos asociados en Mascotify.",
        "",
        "Nombre: " + name,
        "Email de cuenta: " + email,
        "Motivo opcional: " + reason,
        "",
        "Confirmo que solicito la eliminación de mi cuenta y datos asociados.",
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
