// self.addEventListener('install', function(event) {
//     event.waitUntil(
//       caches.open('flutter-cache').then(function(cache) {
//         return cache.addAll([
//           '/',
//           '/index.html',
//           '/main.dart.js',
//           '/assets/AssetManifest.json',
//           '/assets/fonts/MaterialIcons-Regular.ttf',
//           // Add other assets you want to cache
//         ]);
//       })
//     );
//   });
  
//   self.addEventListener('fetch', function(event) {
//     event.respondWith(
//       caches.match(event.request).then(function(response) {
//         return response || fetch(event.request);
//       })
//     );
//   });
  

const CACHE_NAME = 'flutter-cache-v1'; // Cache name
const assetsToCache = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/assets/AssetManifest.json',
  '/assets/fonts/MaterialIcons-Regular.ttf',
  // Add common assets like fonts, icons, etc.
];

// Install the service worker and cache essential files
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      return cache.addAll(assetsToCache);
    })
  );
});

// Activate the service worker (delete old caches if needed)
self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.map(function(cacheName) {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

// Handle dynamic caching of pages
self.addEventListener('fetch', function(event) {
  const requestUrl = new URL(event.request.url);
  
  // If the request is for a page (not a static asset like CSS or JS)
  if (requestUrl.pathname !== '/' && !requestUrl.pathname.startsWith('/assets')) {
    event.respondWith(
      caches.match(event.request).then(function(cachedResponse) {
        if (cachedResponse) {
          return cachedResponse; // Return cached page if available
        }

        // Otherwise, fetch the page and cache it for future use
        return fetch(event.request).then(function(response) {
          return caches.open(CACHE_NAME).then(function(cache) {
            cache.put(event.request, response.clone()); // Cache the response
            return response;
          });
        });
      })
    );
  }
});


//-------------------Cache Cleanup--------------------------------

self.addEventListener('activate', function(event) {
    const cacheWhitelist = [CACHE_NAME];
    event.waitUntil(
      caches.keys().then(function(cacheNames) {
        return Promise.all(
          cacheNames.map(function(cacheName) {
            if (!cacheWhitelist.includes(cacheName)) {
              return caches.delete(cacheName); // Clean up old caches
            }
          })
        );
      })
    );
  });
  