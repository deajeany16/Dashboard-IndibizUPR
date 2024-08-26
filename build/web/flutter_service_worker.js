'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "d1a68325bceb406f47658503b33258eb",
"assets/AssetManifest.bin.json": "88a95a76e841a4cf0ec03a809db1cfbc",
"assets/AssetManifest.json": "d979e76e4599a20724488243e3459849",
"assets/assets/data/australia.json": "a1f91171be99e91050164ab874eb4b42",
"assets/assets/data/chat_data.json": "764f9cd37f07dbbd9c9c064277bcfc98",
"assets/assets/data/contact_data.json": "167a07c7235c13343cc1b460d7b8dbd5",
"assets/assets/data/customers.json": "9e142854f56a1c5ed612a1dd047819e8",
"assets/assets/data/dashboard_data.json": "f1f68d0d6c6b00c670aaa3006aebb28f",
"assets/assets/data/discover.json": "7f1088d1356d9f31078704a03bdff04e",
"assets/assets/data/discover_2_data.json": "1b90d7475b4f521b4d8ebac2d7bfe366",
"assets/assets/data/europe_map.json": "bb09883ee18a3af276d84f4013666a78",
"assets/assets/data/inputan.json": "abe1726c334ebe6281407279988f273a",
"assets/assets/data/job_vacancee.json": "d6d0f63bcc123c7ad829ad1a336ff680",
"assets/assets/data/odp.json": "a14875d1ccb2165018ae09c600edb21d",
"assets/assets/data/opportunities_data.json": "e7adfd5eca9025844508118aea396d32",
"assets/assets/data/products_data.json": "462e9b00386514ce3882175debdcdb11",
"assets/assets/data/product_detail.json": "122bee64636478cf24b07d8a49c81693",
"assets/assets/data/project_list_data.json": "eb323e73ca4b2cb8c06fd96667923ced",
"assets/assets/data/review.json": "31b992ecc6a0210e15c17b6bf0a5bfe6",
"assets/assets/data/sales.json": "16fa7dbbd2ec2494189323adfe26428c",
"assets/assets/data/salesorder.json": "6a538f980c88b48c1feb98261ee2545e",
"assets/assets/data/survei.json": "9a6117cdbcd47cee6b3bdc18caaa3929",
"assets/assets/data/user.json": "251e31d2c8970c9366986d2711fa64ca",
"assets/assets/data/world_map.json": "2a54fbfcb2f8a1413e730e95c8549cef",
"assets/assets/images/auth/background.jpg": "7469fe433f6c7168a001d6a09b84fce8",
"assets/assets/images/dummy/1.jpg": "2d0338279ab774733ecf119e08610295",
"assets/assets/images/dummy/10.jpg": "1919e6e3ac455a78396aaaff43d5589d",
"assets/assets/images/dummy/11.jpg": "bf5d59ec2158f3d83b4a6a823661d314",
"assets/assets/images/dummy/12.jpg": "058d7b329a2b56c1a45b3ae7781a32f1",
"assets/assets/images/dummy/13.jpg": "568d35a4a18de358d3a6f10d6e2fb985",
"assets/assets/images/dummy/14.jpg": "4785ac10b3c5e77c7af49563860906c3",
"assets/assets/images/dummy/15.jpg": "d79c36e1ecc8b25306c97a480c5b7707",
"assets/assets/images/dummy/2.jpg": "c0bceb104e70804c635db83335cd595c",
"assets/assets/images/dummy/3.jpg": "a0538cf11c99325d08ebe02d0e2f82a7",
"assets/assets/images/dummy/4.jpg": "04bb4cbc13dbb079aeb2329d302b6394",
"assets/assets/images/dummy/5.jpg": "6bdc1245c016dd8f3a0f7cf3a114ffe1",
"assets/assets/images/dummy/6.jpg": "fb95b4331d3a4234331345590a6a460f",
"assets/assets/images/dummy/7.jpg": "6feb9e1c783190dd5127c86932f50518",
"assets/assets/images/dummy/8.jpg": "9b9a8e648c7ad0ad67a5935c2f6d7cc6",
"assets/assets/images/dummy/9.jpg": "62c485eeee8de9ae922e13448787e1f7",
"assets/assets/images/dummy/a1.jpg": "6807a2e9ae0757b7463dcff5d4e78983",
"assets/assets/images/dummy/a2.jpg": "397ffc6d89dd46c5494ef307e6c8932c",
"assets/assets/images/dummy/a3.jpg": "069df945775d3e291b6bafa474208120",
"assets/assets/images/dummy/a4.jpg": "bbe5c27105fb18f90d4d39d246bed14c",
"assets/assets/images/dummy/a5.jpg": "4767834c27471d2edad72d43010b5c04",
"assets/assets/images/dummy/a6.jpg": "4f24905229cd418c3ca7a6b548304561",
"assets/assets/images/dummy/a7.jpg": "b0dfabe6d05a90cf4b1bf76ddae6b52a",
"assets/assets/images/dummy/a8.jpg": "a11359bcf5ed3930f76b551808e934c3",
"assets/assets/images/dummy/avatar1.png": "c6e6058e6237e8ec68f1c17e6a69b96a",
"assets/assets/images/dummy/avatar10.png": "30d270888a7eefda5ace0035a20e6022",
"assets/assets/images/dummy/avatar11.png": "a5b57ced0fb981d9b53a51eb3c44251b",
"assets/assets/images/dummy/avatar12.png": "fb4dad15f84412689ed9dea8cbc830f4",
"assets/assets/images/dummy/avatar2.png": "66a61569cabe22b2be2ba34a45434f45",
"assets/assets/images/dummy/avatar3.png": "f61becb2f37ea74bac5fb9af4e1889a7",
"assets/assets/images/dummy/avatar4.png": "bb625096d7f3bd2c742fd71d18d8c85c",
"assets/assets/images/dummy/avatar5.png": "e625a919d7915ff9a442c5d6fc6a5508",
"assets/assets/images/dummy/avatar6.png": "3a1710e5017456bd097b70575aadf827",
"assets/assets/images/dummy/avatar7.png": "73c3047648a973bab4eb5f30ef7a703d",
"assets/assets/images/dummy/avatar8.png": "5fbe75d7763639386063f65c6eca8fb0",
"assets/assets/images/dummy/avatar9.png": "3e8a187b93258c1735aa0060a4cf3596",
"assets/assets/images/dummy/brand-1.jpg": "b668a8988926ff7ba58edbd58a0fe82a",
"assets/assets/images/dummy/brand-2.jpg": "3c4be06089401865db62404f38678e4a",
"assets/assets/images/dummy/brand-3.jpg": "021e8cf94059d126ac7e1294eeaecb2e",
"assets/assets/images/dummy/brand-4.jpg": "ab199135ecaae8ba3751b74ce6eee9aa",
"assets/assets/images/dummy/brand-5.jpg": "94422a40ba64cff2d1a9ec6e36284de3",
"assets/assets/images/dummy/brand-6.jpg": "de47378db0e4cee59a4a6eb4431d3fca",
"assets/assets/images/dummy/brand-7.jpg": "73c975ef55b4a0d685c56566c2eb9ae1",
"assets/assets/images/dummy/brand-8.jpg": "f4d36095ace6fa8859f06af325519df0",
"assets/assets/images/dummy/coming_soon-1.jpg": "4e3b175cc997596bc6a7951816950723",
"assets/assets/images/dummy/error-1.jpg": "6e82611e1c9542ec1748ab69f65de79d",
"assets/assets/images/dummy/error-2.jpg": "2918fa609529406920d0e6f2aebe338a",
"assets/assets/images/dummy/error-3.jpg": "1d20736971db870a29b3a08aa93b8fa6",
"assets/assets/images/dummy/error-4.jpg": "df9bfa2ba07e0febdf96fa76d3037b5b",
"assets/assets/images/dummy/error-5.jpg": "7bf2b56327fea40fe71cdd0d7c5f1509",
"assets/assets/images/dummy/google.png": "65c7e6fd157c435c6f5223a0d6043287",
"assets/assets/images/dummy/h1.jpg": "523e954f6e43a394420318fc4f15f3a9",
"assets/assets/images/dummy/h2.jpg": "e603b8880e8e0ea0b8de6f0c2a461b03",
"assets/assets/images/dummy/h3.jpg": "6847e351d9efe19c8de927b748f0f9ec",
"assets/assets/images/dummy/h4.jpg": "bb71a3e18cc3741431dba50e84c160bd",
"assets/assets/images/dummy/h5.jpg": "229e58adfaf51530a8ae6e2228234111",
"assets/assets/images/dummy/h6.jpg": "11cb9d90b5e6c92001362656303c8aa4",
"assets/assets/images/dummy/h7.jpg": "b800f411a9308c7126bcfc67ceea27c6",
"assets/assets/images/dummy/l1.jpg": "a530d59fa7fca0e2983d1ada0aec577a",
"assets/assets/images/dummy/l2.jpg": "6789631815c90d52eaaa3ca190a9ab40",
"assets/assets/images/dummy/l3.jpg": "73543363cfca8fb8307b8b850605990f",
"assets/assets/images/dummy/l4.jpg": "6e61e33609a76e1c425668e73dce7157",
"assets/assets/images/dummy/landing-1.jpg": "fa6ce9ede52e4e387f25f32020d91a73",
"assets/assets/images/dummy/landing-2.jpg": "3b220b249d317147546dcffdf246abf5",
"assets/assets/images/dummy/landing-3.jpg": "fc8e95902a411be297eff242d5f697b3",
"assets/assets/images/dummy/landing-4.jpg": "a9379304a6881589c10d4ab404ebace7",
"assets/assets/images/dummy/landing-5.jpg": "a5b445d62759790950864b6bac5d3b87",
"assets/assets/images/dummy/login1.jpg": "03d1dfc686973b9088e74ba8e41ae5ec",
"assets/assets/images/dummy/login2.jpg": "9dd949ba82e62865b0bca1a1c35f6ea3",
"assets/assets/images/dummy/login3.jpg": "4147c67ec2598fe574291cbf1474f097",
"assets/assets/images/dummy/login4.jpg": "98014387ca4c9a1f7c99ad3a7aa146f1",
"assets/assets/images/dummy/login5.jpg": "32376c1656bb0cd32dce5320838c06a2",
"assets/assets/images/dummy/login6.jpg": "b3028101973b605c1e79cdd3cf04072e",
"assets/assets/images/dummy/m-1.jpg": "839fb7b92dbfeb86be59c343bbd0393b",
"assets/assets/images/dummy/m-2.jpg": "d42e9822d8dae565c1704707ffa99705",
"assets/assets/images/dummy/m-3.jpg": "96de6cae58ae474870ef29f43e3a1245",
"assets/assets/images/dummy/m1.jpg": "75d84ef25cbf23e2df3deb053e42b7df",
"assets/assets/images/dummy/m2.jpg": "602b8f28cb6be6b599c7c71c25fecc4d",
"assets/assets/images/dummy/m3.jpg": "dd31845e4ab55f8ac0b4bc25aba3ecee",
"assets/assets/images/dummy/m4.jpg": "4d48509b2c0ef880d388cf7c27e1ab64",
"assets/assets/images/dummy/m5.jpg": "0302ba2b1eced67ba5d51f5b572dcc1d",
"assets/assets/images/dummy/m6.jpg": "0b1494e1fee543a20825beec0e9fc3fa",
"assets/assets/images/dummy/m7.jpg": "32d9f96d13d0e2ec32237474e75236f0",
"assets/assets/images/dummy/m8.jpg": "381c07e23648466c813039d1e07a24f0",
"assets/assets/images/dummy/maintenance-1.jpg": "695ee627e3201178f368d2a5fa78f483",
"assets/assets/images/dummy/nft1.jpeg": "de2c2ddb8ad62ab5f5ea363bb341041a",
"assets/assets/images/dummy/nft2.jpeg": "c7caf185d9bf116870c866bc40ea2cc1",
"assets/assets/images/dummy/nft3.jpeg": "ca32c7f2e068b52b3b1bfc908a6d2b04",
"assets/assets/images/dummy/p1.jpg": "0993a07c2eca498fc53abbb4754d4bb5",
"assets/assets/images/dummy/p2.jpg": "07975334d9a5cb9449a7fa9a5b5578ef",
"assets/assets/images/dummy/p3.jpg": "e2e0c556cdb1ff168b2fada00c161a97",
"assets/assets/images/dummy/s-1.jpg": "2d5c08ee01e49d5e278de3a5b45581af",
"assets/assets/images/dummy/shoes.png": "5fa627e53004b72582c5c98642285b2e",
"assets/assets/images/dummy/social-1.jpg": "6b3362eabff4a84bbbacbe99e0a92ac8",
"assets/assets/images/dummy/social-2.jpg": "5672c1bff49726b1a99a14bace0770ee",
"assets/assets/images/dummy/social-3.jpg": "36321ede8653a9842bb158e833806087",
"assets/assets/images/dummy/social-4.jpg": "c4669abf5c4950d89ba03c053af022d3",
"assets/assets/images/dummy/social-5.jpg": "0590933a38c763b2f7ffacfdb2325a2d",
"assets/assets/images/logo/Circles-menu-3.gif": "dafa4436fac90d439006f6080703fcd8",
"assets/assets/images/logo/ethereum-eth-logo.png": "3a3285881789dc8b524b6e5b42012460",
"assets/assets/images/logo/logo-indibiz.png": "69bf12f855b7353691e19581df7207c9",
"assets/assets/images/logo/logo.png": "527e4926974afb9f741809a3641998bd",
"assets/assets/images/logo/logo_icon_dark.png": "f15c1ac2557c88ee768165b185a20ad1",
"assets/assets/images/person.png": "abafc6cb1a2a9238d52ddd67b223e0bf",
"assets/assets/images/personMobi.png": "f82e223480f7372fe8d75f377f51bf78",
"assets/assets/images/pin1.png": "d54ebad003eaebc3b08f6d977d6ec136",
"assets/assets/images/pin1Mobi.png": "d05e0d7b4d25065d95aa6b5534333c9c",
"assets/assets/images/pin2.png": "20986d8c229649026bc1e16a669934ed",
"assets/assets/images/pin2Mobi.png": "07857c300917fa405fe8f37bdea6e6e8",
"assets/assets/lang/ar.jpg": "9143f6bb9f70a7082b2d49a2fa2b0339",
"assets/assets/lang/ar.json": "30fe189880bde72f2e34b2bf51bd236f",
"assets/assets/lang/en.jpg": "6dd96569bff0a5c5ada7d99222b9815d",
"assets/assets/lang/en.json": "7f4eb68842f8fe4b7904ed581791c79d",
"assets/assets/lang/es.jpg": "25d67fb418ce2623d770679b2fd4f575",
"assets/assets/lang/es.json": "1426f63dfc62a7bef7f2ad1bd583a1d5",
"assets/assets/lang/fr.jpg": "ed28420a8f74b0631c24659a40511c2d",
"assets/assets/lang/fr.json": "a48f2c0b4c83dc927581a8aa644fb30b",
"assets/assets/lang/hi.jpg": "806b19b66156a2bfcb232d4f6518747a",
"assets/assets/lang/hi.json": "e47582d957b2d32cd7c940e109808568",
"assets/assets/lang/id.json": "7f4eb68842f8fe4b7904ed581791c79d",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "c50a6e661c5af0d3bc445a4057081535",
"assets/NOTICES": "39d2e7a1c8d690606164a4f237ba81b6",
"assets/packages/timezone/data/latest_all.tzf": "a3a6cb5d912b5375926e5b027f91cb00",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"browserconfig.xml": "68c9044fa4a08749efb85bb2a4edaede",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon-16x16.png": "deec99265b870e9ca77675e428a729ab",
"favicon-32x32.png": "f982c4729cc79f3f4eb45dfe9004c6da",
"favicon.ico": "87f94b87700f6aab2e5bf5a2238ca9d8",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "94dd9cb5a8532517449b3d0e31b9afe5",
"icons/android-chrome-192x192.png": "5cba1b592936e59d1acac9c6a715544d",
"icons/android-chrome-512x512.png": "a29893c88fe1107db9a8aadbaf34f34a",
"icons/apple-touch-icon.png": "4085c96c92e5118b67329d1c6c9ea902",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/safari-pinned-tab.svg": "528485b1468c5ffc1effe7a692964f1a",
"index.html": "fba567b685becc980b7c609cd2a2a93c",
"/": "fba567b685becc980b7c609cd2a2a93c",
"main.dart.js": "00d22d06911d1b02a7b5286f086825a9",
"manifest.json": "e5a96d7e730ef797046ed04afc799583",
"mstile-150x150.png": "777b1ae48dd8a124093408b99e3d0039",
"splash/img/dark-1x.gif": "06b5668b2bd9d20e22811939b0550db8",
"splash/img/dark-2x.gif": "8688ced07968693117f3b15bf552ba7b",
"splash/img/dark-2x.png": "3b5f48ea7da40fdf40b5885888c315b1",
"splash/img/dark-3x.gif": "e2e1bd502f1d6a7c4f8ddcbe11fdce73",
"splash/img/dark-3x.png": "cb74db85f263cabcec85bb84665b3c69",
"splash/img/dark-4x.gif": "b83c0687a6df4261b329b7ec52a585e9",
"splash/img/dark-4x.png": "0af348d3924624d502198b699fda13bd",
"splash/img/light-1x.gif": "06b5668b2bd9d20e22811939b0550db8",
"splash/img/light-1x.png": "f35f401b1b3010412ff0472ab61a3d2d",
"splash/img/light-2x.gif": "8688ced07968693117f3b15bf552ba7b",
"splash/img/light-2x.png": "3b5f48ea7da40fdf40b5885888c315b1",
"splash/img/light-3x.gif": "e2e1bd502f1d6a7c4f8ddcbe11fdce73",
"splash/img/light-3x.png": "cb74db85f263cabcec85bb84665b3c69",
"splash/img/light-4x.gif": "b83c0687a6df4261b329b7ec52a585e9",
"splash/img/light-4x.png": "0af348d3924624d502198b699fda13bd",
"splash/img/light-background.gif": "a571a4e85e95dc0b2eeaa336f71f817b",
"version.json": "371812bd00996e2028f610beefedc90b"};
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
