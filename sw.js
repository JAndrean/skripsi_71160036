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
          self.addEventListener('fetch',() => console.log("fetch"));
          self.addEventListener('fetch', function(event) {
            event.respondWith(
              caches.match(event.request)
                .then(function(response) {
                  if (response) {
                    return response;
                  }
          
                  return fetch(event.request).then(
                    function(response) {
                      if(!response || response.status !== 200 || response.type !== 'basic') {
                        return response;
                      }
                      var responseToCache = response.clone();
          
                      caches.open(cacheName)
                        .then(function(cache) {
                          cache.put(event.request, responseToCache);
                        });
          
                      return response;
                    }
                  );
                })
              );
          });
          