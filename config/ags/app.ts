#!/usr/bin/ags run

import { Bar } from "./widgets/bar/Bar"
import { ControlCenter } from "./widgets/controlc/ControlCenter";
// import AppLauncher from "./widgets/launcher/AppLauncher";

import style from "./style.scss";
import { App, Gdk, Gtk } from "astal/gtk3"


//------------------------------------------------------------------------------
// Main astal application.
//
App.start({
	css: style,
	instanceName: "iculture-shell",
	main: () => {
		// Initial setup for monitors.
		const bars = new Map<Gdk.Monitor, Gtk.Widget>()
		for (const gdkMonitor of App.get_monitors())
			bars.set(gdkMonitor, Bar(gdkMonitor));

		// Create windows for newly connected monitors.
		// NOTE: Need to be delayed because workspaces are not initialized immediately.
		App.connect("monitor-added", (_, gdkMonitor) => {
			setTimeout(() => bars.set(gdkMonitor, Bar(gdkMonitor)), 1000);
		})

		// Remove windows for removed monitors.
		App.connect("monitor-removed", (_, gdkMonitor) => {
			bars.get(gdkMonitor)?.destroy();
			bars.delete(gdkMonitor);
		})

		ControlCenter();
	},
})
