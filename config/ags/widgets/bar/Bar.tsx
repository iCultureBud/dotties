import { toggleWindow } from "../../utils/utils";
import { WorkSpaces } from "./workspaces/Workspaces";
import { MediaStatus } from "./mediastatus/MediaStatus";
// import { AppLauncher } from "../launcher/AppLauncher";

import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import { Variable, GLib, bind, exec } from "astal";

import Wp from "gi://AstalWp";
import Tray from "gi://AstalTray";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import Network from "gi://AstalNetwork";
import Hyprland from "gi://AstalHyprland";


//------------------------------------------------------------------------------
// Focused Window Widget
//
function Launcher() {
	return <box className="MainBox Launcher">
		<button cursor="pointer" onClicked={() => exec('wofi --show drun -I -W 30% -p ""')}>
			<icon icon="start-here-archlinux-symbolic" />
		</button>
	</box>
}


//------------------------------------------------------------------------------
// Focused Window Widget
//
function FocusedClient() {
	const hypr = Hyprland.get_default();
	const focused = bind(hypr, "focusedClient");

	return <box
		className="MainBox Focused"
		visible={focused.as(Boolean)}>
		{focused.as(client => (
			client && <label label={bind(client, "class").as(String)} />
		))}
	</box>
}


//------------------------------------------------------------------------------
// Time Widget
//
function Time({ format = "%Y-%m-%d - %H:%M" }) {
	const time = Variable<string>("").poll(1000, () =>
		GLib.DateTime.new_now_local().format(format)!);

	return <box className="MainBox Time">
        <button cursor="pointer" onClicked={() => exec("gsimplecal")}>
            <label className="nohigh" onDestroy={() => time.drop()} label={time()} />
        </button>
    </box>
}


//------------------------------------------------------------------------------
// Volume Icon
//
function Volume() {
	const speaker = Wp.get_default()?.audio.defaultSpeaker!;

	return (
		<box className="MainBox Volume">
			<icon
				icon={bind(speaker, "icon").as(iconName =>
					iconName === "audio-headset-bluetooth"
						? "audio-headphones-symbolic"
						: "audio-speakers-bluetooth-symbolic")}
			/>
		</box>
	)
}


//------------------------------------------------------------------------------
// Wifi & Network Widget
//
function Wifi() {
	const { wifi } = Network.get_default();

	return <box className="MainBox Network">
		<icon
			tooltipText={bind(wifi, "ssid").as(String)}
			className="Wifi"
			icon={bind(wifi, "iconName")}
		/>
	</box>
}


//------------------------------------------------------------------------------
// Battery Widget
//
function BatteryLevel() {
	const bat = Battery.get_default();

	return <box className="MainBox Battery" visible={bind(bat, "isPresent")}>
		<icon icon={bind(bat, "batteryIconName")} />

		<label label={bind(bat, "percentage").as(p =>
			`${Math.floor(p * 100)}%`
		)} />
	</box>
}


//------------------------------------------------------------------------------
// SysTray Widget
//
function SysTray() {
	const tray = Tray.get_default();

	return <box className="MainBox SysTray">
		{bind(tray, "items").as(items =>
			items.map(item => {
				if (item.iconThemePath)
					App.add_icons(item.iconThemePath);

				const menu = item.create_menu();

				return <button tooltipMarkup={bind(item, "tooltipMarkup")}
					onDestroy={() => menu?.destroy()} onClickRelease={self => {
						menu?.popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
					}}>
					<icon gIcon={bind(item, "gicon")} />
				</button>
			})
		)}
	</box>
}


//------------------------------------------------------------------------------
// Wifi & Network Widget
//
function CCButton() {
	return <box className="MainBox CCButton">
		<button
			cursor="pointer"
			className="CCButton"
			onClicked={() => toggleWindow("ControlCenter")}>
			<icon icon="control-center2-symbolic" />
		</button>
	</box>
}


//------------------------------------------------------------------------------
// Bar Widget
//
export function Bar(monitor: Gdk.Monitor) {
	const mpris = Mpris.get_default();
	const anchor = Astal.WindowAnchor.TOP
		| Astal.WindowAnchor.LEFT
		| Astal.WindowAnchor.RIGHT;

	// const gtkIconTheme = Gtk.IconTheme.get_default();
	// print(JSON.stringify(gtkIconTheme.list_icons(null)));


	// TODO: Find a way to show only one player at once.
	return (
		<window
			name="Bar"
			className="Bar"
			anchor={anchor}
			gdkmonitor={monitor}
			namespace="iculture-shell"
			exclusivity={Astal.Exclusivity.EXCLUSIVE}>
			<centerbox>
				<box hexpand halign={Gtk.Align.START}>
					<Launcher />
					<WorkSpaces currMon={getMonitorName(monitor)} />
					<FocusedClient />
				</box>

				<box><Time /></box>

				<box hexpand halign={Gtk.Align.END} >
					<button
						cursor="pointer"
						className="CCButton"
						onClicked={() => toggleWindow("ControlCenter")}>
						<box>
							{bind(mpris, "players").as(players =>
								players[0] ? <MediaStatus player={players[0]} /> : ""
							)}

							<Volume />
							<Wifi />
							<BatteryLevel />
						</box>
					</button>
					{/* <CCButton /> */}
				</box>
			</centerbox>
		</window>
	)
}


//------------------------------------------------------------------------------
// Get the Plug Name (e.g. DP-2) for current GDK Monitor.
// Used to evaluate current monitor in bar init.
//
function getMonitorName(gdkMonitor: Gdk.Monitor): string {
	const display = Gdk.Display.get_default();
	if (!display)
		return "";

	const screen = display.get_default_screen();
	for (let i = 0; i < display.get_n_monitors(); ++i)
		if (gdkMonitor === display.get_monitor(i))
			return screen.get_monitor_plug_name(i)!;

	return "";
}
