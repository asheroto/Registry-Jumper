
[![Release](https://img.shields.io/github/v/release/asheroto/Registry-Jumper)](https://github.com/asheroto/Registry-Jumper/releases)
[![GitHub Release Date - Published_At](https://img.shields.io/github/release-date/asheroto/Registry-Jumper)](https://github.com/asheroto/Registry-Jumper/releases)
[![GitHub Downloads - All Releases](https://img.shields.io/github/downloads/asheroto/Registry-Jumper/total)](https://github.com/asheroto/Registry-Jumper/releases)
[![GitHub Sponsor](https://img.shields.io/github/sponsors/asheroto?label=Sponsor&logo=GitHub)](https://github.com/sponsors/asheroto?frequency=one-time&sponsor=asheroto)
<a href="https://ko-fi.com/asheroto"><img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Ko-Fi Button" height="20px"></a>
<a href="https://www.buymeacoffee.com/asheroto"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=Registry-Jumper&button_colour=FFDD00&font_colour=000000&font_family=Lato&outline_colour=000000&coffee_colour=ffffff)" height="40px"></a>

# Registry Jumper

> [!IMPORTANT]
> This is a new extension and was just recently submitted to the Chrome Web Store. It may take a few days for it to be approved and publicly accessible.

## Overview

Registry Jumper is a Chrome/Edge/Brave extension that allows you to open selected registry keys directly in Regedit using [Sysinternals RegJump](https://learn.microsoft.com/en-us/sysinternals/downloads/regjump). This tool is designed to streamline the process of navigating to specific registry keys by providing a context menu option in the browser.

> [!NOTE]
> This project is forked from [Chrome Registry Jumper](https://github.com/hmemcpy/ChromeRegJump). The original project was archived in March 2024 and was removed from the Chrome Web Store. Several improvements have been made from the original.

## Features

- **Open Registry Keys**: Right-click on selected registry keys and open them directly in `regedit` using RegJump.
- **Context Menu Filtering**: The context menu option to `Open in Registry Editor` is only shown for valid registry keys (e.g., HKLM, HKCU). Selecting non-registry keys will not display the option.
- **Automated Setup**: An easy installation script to download and set up RegJump and the Chrome native messaging host.
- **Enhanced Debugging**: Improved debugging to help diagnose issues.

## Supported Prefixes

- HKCU / HKEY_CURRENT_USER
- HKLM / HKEY_LOCAL_MACHINE
- HKCR / HKEY_CLASSES_ROOT
- HKU / HKEY_USERS
- HKCC / HKEY_CURRENT_CONFIG

## Getting Started

### Installation

Users can install Registry Jumper from the Chrome Web Store: [Chrome Web Store Link](https://chromewebstore.google.com/detail/registry-jumper/oeclndhlgfilojjhmciifnjopekeieei)

### Setup

- Open the `Extensions` menu
- Click the `Registry Jumper` menu
- Click on `Options`
- Complete the setup by following the instructions

### Usage

1. **Select a Registry Key**: On a new tab, select a registry key text (e.g., `HKEY_LOCAL_MACHINE\Software\...`).
2. **Right-Click and Open**: Right-click the selected text and choose "Open in Registry Editor" from the context menu.
3. **Refresh Tab**: If you already have a tab pulled up, you will need to refresh the tab in order for the extension to work.

## Troubleshooting

If you encounter issues with the extension, try running the installer again. While functionality typically remains stable across versions, some changes can cause connection issues. Running the install script should resolve these problems.

If you’re still having issues and need help, please open an [issue](https://github.com/asheroto/Registry-Jumper/issues).

## How it Works

When you run the `install.ps1` script, it downloads `regjump.exe` from Sysinternals into the `<extension>\<version>\host\regjump` folder. The script then copies the `host` folder to the root extension directory to ensure that functionality remains intact even if the extension version changes.

Next, the installer sets up Chrome Native Messaging to enable communication between the extension and RegJump, allowing registry information to be passed seamlessly.

When a valid registry prefix is detected, the extension's context menu is shown, and the selected information is passed to RegJump through Chrome Native Messaging, ensuring relevant functionality.

## Community & Contributions

### Open Source

This extension is fully open-source to ensure both transparency and security. You can view and even contribute to the source code.

### Contributing Guidelines

We value community contributions and encourage you to get involved. For issues, feature requests, or code contributions, please visit our GitHub repository.

- If you come across any issues, open a new issue on GitHub.
- To suggest new features, you can also submit an issue.
- If you wish to contribute code, we accept Pull Requests. Be sure to read our [contributing guidelines](https://github.com/asheroto/Registry-Jumper/blob/main/CONTRIBUTING.md) for the required code style.

Detailed instructions on how to contribute can be found on the [contributing guidelines](https://github.com/asheroto/Registry-Jumper/blob/main/CONTRIBUTING.md) page. Thank you for helping to improve our Chrome extension.

## Support

If you found this extension helpful and want to show your appreciation, consider making a small donation to the developer. Your support is greatly appreciated and helps keep the coffee flowing, allowing me to continue working on other cool projects like this!

[![Buy Me a Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=asheroto&button_colour=FFDD00&font_colour=000000&font_family=Lato&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/asheroto)

## Rate and Feedback

If you enjoyed using this extension, please take a moment to [rate it on the Chrome Web Store](https://chromewebstore.google.com/detail/registry-jumper/oeclndhlgfilojjhmciifnjopekeieei).

For feature requests and bug reports, visit the [Issues](https://github.com/asheroto/Registry-Jumper/issues) tab.

## To-Do List

- [x] Placeholder