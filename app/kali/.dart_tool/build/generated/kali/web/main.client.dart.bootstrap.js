/* ENTRYPOINT_EXTENTION_MARKER */
(function() {
var _currentDirectory = (function () {
  var _url;
  var lines = new Error().stack.split('\n');
  function lookupUrl() {
    if (lines.length > 2) {
      var match = lines[1].match(/^\s+at (.+):\d+:\d+$/);
      // Chrome.
      if (match) return match[1];
      // Chrome nested eval case.
      match = lines[1].match(/^\s+at eval [(](.+):\d+:\d+[)]$/);
      if (match) return match[1];
      // Edge.
      match = lines[1].match(/^\s+at.+\((.+):\d+:\d+\)$/);
      if (match) return match[1];
      // Firefox.
      match = lines[0].match(/[<][@](.+):\d+:\d+$/)
      if (match) return match[1];
    }
    // Safari.
    return lines[0].match(/[@](.+):\d+:\d+$/)[1];
  }
  _url = lookupUrl();
  var lastSlash = _url.lastIndexOf('/');
  if (lastSlash == -1) return _url;
  var currentDirectory = _url.substring(0, lastSlash + 1);
  return currentDirectory;
})();

var baseUrl = (function () {
  // Attempt to detect --precompiled mode for tests, and set the base url
  // appropriately, otherwise set it to '/'.
  var pathParts = location.pathname.split("/");
  if (pathParts[0] == "") {
    pathParts.shift();
  }
  if (pathParts.length > 1 && pathParts[1] == "test") {
    return "/" + pathParts.slice(0, 2).join("/") + "/";
  }
  // Attempt to detect base url using <base href> html tag
  // base href should start and end with "/"
  if (typeof document !== 'undefined') {
    var el = document.getElementsByTagName('base');
    if (el && el[0] && el[0].getAttribute("href") && el[0].getAttribute
    ("href").startsWith("/") && el[0].getAttribute("href").endsWith("/")){
      return el[0].getAttribute("href");
    }
  }
  // return default value
  return "/";
}());

let modulePaths = {
 "dart_sdk": "packages/build_web_compilers/src/dev_compiler/dart_sdk",
 "packages/adaptive_number/adaptive_number": "packages/adaptive_number/adaptive_number.ddc",
 "packages/app_bloc/app_bloc": "packages/app_bloc/app_bloc.ddc",
 "packages/app_bloc/auth/auth_bloc": "packages/app_bloc/auth/auth_bloc.ddc",
 "packages/app_bloc/base/base_bloc": "packages/app_bloc/base/base_bloc.ddc",
 "packages/app_bloc/bookings/booking_heatmap_aggregate": "packages/app_bloc/bookings/booking_heatmap_aggregate.ddc",
 "packages/app_bloc/bookings/booking_heatmap_bloc": "packages/app_bloc/bookings/booking_heatmap_bloc.ddc",
 "packages/app_bloc/bookings/bookings_bloc": "packages/app_bloc/bookings/bookings_bloc.ddc",
 "packages/app_bloc/injection": "packages/app_bloc/injection.ddc",
 "packages/app_bloc/injection.config": "packages/app_bloc/injection.config.ddc",
 "packages/app_bloc/ladders/ladders_bloc": "packages/app_bloc/ladders/ladders_bloc.ddc",
 "packages/app_bloc/league_fixtures/league_fixtures_bloc": "packages/app_bloc/league_fixtures/league_fixtures_bloc.ddc",
 "packages/app_bloc/locations/locations_bloc": "packages/app_bloc/locations/locations_bloc.ddc",
 "packages/app_bloc/settings/settings_bloc": "packages/app_bloc/settings/settings_bloc.ddc",
 "packages/app_bloc/users/users_bloc": "packages/app_bloc/users/users_bloc.ddc",
 "packages/async/async": "packages/async/async.ddc",
 "packages/auth/auth": "packages/auth/auth.ddc",
 "packages/auto_mappr_annotation/auto_mappr_annotation": "packages/auto_mappr_annotation/auto_mappr_annotation.ddc",
 "packages/bloc/bloc": "packages/bloc/bloc.ddc",
 "packages/client_models/client_models": "packages/client_models/client_models.ddc",
 "packages/client_supabase/client_supabase": "packages/client_supabase/client_supabase.ddc",
 "packages/client_supabase/client_supabase_auth": "packages/client_supabase/client_supabase_auth.ddc",
 "packages/clock/clock": "packages/clock/clock.ddc",
 "packages/collection/collection": "packages/collection/collection.ddc",
 "packages/collection/src/algorithms": "packages/collection/src/algorithms.ddc",
 "packages/collection/src/canonicalized_map": "packages/collection/src/canonicalized_map.ddc",
 "packages/collection/src/comparators": "packages/collection/src/comparators.ddc",
 "packages/collection/src/iterable_zip": "packages/collection/src/iterable_zip.ddc",
 "packages/collection/src/priority_queue": "packages/collection/src/priority_queue.ddc",
 "packages/collection/src/utils": "packages/collection/src/utils.ddc",
 "packages/convert/convert": "packages/convert/convert.ddc",
 "packages/crypto/crypto": "packages/crypto/crypto.ddc",
 "packages/dart_jsonwebtoken/dart_jsonwebtoken": "packages/dart_jsonwebtoken/dart_jsonwebtoken.ddc",
 "packages/dio/dio": "packages/dio/dio.ddc",
 "packages/ed25519_edwards/ed25519_edwards": "packages/ed25519_edwards/ed25519_edwards.ddc",
 "packages/fixnum/fixnum": "packages/fixnum/fixnum.ddc",
 "packages/freezed_annotation/freezed_annotation": "packages/freezed_annotation/freezed_annotation.ddc",
 "packages/functions_client/functions_client": "packages/functions_client/functions_client.ddc",
 "packages/get_it/get_it": "packages/get_it/get_it.ddc",
 "packages/gotrue/gotrue": "packages/gotrue/gotrue.ddc",
 "packages/http/http": "packages/http/http.ddc",
 "packages/http/src/boundary_characters": "packages/http/src/boundary_characters.ddc",
 "packages/http_parser/http_parser": "packages/http_parser/http_parser.ddc",
 "packages/injectable/injectable": "packages/injectable/injectable.ddc",
 "packages/intl/date_symbols": "packages/intl/date_symbols.ddc",
 "packages/intl/intl": "packages/intl/intl.ddc",
 "packages/intl/number_symbols": "packages/intl/number_symbols.ddc",
 "packages/intl/number_symbols_data": "packages/intl/number_symbols_data.ddc",
 "packages/intl/src/date_format_internal": "packages/intl/src/date_format_internal.ddc",
 "packages/intl/src/intl/bidi": "packages/intl/src/intl/bidi.ddc",
 "packages/jaspr/client": "packages/jaspr/client.ddc",
 "packages/jaspr/src/client/utils": "packages/jaspr/src/client/utils.ddc",
 "packages/jaspr_router/jaspr_router": "packages/jaspr_router/jaspr_router.ddc",
 "packages/json_annotation/json_annotation": "packages/json_annotation/json_annotation.ddc",
 "packages/jwt_decode/jwt_decode": "packages/jwt_decode/jwt_decode.ddc",
 "packages/kali/auth/browser_gotrue_storage": "packages/kali/auth/browser_gotrue_storage.ddc",
 "packages/kali/auth/supabase_web_session_persistence": "packages/kali/auth/supabase_web_session_persistence.ddc",
 "packages/kali/bookings/bookings_member_error_messages": "packages/kali/bookings/bookings_member_error_messages.ddc",
 "packages/kali/bookings/member_booking_grid": "packages/kali/bookings/member_booking_grid.ddc",
 "packages/kali/bootstrap": "packages/kali/bootstrap.ddc",
 "packages/kali/components/admin_layout": "packages/kali/components/admin_layout.ddc",
 "packages/kali/components/admin_placeholder_panel": "packages/kali/components/admin_placeholder_panel.ddc",
 "packages/kali/components/booking_admin_heatmap_panel": "packages/kali/components/booking_admin_heatmap_panel.ddc",
 "packages/kali/main.client": "packages/kali/main.client.ddc",
 "packages/kali/navigation/auth_route_guard": "packages/kali/navigation/auth_route_guard.ddc",
 "packages/kali/navigation/kali_admin_eligibility": "packages/kali/navigation/kali_admin_eligibility.ddc",
 "packages/kali/navigation/nav_items": "packages/kali/navigation/nav_items.ddc",
 "packages/kali/pages/admin_bookings_page": "packages/kali/pages/admin_bookings_page.ddc",
 "packages/kali/pages/bookings_page": "packages/kali/pages/bookings_page.ddc",
 "packages/kali/pages/fixtures_page": "packages/kali/pages/fixtures_page.ddc",
 "packages/kali/pages/home": "packages/kali/pages/home.ddc",
 "packages/kali/pages/ladder_page": "packages/kali/pages/ladder_page.ddc",
 "packages/kali/pages/login_page": "packages/kali/pages/login_page.ddc",
 "packages/kali/pages/splash_page": "packages/kali/pages/splash_page.ddc",
 "packages/kali/pages/users_page": "packages/kali/pages/users_page.ddc",
 "packages/kali/root_app": "packages/kali/root_app.ddc",
 "packages/kali/utils/admin_bookings_helpers": "packages/kali/utils/admin_bookings_helpers.ddc",
 "packages/kali/utils/booking_slot_label": "packages/kali/utils/booking_slot_label.ddc",
 "packages/logging/logging": "packages/logging/logging.ddc",
 "packages/meta/meta": "packages/meta/meta.ddc",
 "packages/meta/meta_meta": "packages/meta/meta_meta.ddc",
 "packages/middleware/middleware": "packages/middleware/middleware.ddc",
 "packages/middleware/middleware_clients": "packages/middleware/middleware_clients.ddc",
 "packages/middleware/src/clients/bookings/booking_slot_schedule": "packages/middleware/src/clients/bookings/booking_slot_schedule.ddc",
 "packages/mime/mime": "packages/mime/mime.ddc",
 "packages/path/path": "packages/path/path.ddc",
 "packages/pointycastle/adapters/stream_cipher_as_block_cipher": "packages/pointycastle/adapters/stream_cipher_as_block_cipher.ddc",
 "packages/pointycastle/asn1/asn1_encoding_rule": "packages/pointycastle/asn1/asn1_encoding_rule.ddc",
 "packages/pointycastle/asn1/asn1_tags": "packages/pointycastle/asn1/asn1_tags.ddc",
 "packages/pointycastle/asn1/object_identifiers": "packages/pointycastle/asn1/object_identifiers.ddc",
 "packages/pointycastle/asn1/object_identifiers_database": "packages/pointycastle/asn1/object_identifiers_database.ddc",
 "packages/pointycastle/asn1/unsupported_asn1_encoding_rule_exception": "packages/pointycastle/asn1/unsupported_asn1_encoding_rule_exception.ddc",
 "packages/pointycastle/asn1/unsupported_asn1_tag_exception": "packages/pointycastle/asn1/unsupported_asn1_tag_exception.ddc",
 "packages/pointycastle/asn1/unsupported_object_identifier_exception": "packages/pointycastle/asn1/unsupported_object_identifier_exception.ddc",
 "packages/pointycastle/block/des_base": "packages/pointycastle/block/des_base.ddc",
 "packages/pointycastle/digests/xof_utils": "packages/pointycastle/digests/xof_utils.ddc",
 "packages/pointycastle/src/ct": "packages/pointycastle/src/ct.ddc",
 "packages/pointycastle/src/ufixnum": "packages/pointycastle/src/ufixnum.ddc",
 "packages/postgrest/postgrest": "packages/postgrest/postgrest.ddc",
 "packages/realtime_client/realtime_client": "packages/realtime_client/realtime_client.ddc",
 "packages/retry/retry": "packages/retry/retry.ddc",
 "packages/rxdart/rxdart": "packages/rxdart/rxdart.ddc",
 "packages/rxdart/src/streams/combine_latest": "packages/rxdart/src/streams/combine_latest.ddc",
 "packages/rxdart/src/transformers/backpressure/backpressure": "packages/rxdart/src/transformers/backpressure/backpressure.ddc",
 "packages/rxdart/src/utils/composite_subscription": "packages/rxdart/src/utils/composite_subscription.ddc",
 "packages/rxdart/src/utils/error_and_stacktrace": "packages/rxdart/src/utils/error_and_stacktrace.ddc",
 "packages/rxdart/streams": "packages/rxdart/streams.ddc",
 "packages/rxdart/transformers": "packages/rxdart/transformers.ddc",
 "packages/rxdart/utils": "packages/rxdart/utils.ddc",
 "packages/session_storage/session_storage": "packages/session_storage/session_storage.ddc",
 "packages/source_span/source_span": "packages/source_span/source_span.ddc",
 "packages/storage_client/src/constants": "packages/storage_client/src/constants.ddc",
 "packages/stream_channel/stream_channel": "packages/stream_channel/stream_channel.ddc",
 "packages/string_scanner/src/charcode": "packages/string_scanner/src/charcode.ddc",
 "packages/supabase/src/auth_http_client": "packages/supabase/src/auth_http_client.ddc",
 "packages/term_glyph/src/generated/ascii_glyph_set": "packages/term_glyph/src/generated/ascii_glyph_set.ddc",
 "packages/typed_data/src/typed_buffer": "packages/typed_data/src/typed_buffer.ddc",
 "packages/typed_data/src/typed_queue": "packages/typed_data/src/typed_queue.ddc",
 "packages/typed_data/typed_buffers": "packages/typed_data/typed_buffers.ddc",
 "packages/universal_web/js_interop": "packages/universal_web/js_interop.ddc",
 "packages/universal_web/web": "packages/universal_web/web.ddc",
 "packages/web/src/dom": "packages/web/src/dom.ddc",
 "packages/web/web": "packages/web/web.ddc",
 "packages/web_socket/src/utils": "packages/web_socket/src/utils.ddc",
 "packages/web_socket/web_socket": "packages/web_socket/web_socket.ddc",
 "packages/web_socket_channel/adapter_web_socket_channel": "packages/web_socket_channel/adapter_web_socket_channel.ddc",
 "packages/web_socket_channel/html": "packages/web_socket_channel/html.ddc",
 "packages/web_socket_channel/web_socket_channel": "packages/web_socket_channel/web_socket_channel.ddc",
 "packages/yet_another_json_isolate/src/_isolates_web": "packages/yet_another_json_isolate/src/_isolates_web.ddc",
 "web/main.client": "main.client.ddc"
};
if(!window.$dartLoader) {
   window.$dartLoader = {
     appDigests: _currentDirectory + 'main.client.digests',
     moduleIdToUrl: new Map(),
     urlToModuleId: new Map(),
     rootDirectories: new Array(),
     // Used in package:build_runner/src/server/build_updates_client/hot_reload_client.dart
     moduleParentsGraph: new Map(),
     moduleLoadingErrorCallbacks: new Map(),
     forceLoadModule: function (moduleName, callback, onError) {
       // dartdevc only strips the final extension when adding modules to source
       // maps, so we need to do the same.
       if (moduleName.endsWith('.ddc')) {
         moduleName = moduleName.substring(0, moduleName.length - 4);
       }
       if (typeof onError != 'undefined') {
         var errorCallbacks = $dartLoader.moduleLoadingErrorCallbacks;
         if (!errorCallbacks.has(moduleName)) {
           errorCallbacks.set(moduleName, new Set());
         }
         errorCallbacks.get(moduleName).add(onError);
       }
       requirejs.undef(moduleName);
       requirejs([moduleName], function() {
         if (typeof onError != 'undefined') {
           errorCallbacks.get(moduleName).delete(onError);
         }
         if (typeof callback != 'undefined') {
           callback();
         }
       });
     },
     getModuleLibraries: null, // set up by _initializeTools
   };
}
let customModulePaths = {};
window.$dartLoader.rootDirectories.push(window.location.origin + baseUrl);
for (let moduleName of Object.getOwnPropertyNames(modulePaths)) {
  let modulePath = modulePaths[moduleName];
  if (modulePath != moduleName) {
    customModulePaths[moduleName] = modulePath;
  }
  var src = window.location.origin + '/' + modulePath + '.js';
  if (window.$dartLoader.moduleIdToUrl.has(moduleName)) {
    continue;
  }
  $dartLoader.moduleIdToUrl.set(moduleName, src);
  $dartLoader.urlToModuleId.set(src, moduleName);
}
// Whenever we fail to load a JS module, try to request the corresponding
// `.errors` file, and log it to the console.
(function() {
  var oldOnError = requirejs.onError;
  requirejs.onError = function(e) {
    if (e.requireModules) {
      if (e.message) {
        // If error occurred on loading dependencies, we need to invalidate ancessor too.
        var ancesor = e.message.match(/needed by: (.*)/);
        if (ancesor) {
          e.requireModules.push(ancesor[1]);
        }
      }
      for (const module of e.requireModules) {
        var errorCallbacks = $dartLoader.moduleLoadingErrorCallbacks.get(module);
        if (errorCallbacks) {
          for (const callback of errorCallbacks) callback(e);
          errorCallbacks.clear();
        }
      }
    }
    if (e.originalError && e.originalError.srcElement) {
      var xhr = new XMLHttpRequest();
      xhr.onreadystatechange = function() {
        if (this.readyState == 4) {
          var message;
          if (this.status == 200) {
            message = this.responseText;
          } else {
            message = "Unknown error loading " + e.originalError.srcElement.src;
          }
          console.error(message);
          var errorEvent = new CustomEvent(
            'dartLoadException', { detail: message });
          window.dispatchEvent(errorEvent);
        }
      };
      xhr.open("GET", e.originalError.srcElement.src + ".errors", true);
      xhr.send();
    }
    // Also handle errors the normal way.
    if (oldOnError) oldOnError(e);
  };
}());

var baseUrl = (function () {
  // Attempt to detect --precompiled mode for tests, and set the base url
  // appropriately, otherwise set it to '/'.
  var pathParts = location.pathname.split("/");
  if (pathParts[0] == "") {
    pathParts.shift();
  }
  if (pathParts.length > 1 && pathParts[1] == "test") {
    return "/" + pathParts.slice(0, 2).join("/") + "/";
  }
  // Attempt to detect base url using <base href> html tag
  // base href should start and end with "/"
  if (typeof document !== 'undefined') {
    var el = document.getElementsByTagName('base');
    if (el && el[0] && el[0].getAttribute("href") && el[0].getAttribute
    ("href").startsWith("/") && el[0].getAttribute("href").endsWith("/")){
      return el[0].getAttribute("href");
    }
  }
  // return default value
  return "/";
}());
;

require.config({
    baseUrl: baseUrl,
    waitSeconds: 0,
    paths: customModulePaths
});

const modulesGraph = new Map();
function getRegisteredModuleName(moduleMap) {
  if ($dartLoader.moduleIdToUrl.has(moduleMap.name + '.ddc')) {
    return moduleMap.name + '.ddc';
  }
  return moduleMap.name;
}
requirejs.onResourceLoad = function (context, map, depArray) {
  const name = getRegisteredModuleName(map);
  const depNameArray = depArray.map(getRegisteredModuleName);
  if (modulesGraph.has(name)) {
    // TODO Move this logic to better place
    var previousDeps = modulesGraph.get(name);
    var changed = previousDeps.length != depNameArray.length;
    changed = changed || depNameArray.some(function(depName) {
      return !previousDeps.includes(depName);
    });
    if (changed) {
      console.warn("Dependencies graph change for module '" + name + "' detected. " +
        "Dependencies was [" + previousDeps + "], now [" +  depNameArray.map((depName) => depName) +"]. " +
        "Page can't be hot-reloaded, firing full page reload.");
      window.location.reload();
    }
  } else {
    modulesGraph.set(name, []);
    for (const depName of depNameArray) {
      if (!$dartLoader.moduleParentsGraph.has(depName)) {
        $dartLoader.moduleParentsGraph.set(depName, []);
      }
      $dartLoader.moduleParentsGraph.get(depName).push(name);
      modulesGraph.get(name).push(depName);
    }
  }
};
define("main.client.dart.bootstrap", ["web/main.client", "dart_sdk"], function(app, dart_sdk) {
  
  dart_sdk._isolate_helper.startRootIsolate(() => {}, []);
  var baseUrl = (function () {
  // Attempt to detect --precompiled mode for tests, and set the base url
  // appropriately, otherwise set it to '/'.
  var pathParts = location.pathname.split("/");
  if (pathParts[0] == "") {
    pathParts.shift();
  }
  if (pathParts.length > 1 && pathParts[1] == "test") {
    return "/" + pathParts.slice(0, 2).join("/") + "/";
  }
  // Attempt to detect base url using <base href> html tag
  // base href should start and end with "/"
  if (typeof document !== 'undefined') {
    var el = document.getElementsByTagName('base');
    if (el && el[0] && el[0].getAttribute("href") && el[0].getAttribute
    ("href").startsWith("/") && el[0].getAttribute("href").endsWith("/")){
      return el[0].getAttribute("href");
    }
  }
  // return default value
  return "/";
}());

  dart_sdk._debugger.registerDevtoolsFormatter();
  $dartLoader.getModuleLibraries = dart_sdk.dart.getModuleLibraries;
  if (window.$dartStackTraceUtility && !window.$dartStackTraceUtility.ready) {
    window.$dartStackTraceUtility.ready = true;
    let dart = dart_sdk.dart;
    window.$dartStackTraceUtility.setSourceMapProvider(
      function(url) {
        url = url.replace(baseUrl, '/');
        var module = window.$dartLoader.urlToModuleId.get(url);
        if (!module) return null;
        return dart.getSourceMap(module);
      });
  }
  if (typeof document != 'undefined') {
    window.postMessage({ type: "DDC_STATE_CHANGE", state: "start" }, "*");
  }

  /* MAIN_EXTENSION_MARKER */
  (app.web__main$46client || app.main$46client).main();
  var bootstrap = {
      hot$onChildUpdate: function(childName, child) {
        // Special handling for the multi-root scheme uris. We need to strip
        // out the scheme and the top level directory, to match the source path
        // that chrome sees.
        if (childName.startsWith('org-dartlang-app:///')) {
          childName = childName.substring('org-dartlang-app:///'.length);
          var firstSlash = childName.indexOf('/');
          if (firstSlash == -1) return false;
          childName = childName.substring(firstSlash + 1);
        }
        if (childName === "main.client.dart") {
          // Clear static caches.
          dart_sdk.dart.hotRestart();
          child.main();
          return true;
        }
      }
    }
  dart_sdk.dart.trackLibraries("main.client.dart.bootstrap", {
    "main.client.dart.bootstrap": bootstrap
  }, '');
  return {
    bootstrap: bootstrap
  };
});
})();
