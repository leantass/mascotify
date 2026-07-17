const appState = {
  reducedMotion: false,
};

function getPreferredTheme() {
  const stored = localStorage.getItem('mascotify_theme');
  if (stored === 'light' || stored === 'dark') return stored;
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

function applyTheme(theme) {
  document.documentElement.setAttribute('data-theme', theme);
  document.querySelectorAll('[data-theme-toggle]').forEach((button) => {
    const isDark = theme === 'dark';
    button.setAttribute('aria-pressed', String(isDark));
    const label = button.querySelector('[data-theme-label]');
    if (label) label.textContent = isDark ? 'Oscuro' : 'Claro';
  });
}

function initThemeToggle() {
  applyTheme(getPreferredTheme());

  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    if (!localStorage.getItem('mascotify_theme')) {
      applyTheme(getPreferredTheme());
    }
  });

  document.querySelectorAll('[data-theme-toggle]').forEach((button) => {
    button.addEventListener('click', () => {
      const next = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      localStorage.setItem('mascotify_theme', next);
      applyTheme(next);
    });
  });
}

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
    header.classList.toggle('is-scrolled', window.scrollY > 14);
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
  }, { threshold: 0.16, rootMargin: '0px 0px -10% 0px' });

  elements.forEach((element, index) => {
    element.style.setProperty('--reveal-delay', `${Math.min(index * 0.035, 0.22)}s`);
    observer.observe(element);
  });
}

function initFloatingCards() {
  const floatingCards = document.querySelectorAll('[data-floating-card]');
  const tiltCards = document.querySelectorAll('[data-tilt-card]');
  const parallaxCards = document.querySelectorAll('[data-parallax-card]');

  floatingCards.forEach((card, index) => {
    card.style.setProperty('--float-delay', `${index * 0.32}s`);
  });

  if (appState.reducedMotion) return;

  tiltCards.forEach((card) => {
    card.addEventListener('pointermove', (event) => {
      const rect = card.getBoundingClientRect();
      const x = ((event.clientX - rect.left) / rect.width - 0.5) * 7;
      const y = ((event.clientY - rect.top) / rect.height - 0.5) * -7;
      card.style.transform = `perspective(1000px) rotateY(${x}deg) rotateX(${y}deg) translateY(-5px)`;
    });

    card.addEventListener('pointerleave', () => {
      card.style.transform = '';
    });
  });

  const syncParallax = () => {
    const offset = Math.min(window.scrollY * 0.035, 24);
    parallaxCards.forEach((card) => {
      card.style.setProperty('--parallax-y', `${offset}px`);
    });
  };

  syncParallax();
  window.addEventListener('scroll', syncParallax, { passive: true });
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
  initThemeToggle();
  initNavigation();
  initSmoothScroll();
  initRevealOnScroll();
  initFloatingCards();
  initPlatformLinks();
});
