import { bind, exec, Variable } from "astal";
import { Gtk } from "astal/gtk3";
import Network from "gi://AstalNetwork";


//------------------------------------------------------------------------------
// Wifi & Network Widget
//
export function Networks() {
	const revealed = Variable(false);
	const { wifi } = Network.get_default();
	const vpnName = Variable<string>("").poll(10000, () =>
		exec("wg show interfaces"));

	return <box vertical className="Networks">
		<box className="Buttons">
			<box hexpand cursor="pointer"
				halign={Gtk.Align.START} vertical
				className="InnerBox shadowed Wifi"
			>
				<button hexpand cursor="pointer"
					onClicked={() => revealed.set(!revealed.get())}>

					<box>
						<icon icon={bind(wifi, "iconName")} />
						<label label={bind(wifi, "ssid").as(String)} />
					</box>
				</button>

			</box>

			<box hexpand cursor="pointer"
				halign={Gtk.Align.END}
				className={`InnerBox shadowed Vpn ${vpnName() ? "active" : ""}`}
			>
				<icon
					icon={bind(vpnName).as(name =>
						name ? "network-vpn-symbolic" : "network-vpn-disconnected-symbolic")}
				/>
				{vpnName() ?? "disconnected"}
			</box>
		</box>

		<revealer
			valign={Gtk.Align.END}
			visible={bind(revealed)}
			className="Dropdown"
			revealChild={bind(revealed)}
			transitionType={Gtk.RevealerTransitionType.CROSSFADE}>
			<box vertical className="">
				{bind(wifi, "accessPoints").as(acsps =>
					acsps.sort((a, b) => b.strength - a.strength)
						.filter(p => p.ssid != wifi.ssid && p.ssid)
						.slice(0, 10).map(acsp =>
							<button cursor="pointer">
								{bind(acsp, "ssid").as(String)}
							</button>
						)
				)}
			</box>
		</revealer>
	</box>
}
