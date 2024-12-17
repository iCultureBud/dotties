import { bind, exec, Variable } from "astal";
import { Gtk } from "astal/gtk3";

import Bluetooth from "gi://AstalBluetooth";


//------------------------------------------------------------------------------
// Wifi & Network Widget
//
export function BluetoothC() {
	const revealed = Variable(false);
	const bluez = Bluetooth.get_default();

	return <box vertical className="Bluetooth">
		<box hexpand cursor="pointer"
			halign={Gtk.Align.START} vertical
			className="InnerBox shadowed Wifi"
		>
			<button hexpand cursor="pointer"
				onClicked={() => revealed.set(!revealed.get())}>

				<box>
					<icon icon="bluetooth-symbolic" />
					<label label={bind(bluez, "isConnected").as(con => con ? "connected" : "not connected")} />
				</box>
			</button>
		</box>

		<revealer
			valign={Gtk.Align.END}
			visible={bind(revealed)}
			className="Dropdown"
			revealChild={bind(revealed)}
			transitionType={Gtk.RevealerTransitionType.CROSSFADE}>
			<box vertical className="">
				{bind(bluez, "devices").as(devices =>
					devices.map(device =>
						<button cursor="pointer">
							{bind(device, "name").as(String)}
						</button>
					)
				)}
			</box>
		</revealer>
	</box>
}
