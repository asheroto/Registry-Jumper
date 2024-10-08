// Disable for production
const DEBUG = false;

// ========================================================================== //
// Functions
// ========================================================================== //

function verify() {
  // Disable the verify button
  var verifyButton = document.getElementById('verify');
  verifyButton.disabled = true;

  var status = document.getElementById('status');
  status.textContent = '';
  status.setAttribute('class', 'hidden');

  chrome.runtime.sendNativeMessage('com.asheroto.regjump', { "status": "validate" }, function (response) {
    if (response == undefined) {
      status.setAttribute('class', 'alert alert-danger');
      status.innerHTML = 'Unable to communicate with RegJump. Please make sure you follow the installation instructions on the Options page.';
    } else if (response.message == 'regjump') {
      status.setAttribute('class', 'alert alert-warning');
      status.innerHTML = 'Unable to communicate with RegJump. Please make sure you follow the installation instructions on the Options page.';
    } else if (response.message == 'ok') {
      status.setAttribute('class', 'alert alert-info');
      status.innerHTML = 'RegJump communication established! You can now start using Registry Jumper.<br><br>To use the extension, open a new tab, then select a registry key, right-click, and choose <code>Open [key] in Registry Editor</code>. If a tab is already open, please refresh it to ensure the extension functions correctly.';
    }

    // Enable the verify button
    verifyButton.disabled = false;
  });
}

function setExtensionId() {
  var manifest = chrome.runtime.getManifest();
  var version = manifest.version;

  var elements = document.getElementsByClassName('extension_id');
  for (var i = 0; i < elements.length; i++) {
    elements[i].textContent = chrome.runtime.id;
  }
  elements = document.getElementsByClassName('version');
  for (var i = 0; i < elements.length; i++) {
    elements[i].textContent = version;
  }

  var versionElem = document.getElementById('version');
  versionElem.textContent = "v" + version;
}

function copyToClipboard(text) {
  navigator.clipboard.writeText(text).then(function () {
    alert("Copied to clipboard!");
  }, function (err) {
    alert("Error copying to clipboard: " + err);
  });
}

// ========================================================================== //
// Event Listeners
// ========================================================================== //

document.addEventListener('DOMContentLoaded', setExtensionId);
document.getElementById('verify').addEventListener('click', verify);

// ========================================================================== //
// Copy the text content of the element when it is clicked
// ========================================================================== //

document.querySelectorAll('.copyable').forEach(function (element) {
  element.addEventListener('click', function () {
    var textToCopy = element.textContent;
    copyToClipboard(textToCopy);
  });
});

// ========================================================================== //
// Strings
// ========================================================================== //

const strings = {
  filePrefix: 'Registry Jumper',
  storeName: {
    Chrome: 'the Chrome Web Store',
    Edge: 'Edge Add-ons'
  },
  browserName: {
    Chrome: 'Chrome',
    Edge: 'Edge'
  }
};

// ========================================================================== //
// URLs
// ========================================================================== //

const urls = {
  storeUrl: {
    Chrome: 'chrome.google.com',
    Edge: 'microsoftedge.microsoft.com'
  },
  storeDetailUrl: {
    Chrome: 'https://chrome.google.com/webstore/detail/{EXTENSION_ID}',
    Edge: 'https://microsoftedge.microsoft.com/addons/detail/{EXTENSION_ID}'
  }
};

// ========================================================================== //
// Define browserAPI to handle both Chrome and other browsers (like Firefox)
// ========================================================================== //
const browserAPI = typeof browser !== 'undefined' ? browser : chrome;

// ========================================================================== //
// Determine the browser based on the user agent
// ========================================================================== //
const getBrowser = function () {
  const userAgent = navigator.userAgent;
  if (/Chrome/.test(userAgent) && !/Edg\//.test(userAgent)) {
    return 'Chrome';
  } else if (/Edg\//.test(userAgent)) {
    return 'Edge';
  } else {
    return 'Chrome';  // Default to Chrome
  }
};

// ========================================================================== //
// Replace placeholders
// ========================================================================== //
document.addEventListener('DOMContentLoaded', function () {
  let currentBrowser = getBrowser();
  let storeName = strings.storeName[currentBrowser];
  let storeUrl = urls.storeDetailUrl[currentBrowser].replace('{EXTENSION_ID}', browserAPI.runtime.id);

  if (DEBUG) {
    console.log('Current Browser:', currentBrowser);
    console.log('Store Name:', storeName);
    console.log('Store URL:', storeUrl);
  }

  // Link to the extension on the store
  let storeUrlElement = document.getElementById('store_url');
  storeUrlElement.href = storeUrl;
});