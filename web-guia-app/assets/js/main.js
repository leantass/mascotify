const appState = {
  reducedMotion: false,
};

function initReducedMotion() {
  const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
  const update = () => {
    appState.reducedMotion = mediaQuery.matches;
    document.documentElement.classList.toggle('reduced-motion', appState.reducedMotion);
  };

  update();
  mediaQuery.addEventListener('change', update);
}

function initNavigation() {
  const header = document.querySelector('[data-site-header]');
  const navToggle = document.querySelector('.nav-toggle');
  const primaryNav = document.querySelector('.primary-nav');

  if (navToggle && primaryNav) {
    navToggle.addEventListener('click', () => {
      const isOpen = navToggle.getAttribute('aria-expanded') === 'true';
      navToggle.setAttribute('aria-expanded', String(!isOpen));
      primaryNav.classList.toggle('is-open', !isOpen);
    });

    primaryNav.addEventListener('click', (event) => {
      if (event.target instanceof HTMLAnchorElement) {
        navToggle.setAttribute('aria-expanded', 'false');
        primaryNav.classList.remove('is-open');
      }
    });
  }

  const syncHeader = () => {
    if (!header) return;
    header.classList.toggle('is-scrolled', window.scrollY > 10);
  };

  syncHeader();
  window.addEventListener('scroll', syncHeader, { passive: true });
}

function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"], a[href^="/#"]').forEach((link) => {
    link.addEventListener('click', (event) => {
      const href = link.getAttribute('href') || '';
      const hash = href.startsWith('/#') ? href.slice(1) : href;
      const target = document.querySelector(hash);

      if (!target) return;

      event.preventDefault();
      target.scrollIntoView({
        behavior: appState.reducedMotion ? 'auto' : 'smooth',
        block: 'start',
      });
      history.pushState(null, '', hash);
    });
  });
}

function initRevealOnScroll() {
  const elements = document.querySelectorAll('.reveal');

  if (appState.reducedMotion || !('IntersectionObserver' in window)) {
    elements.forEach((element) => element.classList.add('is-visible'));
    return;
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.14, rootMargin: '0px 0px -8% 0px' });

  elements.forEach((element) => observer.observe(element));
}

function initFloatingCards() {
  const floatingCards = document.querySelectorAll('[data-floating-card]');
  const tiltCards = document.querySelectorAll('[data-tilt-card]');

  floatingCards.forEach((card, index) => {
    card.style.setProperty('--float-delay', `${index * 0.25}s`);
  });

  if (appState.reducedMotion) return;

  tiltCards.forEach((card) => {
    card.addEventListener('pointermove', (event) => {
      const rect = card.getBoundingClientRect();
      const x = ((event.clientX - rect.left) / rect.width - 0.5) * 8;
      const y = ((event.clientY - rect.top) / rect.height - 0.5) * -8;
      card.style.transform = `perspective(900px) rotateY(${x}deg) rotateX(${y}deg) translateY(-4px)`;
    });

    card.addEventListener('pointerleave', () => {
      card.style.transform = '';
    });
  });
}

function initCookieBanner() {
  const key = 'mascotify_cookie_notice_ok';

  if (localStorage.getItem(key) === '1') return;

  const banner = document.createElement('div');
  banner.className = 'cookie-banner';
  banner.innerHTML = '<p>Usamos almacenamiento local solo para recordar este aviso en esta web informativa.</p><button type="button">Entendido</button>';
  document.body.appendChild(banner);

  banner.querySelector('button')?.addEventListener('click', () => {
    localStorage.setItem(key, '1');
    banner.classList.add('is-hidden');
    window.setTimeout(() => banner.remove(), 240);
  });
}

function initPlatformLinks() {
  document.querySelectorAll('[data-disabled-link]').forEach((link) => {
    link.addEventListener('click', (event) => {
      event.preventDefault();
    });
  });
}

document.addEventListener('DOMContentLoaded', () => {
  initReducedMotion();
  initNavigation();
  initSmoothScroll();
  initRevealOnScroll();
  initFloatingCards();
  initCookieBanner();
  initPlatformLinks();
});
