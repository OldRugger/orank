this.GoogleAnalytics = class GoogleAnalytics {

  static load() {}
};
    // app/assets/javascripts/analytics.js.coffee

if ((window.history != null ? window.history.pushState : undefined) && window.history.replaceState) {
 document.addEventListener('page:change', event => {
  // Google Analytics
  if (window.ga !== undefined) {
   ga('set', 'location', location.href.split('#')[0]);
   return ga('send', 'pageview');
  } else if (window._gaq !== undefined) {
   return _gaq.push(['_trackPageview']);
  } else if (window.pageTracker !== undefined) {
   return pageTracker._trackPageview();
 }
 });
}
