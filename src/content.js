document.addEventListener('selectionchange', function () {
    var selectedText = window.getSelection().toString();

    try {
        chrome.runtime.sendMessage({ type: 'selectionChanged', selectionText: selectedText }, function (response) {
            if (chrome.runtime.lastError) {
                console.error("Error: " + chrome.runtime.lastError.message);
            }
        });
    } catch (error) {
        console.error("Error sending message: ", error);
    }
});