# IP Change Notification

This tool listens for IP address changes on your network interfaces and shows a popup everytime an address changes or an interface is connected or disconnected. It is intended to be used on technicians service notebooks that are used in many different networks. A tray icon is displayed since this tool mostly runs in background. You can quickly access the network interface settings dialog by the tray menu or open the tools main window to see more interface information. It's possible to filter network interfaces by name, so you just get notified on interfaces you are interested in.

![Screenshot](_res/popup_animation.gif?raw=true)


## Features

 - Shows popup notifications on IP address changes. (for example at (un-)plugging an ethernet cable or on DHCP responses)
 - Quick access to the connection properties dialogs. (less mouseclicks to change IP addresses)
 - Quick access to recognized network tools like Wireshark. (You can define custom rules for your preferred tools)
 - Ping graph with optional acoustic notification on connection status changes (alive / not alive).
 - Random password generator
 - Main form shows information comparable to "ipconfig", but filtered so you see interesting interfaces first.
 - Configurable filter, so you only see popup notifications for interfaces you are interested into.


## Installation

Extract the downloaded ZIP file to a location where the program has write access for the settings file. My personal recommendation is to permanently show the tray icon in the taskbar settings. (for the quick access menus)


## Build

Current versions are built with Delphi 10.3 Community Edition, since there are no special requirements it should compile on most Delphi versions. The source contains some Winapi definitions that are missing in the official Delphi headers, they may be removed in future versions. Release binarys are packed with UPX.


## Screenshots

![connection_properties](_res/connection_properties.png?raw=true)

![swiss_army_knife](_res/swiss_army_knife.png?raw=true)

![settings](_res/settings.png?raw=true)

![mainwindow](_res/mainwindow.png?raw=true)

![ping_graph](_res/ping_graph.png?raw=true)