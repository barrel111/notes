(() => {
  function initialize() {
    const setting = document.querySelector('meta[name="toc-start"]')?.content;
    const main = document.getElementById("quarto-document-content");
    const sidebar = document.getElementById("quarto-margin-sidebar");
    const toc = sidebar?.querySelector('nav[role="doc-toc"]');
    if (!setting || !main || !toc) return;

    if (setting !== "first-section") {
      sidebar.style.setProperty("--toc-start-offset", setting);
      return;
    }

    const target = toc.querySelector("a[data-scroll-target]")?.dataset.scrollTarget;
    if (!target?.startsWith("#")) return;
    let heading;
    try {
      heading = document.getElementById(decodeURIComponent(target.slice(1)));
    } catch {
      return;
    }
    const title = toc.querySelector("#toc-title") || toc;
    if (!heading || !main.contains(heading)) return;

    let pending = false;
    function update() {
      pending = false;
      // Both differences are independent of the scroll position. Changing a
      // quote or loading a font can move the heading without a fixed spacer.
      const headingInset = heading.getBoundingClientRect().top - main.getBoundingClientRect().top;
      const titleInset = title.getBoundingClientRect().top - sidebar.getBoundingClientRect().top;
      const offset = `${Math.max(0, headingInset - titleInset).toFixed(2)}px`;
      if (sidebar.style.getPropertyValue("--toc-start-offset") !== offset) {
        sidebar.style.setProperty("--toc-start-offset", offset);
      }
    }
    function schedule() {
      if (pending) return;
      pending = true;
      requestAnimationFrame(update);
    }

    if (window.ResizeObserver) {
      const observer = new ResizeObserver(schedule);
      observer.observe(main);
      observer.observe(heading);
      main.querySelectorAll(".epigraph").forEach((epigraph) => observer.observe(epigraph));
    }
    window.addEventListener("resize", schedule, {passive: true});
    window.addEventListener("load", schedule);
    document.fonts?.ready.then(schedule);
    schedule();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initialize, {once: true});
  } else {
    initialize();
  }
})();
