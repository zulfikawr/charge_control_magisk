# Charge Control Magisk Module

## Description

This Magisk module provides control over the charging current on Magisk-rooted Android devices. It allows users to customize and manage the charging current settings for different power supply sources.

## Features

- Flexible Charging Current Management: Adjust the charging current for various power supply sources such as USB, battery, and more.
- Default and Custom Settings: Choose between default charging settings or set a custom charging current based on your preferences.
- Immediate changes: No need to reboot for changes to take effect.

## Usage

![](charge_control.gif)
  
- Flash the module in Magisk Manager.
- Adjust Charging Current:
  - Open a terminal emulator (Termux recommended).
  - Type `su -c charge` to access the charging control options.
  - Choose between default or custom charging current settings.
  - For custom settings, input the desired charging current in milliamps (mA).

### USB 3.0 Charging (900mA)

For USB 3.0 ports on computers, set the custom charging current to **900** mA to utilize the full USB 3.0 capability. The module now includes additional sysfs paths to properly negotiate USB 3.0 current limits.

**Note:** Some devices may require you to:
1. Connect the phone to the USB 3.0 port
2. Run `su -c charge` and set custom current to 900 mA
3. The change takes effect immediately without reboot

## License

This module is released under the GNU General Public License v3 (GPL-3). All module code is open source.

Disclaimer: Charging settings customization may affect device performance. Use with caution.

