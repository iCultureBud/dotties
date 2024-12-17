import { i_Lock, i_Logout, i_Reboot, i_Power } from "../../utils/icons";
import { AudioControls } from "./audiocontrols/AudioControls";
import { BluetoothC } from "./bluetooth/Bluetooth";
import { Networks } from "./networks/Networks";
import { MediaPlayer } from "./mediaplayer/MediaPlayer";

import { bind, exec, Variable } from "astal";
import { Astal, Gdk, App } from "astal/gtk3";

import Wp from "gi://AstalWp";
import Mpris from "gi://AstalMpris";


//------------------------------------------------------------------------------
// Simple powermenu for controlcenter.
//
function PowerMenu() {
	return <box className="InnerBox PowerMenu" hexpand>
		<button hexpand label={i_Lock} cursor="pointer"
			className="lock" onClicked={() => exec("hyprlock")} />

		<button hexpand label={i_Logout} cursor="pointer"
			className="logout" onClicked={() => exec("hyprctl dispatch exit")} />

		<button hexpand label={i_Reboot} cursor="pointer"
			className="reboot" onClicked={() => exec("systemctl reboot")} />

		<button hexpand label={i_Power} cursor="pointer"
			className="power" onClicked={() => exec("systemctl poweroff")} />
	</box>
}


//------------------------------------------------------------------------------
// Slider for display brightness.
//
function BrightnessSlider() {
	const brightness = Variable<number>(0).poll(900000, () =>
		Number(exec("brightnessctl get")));

	return <box className="InnerBox shadowed BrightnessSlider">
		<icon icon="brightnesssettings-symbolic" />

		<slider hexpand min={0} max={255} cursor="pointer"
			onDragged={({ value }) => exec(`brightnessctl set ${value}`)} value={brightness()} />
	</box>
}


//------------------------------------------------------------------------------
// Slider for current default speaker.
//
function VolumeSlider() {
	const speaker = Wp.get_default()?.audio.defaultSpeaker!

	return <box className="InnerBox shadowed VolumeSlider">
		<icon icon={bind(speaker, "icon").as(iconName =>
			iconName === "audio-headset-bluetooth"
				? "audio-headphones-symbolic"
				: "audio-speakers-bluetooth-symbolic")} />

		<slider hexpand cursor="pointer"
			onDragged={({ value }) => speaker.volume = value} value={bind(speaker, "volume")} />
	</box>
}


//------------------------------------------------------------------------------
// Main widget -> macOS like control center
//
export function ControlCenter() {
	const mpris = Mpris.get_default()
	const anchor = Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT;

	return (
		<window
			name="ControlCenter"
			className="ControlCenter"
			namespace="iculture-shell"
			marginTop={4}
			marginRight={4}
			application={App}
			visible={false}
			anchor={anchor}
			exclusivity={Astal.Exclusivity.NORMAL}
			keymode={Astal.Keymode.ON_DEMAND}
			onKeyPressEvent={function(self, event: Gdk.Event) {
				if (event.get_keyval()[1] === Gdk.KEY_Escape)
					self.hide()
			}}
		>
			<box vertical className="MainBox">
				<PowerMenu />
				<Networks />
				<AudioControls />
				{/* <BluetoothC /> */}
				<BrightnessSlider />
				<VolumeSlider />

				{bind(mpris, "players").as(players =>
					players.map(player => <MediaPlayer player={player} />))}
			</box>
		</window>
	)
}
