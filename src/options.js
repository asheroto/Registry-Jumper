function verify() {
  var status = document.getElementById('status');
  status.textContent = '';
  chrome.runtime.sendNativeMessage('com.asheroto.regjump', { "status": "validate" }, function (response) {
    if (response == undefined) {
      status.setAttribute('class', 'alert alert-danger');
      status.innerHTML = 'Unable to communicate with RegJump. Please make sure you follow the installation instructions on the Options page.';
    } else if (response.message == 'regjump') {
      status.setAttribute('class', 'alert alert-warning');
      status.innerHTML = 'Unable to communicate with RegJump. Please make sure you follow the installation instructions on the Options page.';
    } else if (response.message == 'ok') {
      status.setAttribute('class', 'alert alert-info');
      status.innerHTML = 'RegJump communication established! You can now begin using Registry Jumper.<br><br>On a new tab, select a registry key, right-click, and select "Open in Registry Editor". If you already have a tab pulled up you will need to refresh the tab in order for the extension to work.';
    }
  });
}

function setExtensionId() {
  var manifest = chrome.runtime.getManifest();
  var version = manifest.version;
  var isUnpacked = false;

  // Check if the extension is unpacked by trying to access the URL of the background script
  try {
    var bgUrl = chrome.runtime.getURL(manifest.background.scripts[0]);
    isUnpacked = bgUrl.startsWith('chrome-extension://');
  } catch (e) {
    console.log("Unable to determine if the extension is unpacked.");
  }

  if (isUnpacked) {
    version += '_0'; // Append _0 for unpacked extensions
  }

  var elements = document.getElementsByClassName('extension_id');
  for (var i = 0; i < elements.length; i++) {
    elements[i].textContent = chrome.runtime.id;
  }
  elements = document.getElementsByClassName('version');
  for (var i = 0; i < elements.length; i++) {
    elements[i].textContent = version;
  }

  var author = document.getElementById('author');
  author.textContent = manifest.author;
  var versionElem = document.getElementById('version');
  versionElem.textContent = "v" + version;
  var homepage_url = document.getElementById('homepage_url');
  homepage_url.href = manifest.homepage_url;
}

function copyToClipboard(text) {
  navigator.clipboard.writeText(text).then(function () {
    alert("Copied to clipboard!");
  }, function (err) {
    alert("Error copying to clipboard: " + err);
  });
}

document.addEventListener('DOMContentLoaded', setExtensionId);
document.getElementById('verify').addEventListener('click', verify);

document.querySelectorAll('.copyable').forEach(function (element) {
  element.addEventListener('click', function () {
    var textToCopy = element.textContent;
    copyToClipboard(textToCopy);
  });
});