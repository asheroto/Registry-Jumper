// Valid registry prefixes
var validPrefixes = ["HKEY_CURRENT_USER", "HKEY_LOCAL_MACHINE", "HKEY_CLASSES_ROOT", "HKEY_USERS", "HKEY_CURRENT_CONFIG"];

// On selection change, check if the selected text is a valid registry prefix
document.addEventListener('selectionchange', function () {
    var selectedText = window.getSelection().toString().trim();

    // Check if the selected text matches any valid registry prefix
    var isValid = validPrefixes.some(prefix => selectedText.startsWith(prefix));
    if (isValid) {
        try {
            chrome.runtime.sendMessage({ type: 'selectionChanged', selectionText: selectedText }, function (response) {
                if (chrome.runtime.lastError) {
                    console.error("Error: " + chrome.runtime.lastError.message);
                }
            });
        } catch (error) {
            console.error("Error sending message: ", error);
        }
    }
});