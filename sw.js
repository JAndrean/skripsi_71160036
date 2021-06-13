var cacheName = "sinode-gkj-cache";
var cachedUrl = [
  "/lib/",
  "/lib/beritaTagged",
  "/lib/klasis",
  "/lib/gereja",
  "assets/assets/klasis.json", 
 "assets/assets/gereja.json",
  "index.html"
]
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(cacheName)
      .then(function(cache) {
        console.log('Service Worker Installed');
        return cache.addAll(cachedUrl);
      })
  );
});
self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request).then(function (response) {
      return response || fetch(event.request);
    }),
  );
});
         