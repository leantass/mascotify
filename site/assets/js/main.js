(function () {
  var appWebUrl = "[URL_APP_WEB_MASCOTIFY]";
  var appStoreUrl = "[URL_APP_STORE_MASCOTIFY]";
  var navToggle = document.querySelector(".nav-toggle");
  var siteNav = document.querySelector(".site-nav");
  var appEntryLinks = document.querySelectorAll("[data-app-entry-link]");
  var isIndexPage = /(?:^|\/)(index\.html)?$/.test(window.location.pathname);
  var appEntryTarget = isIndexPage ? "#usar-mascotify" : "index.html#usar-mascotify";

  function isPlaceholder(value) {
    return /^\[[A-Z0-9_]+\]$/.test(value);
  }

  appEntryLinks.forEach(function (link) {
    link.setAttribute("href", appEntryTarget);
  });

  function configureExternalLinks(selector, url) {
    document.querySelectorAll(selector).forEach(function (link) {
      if (isPlaceholder(url)) {
        link.setAttribute("href", "#");
        link.setAttribute("aria-disabled", "true");
        link.classList.add("is-disabled");
        link.removeAttribute("target");
        link.removeAttribute("rel");
        return;
      }

      link.setAttribute("href", url);
      link.classList.remove("is-disabled");
      link.removeAttribute("aria-disabled");

      if (/^https?:/i.test(url)) {
        link.setAttribute("target", "_blank");
        link.setAttribute("rel", "noreferrer");
      }
    });
  }

  configureExternalLinks("[data-web-app-link]", appWebUrl);
  configureExternalLinks("[data-app-store-link]", appStoreUrl);

  document.querySelectorAll("[aria-disabled='true']").forEach(function (link) {
    link.addEventListener("click", function (event) {
      event.preventDefault();
    });
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
