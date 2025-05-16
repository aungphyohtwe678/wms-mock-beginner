'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "488c68544c44647789277ce1b55f81f1",
"version.json": "64469b8f9e0b62ee33e1c3e24ca5ab93",
"index.html": "c26105a8ce43d65cfd74846224b978dc",
"/": "c26105a8ce43d65cfd74846224b978dc",
"main.dart.js": "de79c78a16e772d1e952fb9dc3fd87a1",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "1b515c6a2533d0c000e000c71573202a",
"assets/AssetManifest.json": "e926f1899bbcc548fa1f56068aab1ed1",
"assets/NOTICES": "be0c9828801b116d3977ff5a78a8479c",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "9f5bb1f2ba7ddd6b7ed7b2dac8d1f6c2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "74aa1fcbd74409202489ad1827709958",
"assets/fonts/MaterialIcons-Regular.otf": "261f386f881d77f054cc18f93b71bb93",
"assets/assets/images/hanso-qr.png": "7b5a9ac792af4b745ceea464c709b1e7",
"assets/assets/images/tumituke.png": "210f6fc4f1674c338c69ff171b93048b",
"assets/assets/images/map9.png": "1c7c5063ccc23a481fdc2a77ec661b6f",
"assets/assets/images/map8.png": "4d57902a809e847883c686f09ec269d3",
"assets/assets/images/hozyu-label.png": "c66fc3fd932ea468a2393a27d5f4832d",
"assets/assets/images/location-code.png": "da6a842bd787229793923419fc21a8ae",
"assets/assets/images/camera-4.png": "4b2fea94dd8c68772ea71aa600e93a4c",
"assets/assets/images/tana-location.png": "0d944b69fb7823195533c9dd43ef41d9",
"assets/assets/images/asn-qr.png": "270008ddd5605e810c2c6047329ec6c9",
"assets/assets/images/camera-3.png": "3c18e5b41cc1499f23ce0238182913cb",
"assets/assets/images/syohin.jpg": "ce9fa12556acdb76802d1104ffbf331a",
"assets/assets/images/camera-2.png": "cf2c376b9a41ab297dc50bdae5df98e3",
"assets/assets/images/tumituke2.png": "1aa18497f0d900359674d66c82be4750",
"assets/assets/images/camera-1.png": "fe185516b6a07dff64efe9e7067c2155",
"assets/assets/images/fake-camera.png": "95c3cd0a357aa2d24c2a548ef5893e01",
"assets/assets/images/asn-qr2.png": "daa0a762494cf2ab48dda1fc5a335108",
"assets/assets/images/syohin2.png": "949440d8c5dc1aea1ad70b08374c985a",
"assets/assets/images/kakuno.png": "298a0ab7fe8dbc443ce0ac3558ed7cdb",
"assets/assets/images/map6.png": "cc931bbeb39a83cebfb1bb162c0b2dde",
"assets/assets/images/map7.png": "2de1a9ddd451e0a6ad777e16758a9f20",
"assets/assets/images/hakodume4.png": "ebad77e2a707cb3edd04fc72b5614df5",
"assets/assets/images/map5.png": "f483f9c67dead5a0dd98d9cb3c71a363",
"assets/assets/images/map4.png": "afccf6974703610f65282f35538714c2",
"assets/assets/images/hakodume3.png": "3f4c1ed111cf97e56b722120a2106bec",
"assets/assets/images/map1.png": "77469c33e6aa91c76614bca097a4231b",
"assets/assets/images/hakodume2.png": "2c87b4078b9cae350b551ca0fd4670a7",
"assets/assets/images/map3.png": "09f71d37adf9e4f7db4f4c153e3d9de3",
"assets/assets/images/map2.png": "5a6c986975701a880282729f2374109e",
"assets/assets/images/hakodume1.png": "526a352336e61a7c0a5d338ce29e873b",
"assets/assets/sounds/hanso-asn.ogg": "b5786b370de5b77fcbbd2b00eae0fd5f",
"assets/assets/sounds/shiwake-saki.ogg": "aa4609ac96c0e8cda26f5780ae75d8c6",
"assets/assets/sounds/ng-label.ogg": "cc06e1163f018a0cb7b9aa17f37592d9",
"assets/assets/sounds/pi.ogg": "211361f044495fc4a00346b232259e1a",
"assets/assets/sounds/pl-himoduke.ogg": "b0e60d33e469ad0bed775763ab916a2b",
"assets/assets/sounds/shiwake-saki2.ogg": "5c67927e27386e811670bb9be6c4489d",
"assets/assets/sounds/pic-sentaku.ogg": "cc2c01e88b24db273f4af9bdb239ff53",
"assets/assets/sounds/hozyu-kanryo.ogg": "06167223bc20ed438fd32cb63b3f42f3",
"assets/assets/sounds/label-harituke.ogg": "7090fe6009d59234a9f81f0ac6a04dee",
"assets/assets/sounds/shiwake-zenpin.ogg": "d41d2b46383dfd73aee487adbc08ea45",
"assets/assets/sounds/hozyu-kara.ogg": "6e8370acb34b408bd62add6c64fbd210",
"assets/assets/sounds/pic-start5.ogg": "ca431e0655f59ad00af1dce66e3e16c9",
"assets/assets/sounds/tumituke.ogg": "5a3edbb0c67b97c777098a7842d6ef44",
"assets/assets/sounds/pic-loc3.ogg": "5e0873964b7a79d3e16a29171c62d9d8",
"assets/assets/sounds/suryo.ogg": "a34e89123d8bb8228b55f2f9e6e34aff",
"assets/assets/sounds/rotto.ogg": "273dc2ba8f795abba80e49230a6bd5b8",
"assets/assets/sounds/pic-loc2.ogg": "9f6977f7fb42b21cd8d65c3b92a44989",
"assets/assets/sounds/pic-start4.ogg": "0ce7ce9d7cf3e12dc157d809195dceff",
"assets/assets/sounds/pic-start6.ogg": "1e125f0bcfa757446684193695c0847e",
"assets/assets/sounds/kenpin-kanryo.ogg": "67723c011c6eb2f15499d23449161dd3",
"assets/assets/sounds/pic-next.ogg": "2025556b9e11ed30035594507e3a3322",
"assets/assets/sounds/pic-loc1.ogg": "38cc95ea3524cf938c2581a18aff2a49",
"assets/assets/sounds/pic-start7.ogg": "b8ad4e6d9005bd38b6347e4364ef3396",
"assets/assets/sounds/kakuno-kanryo.ogg": "377239a64285c07b0b1d488e914cb471",
"assets/assets/sounds/hozyu-label.ogg": "a0e0496df9b8c2e24628f3cf727e97eb",
"assets/assets/sounds/pic-start3.ogg": "0812cc3d52d23fd2990b0bce1966cc01",
"assets/assets/sounds/pic-kanryo.ogg": "f9cc4a844bb88bc5628279cb36cd03a2",
"assets/assets/sounds/pic-start2.ogg": "9b012af0ab06405566750ecd19032fe7",
"assets/assets/sounds/satuei.ogg": "11e3888eca25cda09006e27750f6a14f",
"assets/assets/sounds/pic-next-pcs2.ogg": "7cbd329943fa9154bdb865d9d7ff5780",
"assets/assets/sounds/pic-syohin.ogg": "b9b9044a0cb7cfbc7fdb0655c87faf3e",
"assets/assets/sounds/2.ogg": "b15e7ad4b849d0109c04acf2c6b25e86",
"assets/assets/sounds/ng-null.ogg": "1492cb38f67fa5af53692fcb017a64ce",
"assets/assets/sounds/kenpin-kakunin.ogg": "2967995dd3f9c88910c9378496bdaa0f",
"assets/assets/sounds/kinkyu-hozyu.ogg": "b14029c8499d7eb525aed7afbd0b2168",
"assets/assets/sounds/4c.ogg": "25db19d5c2fc88fcb44fa6165c5f0e7b",
"assets/assets/sounds/8c.ogg": "99cedf91245c7230dc73807b57297a8c",
"assets/assets/sounds/kakuno-asn.ogg": "016145ea7f6986f65f80cc9dbc639c3c",
"assets/assets/sounds/4.ogg": "5a69f5b16257b4e0db024c787ab2a0b7",
"assets/assets/sounds/kakuno.ogg": "e6856540d24e6c6b5984da02f788a443",
"assets/assets/sounds/5.ogg": "ce6cae5e86283f58f39e4bc8667e669b",
"assets/assets/sounds/pic-kanpare.ogg": "591e30753385da889ae3aac8f96cf8c4",
"assets/assets/sounds/shiwake-kanryo.ogg": "0771a19e1755aebc0f3127e0c386700b",
"assets/assets/sounds/pic-next-pcs.ogg": "add02f7ce7834df36d53a29436ba66a0",
"assets/assets/sounds/6.ogg": "27bb90e8bfa50fbf9ae726b642528b39",
"assets/assets/sounds/syohin-scan.ogg": "5e17bb05b08ec22c18260a1f000985bb",
"assets/assets/sounds/asn-scan.ogg": "79e343e11f4f137a912fa344d9b45de1",
"assets/assets/sounds/pic-start.ogg": "b1563bdd15c5544c710d851cf8ec6a61",
"assets/assets/sounds/shiwake-moto.ogg": "6d248faf6ab31ba7922f20418304c4f9",
"assets/assets/sounds/kenpin-start.ogg": "e848faa0fd1b8d180f8e61ca778376ed",
"assets/assets/sounds/hanso-kanryo.ogg": "85be0eedc247d5d8da37256d7f25824a",
"assets/assets/sounds/denpyo.ogg": "33b7ae100f9385ca85b4aa8ba360ebf5",
"assets/assets/sounds/hanso.ogg": "531919659162d2d724e2dbd678d2edcc",
"assets/assets/sounds/error.ogg": "aa0a3d66d1419d8fdd334d82639df271",
"assets/assets/sounds/zensu.ogg": "73cf6d591fb0506d0e72b1117520a953",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
