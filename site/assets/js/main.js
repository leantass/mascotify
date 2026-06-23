function initHeader() {
  var header = document.querySelector(".site-header");

  if (!header) {
    return;
  }

  var updateHeader = function () {
    header.classList.toggle("is-scrolled", window.scrollY > 8);
  };

  updateHeader();
  window.addEventListener("scroll", updateHeader, { passive: true });
}

function initNavigation() {
  var navToggle = document.querySelector(".nav-toggle");
  var siteNav = document.querySelector(".site-nav");

  if (!navToggle || !siteNav) {
    return;
  }

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

function initCookieBanner() {
  var cookieBanner = document.querySelector("[data-cookie-banner]");
  var acceptButton = document.querySelector("[data-cookie-accept]");
  var rejectButton = document.querySelector("[data-cookie-reject]");
  var storageKey = "mascotify.cookie-consent";

  if (!cookieBanner) {
    return;
  }

  var storedPreference = window.localStorage.getItem(storageKey);

  if (!storedPreference) {
    cookieBanner.hidden = false;
    requestAnimationFrame(function () {
      cookieBanner.classList.add("is-visible");
    });
  }

  var savePreference = function (value) {
    window.localStorage.setItem(storageKey, value);
    cookieBanner.classList.remove("is-visible");
    window.setTimeout(function () {
      cookieBanner.hidden = true;
    }, 180);
  };

  if (acceptButton) {
    acceptButton.addEventListener("click", function () {
      savePreference("accepted");
    });
  }

  if (rejectButton) {
    rejectButton.addEventListener("click", function () {
      savePreference("rejected");
    });
  }
}

function initSmoothAnchors() {
  document.querySelectorAll('a[href^="/#"], a[href^="#"]').forEach(function (link) {
    link.addEventListener("click", function (event) {
      var href = link.getAttribute("href") || "";
      var hash = "";

      if (href.startsWith("/#")) {
        hash = href.slice(1);
      } else if (href.startsWith("#")) {
        hash = href;
      }

      if (!hash) {
        return;
      }

      var target = document.querySelector(hash);

      if (!target || window.location.pathname !== "/") {
        return;
      }

      event.preventDefault();
      target.scrollIntoView({ behavior: "smooth", block: "start" });
      window.history.replaceState({}, "", hash);
    });
  });
}

function initAppEntryLinks() {
  var appWebUrl = document.body.dataset.appWebUrl || "[URL_APP_WEB_MASCOTIFY]";
  var appStoreUrl = document.body.dataset.appStoreUrl || "[URL_APP_STORE_MASCOTIFY]";
  var entryLinks = document.querySelectorAll("[data-app-entry-link]");

  var isPlaceholderUrl = function (value) {
    return /^\[[A-Z0-9_]+\]$/.test(String(value).trim());
  };

  entryLinks.forEach(function (link) {
    link.setAttribute("href", "/#usar-mascotify");
  });

  var configureExternalLinks = function (selector, url) {
    document.querySelectorAll(selector).forEach(function (link) {
      if (isPlaceholderUrl(url)) {
        link.setAttribute("href", "#");
        link.setAttribute("aria-disabled", "true");
        link.classList.add("is-disabled");
        link.removeAttribute("target");
        link.removeAttribute("rel");

        link.addEventListener("click", function (event) {
          event.preventDefault();
        });

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
  };

  configureExternalLinks("[data-web-app-link]", appWebUrl);
  configureExternalLinks("[data-app-store-link]", appStoreUrl);
}

function initDeletionForm() {
  var deletionForm = document.querySelector("[data-deletion-form]");

  if (!deletionForm) {
    return;
  }

  deletionForm.addEventListener("submit", function (event) {
    event.preventDefault();

    var name = (document.getElementById("nombre") || {}).value || "";
    var email = (document.getElementById("email") || {}).value || "";
    var reason = (document.getElementById("motivo") || {}).value || "";
    var confirmed = (document.getElementById("confirmacion") || {}).checked;
    var supportEmail = document.body.dataset.supportEmail || "[EMAIL_SOPORTE_MASCOTIFY]";

    if (!confirmed) {
      window.alert("Necesitas confirmar la solicitud antes de preparar el email.");
      return;
    }

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

    var mailto = "mailto:" + encodeURIComponent(supportEmail)
      + "?subject=" + encodeURIComponent(subject)
      + "&body=" + encodeURIComponent(body);

    window.location.href = mailto;
  });
}

function initReducedMotion() {
  if (!window.matchMedia) {
    return;
  }

  var mediaQuery = window.matchMedia("(prefers-reduced-motion: reduce)");

  if (mediaQuery.matches) {
    document.documentElement.classList.add("reduced-motion");
  }
}

document.addEventListener("DOMContentLoaded", function () {
  initHeader();
  initNavigation();
  initCookieBanner();
  initSmoothAnchors();
  initAppEntryLinks();
  initDeletionForm();
  initReducedMotion();
});
