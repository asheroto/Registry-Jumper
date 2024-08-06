// Disable for production
const DEBUG = false;

var validPrefixes = ["HKEY_CURRENT_USER", "HKEY_LOCAL_MACHINE", "HKEY_CLASSES_ROOT", "HKEY_USERS", "HKEY_CURRENT_CONFIG"];

var openInRegJump = function (selectedText) {
  chrome.runtime.sendNativeMessage('com.asheroto.regjump', { text: selectedText.trim() }, function (response) {
    if (chrome.runtime.lastError) {
      if (chrome.runtime.lastError.message === "Specified native messaging host not found.") {
        alert("Error communicating with RegJump. Open the Extensions menu, click the Registry Jumper menu, click on Options, and complete the setup by following the instructions.");
      }
      if (DEBUG) console.error("Native message error: " + chrome.runtime.lastError.message);
    } else {
      if (DEBUG) {
        console.log("Received response: ", response);
        if (response && response.message) {
          console.log("Message from native app: " + response.message);
        } else {
          console.log("Received undefined or empty response");
        }
      }
    }
  });
}

chrome.runtime.onInstalled.addListener(function (details) {
  if (DEBUG) console.log("Extension installed or updated");
  if (details.reason == "install") {
    var optionsUrl = chrome.runtime.getURL('options.html');
    chrome.tabs.create({ url: optionsUrl });
  }
});

chrome.contextMenus.create({
  id: "openInRegJump",
  title: "Open %s in Registry Editor",
  contexts: ["selection"],
  visible: false
}, function () {
  if (chrome.runtime.lastError) {
    if (DEBUG) console.error("Error creating context menu: " + chrome.runtime.lastError.message);
  } else {
    if (DEBUG) console.log("Context menu created successfully");
  }
});

chrome.contextMenus.onClicked.addListener(function (info, tab) {
  if (info.menuItemId === "openInRegJump") {
    if (DEBUG) console.log("Context menu clicked with text: " + info.selectionText);
    openInRegJump(info.selectionText);
  }
});

chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {
  if (DEBUG) console.log("Message received from content script: ", message);
  if (message.type === 'selectionChanged') {
    var trimmedText = message.selectionText.trim();
    var isValid = validPrefixes.some(prefix => trimmedText.startsWith(prefix));
    chrome.contextMenus.update("openInRegJump", {
      visible: isValid
    }, function () {
      if (chrome.runtime.lastError) {
        if (DEBUG) console.error("Error updating context menu: " + chrome.runtime.lastError.message);
      } else {
        if (DEBUG) console.log("Context menu updated successfully");
      }
    });
  }
  sendResponse();
});