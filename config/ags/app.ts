#!/usr/bin/ags run

import { Bar } from "./widgets/bar/Bar"
import { ControlCenter } from "./widgets/controlc/ControlCenter";
import { NotificationPopups } from "./widgets/notifications/NotificationPopups";
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
		const widgets = new Map<Gdk.Monitor, Gtk.Widget>()
		for (const gdkMonitor of App.get_monitors()) {
			widgets.set(gdkMonitor, Bar(gdkMonitor));
			widgets.set(gdkMonitor, NotificationPopups(gdkMonitor));
		}

		// Create windows for newly connected monitors.
		// NOTE: Need to be delayed because workspaces are not initialized immediately.
		App.connect("monitor-added", (_, gdkMonitor) => {
			setTimeout(() => {
				widgets.set(gdkMonitor, Bar(gdkMonitor));
				widgets.set(gdkMonitor, NotificationPopups(gdkMonitor));
			}, 1000);
		})

		// Remove windows for removed monitors.
		App.connect("monitor-removed", (_, gdkMonitor) => {
			widgets.get(gdkMonitor)?.destroy();
			widgets.delete(gdkMonitor);
		})

		ControlCenter();
	},
})
