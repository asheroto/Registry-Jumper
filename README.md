
# Registry Jumper

## Overview

Registry Jumper is a Chrome/Edge/Brave extension that allows you to open selected registry keys directly in Regedit using [Sysinternals RegJump](https://learn.microsoft.com/en-us/sysinternals/downloads/regjump). This tool is designed to streamline the process of navigating to specific registry keys by providing a context menu option in the browser.

> [!NOTE]
> This project is forked from [Chrome Registry Jumper](https://github.com/hmemcpy/ChromeRegJump). The original project was archived in March 2024 and was removed from the Chrome Web Store. Several improvements have been made from the original.

## Features

- **Open Registry Keys**: Right-click on selected registry keys and open them directly in `regedit` using RegJump.
- **Context Menu Filtering**: The context menu option to `Open in Registry Editor` is only shown for valid registry keys (e.g., HKLM, HKCU). Selecting non-registry keys will not display the option.
- **Automated Setup**: An easy installation script to download and set up RegJump and the Chrome native messaging host.
- **Enhanced Debugging**: Improved debugging to help diagnose issues.

## Installation

Users can install Registry Jumper from the Chrome Web Store: [Chrome Web Store Link](https://chrome.google.com/webstore/detail/registry-jumper/placeholder-link)

## Setup

To get Registry Jumper up and running, follow these steps:

### 1. Run the Installation Script

Register the host program to communicate with RegJump by running the `install.cmd` script located in the installation folder.

Click the path below to copy to clipboard, then press Win+R, paste it in the Run box, and press enter to run the install script.

If this path doesn't exist, you may be using a non-default profile. In that case, you can find your Chrome profile path by visiting `chrome://version` and looking at the `Profile Path` line. Unfortunately, due to Chrome security restrictions, this extension cannot find the profile path automatically.

The default installation path is based on your browser and operating system. For example:

- **Chrome (Windows)**: `%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\<extension_id>\<version>_0\host\install.cmd`
- **Brave (Windows)**: `%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Extensions\<extension_id>\<version>_0\host\install.cmd`
- **Edge (Windows)**: `%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Extensions\<extension_id>\<version>_0\host\install.cmd`
- **Opera (Windows)**: `%LOCALAPPDATA%\Opera Software\Opera Stable\User Data\Default\Extensions\<extension_id>\<version>_0\host\install.cmd`

### 2. Verify the Installation

When you're done, press the Verify button on the Options page of the extension to make sure everything is up and running.

## Usage

1. **Select a Registry Key**: On a new tab, select a registry key text (e.g., `HKEY_LOCAL_MACHINE\Software\...`).
2. **Right-Click and Open**: Right-click the selected text and choose "Open in Registry Editor" from the context menu.
3. **Refresh Tab**: If you already have a tab pulled up, you will need to refresh the tab in order for the extension to work.

## Open Source

This extension is fully open-source to ensure both transparency and security. You can view and even contribute to the source code.

## Contributing Guidelines

We value community contributions and encourage you to get involved. For issues, feature requests, or code contributions, please visit our GitHub repository.

- If you come across any issues, open a new issue on GitHub.
- To suggest new features, you can also submit an issue.
- If you wish to contribute code, we accept Pull Requests. Be sure to read our [contributing guidelines](https://github.com/asheroto/Registry-Jumper/blob/main/CONTRIBUTING.md) for the required code style.

Detailed instructions on how to contribute can be found on the [contributing guidelines](https://github.com/asheroto/Registry-Jumper/blob/main/CONTRIBUTING.md) page. Thank you for helping to improve our Chrome extension.

## Support

If you found this extension helpful and want to show your appreciation, consider making a small donation to the developer. Your support is greatly appreciated and helps keep the coffee flowing, allowing me to continue working on other cool projects like this!

[![Buy Me a Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=asheroto&button_colour=FFDD00&font_colour=000000&font_family=Lato&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/asheroto)

## Rate and Feedback

If you enjoyed using this extension, please take a moment to [rate it on the Chrome Web Store](https://chrome.google.com/webstore/detail/registry-jumper/abc123).

For feature requests and bug reports, visit the [Issues](https://github.com/asheroto/Registry-Jumper/issues) tab.

## To-Do List

- [x] Placeholder