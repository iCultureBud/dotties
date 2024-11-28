import { bind, exec, Variable } from "astal";
import { Gtk } from "astal/gtk3";
import Wp from "gi://AstalWp";

const MAX_LENGTH: number = 25;

//------------------------------------------------------------------------------
// Wifi & Network Widget
//
export function AudioControls() {
	const spRevealed = Variable(false);
	const mcRevealed = Variable(false);
	const wp = Wp.get_default()!.audio;
	const defSpeaker = wp.defaultSpeaker!;
	const defMic = wp.defaultMicrophone!;

	return <box vertical className="AudioControls">
		<box vertical hexpand className="Speakers">
			<button cursor="pointer" className="InnerBox shadowed"
				onClicked={() => spRevealed.set(!spRevealed.get())}>

				<box>
					<icon icon={bind(defSpeaker, "icon").as(iconName =>
						iconName === "audio-headset-bluetooth"
							? "audio-headphones-symbolic"
							: "audio-speakers-bluetooth-symbolic")} />

					<label label={bind(defSpeaker, "description").as(desc => trim(desc))} />
				</box>
			</button>

			<revealer
				valign={Gtk.Align.END}
				visible={bind(spRevealed)}
				className="Dropdown"
				revealChild={bind(spRevealed)}
				transitionType={Gtk.RevealerTransitionType.CROSSFADE}>
				<box vertical className="">
					{bind(wp, "speakers").as(speakers =>
						speakers.map(speaker =>
							<button cursor="pointer" tooltipText={bind(speaker, "description")}
								onClicked={() => setDefault(speaker.id)}>
								<box>
									<icon icon={bind(speaker, "icon").as(iconName =>
										iconName === "audio-headset-bluetooth"
											? "audio-headphones-symbolic"
											: "audio-speakers-bluetooth-symbolic")} />
									<label label={bind(speaker, "description").as(desc => trim(desc))} />
								</box>
							</button>
						)
					)}
				</box>
			</revealer>
		</box>

		<box vertical hexpand className="Mics">
			<button cursor="pointer" className="InnerBox shadowed"
				onClicked={() => mcRevealed.set(!mcRevealed.get())}>
				<box>
					<icon icon={bind(defMic, "volumeIcon")} />

					<label label={bind(defMic, "description").as(desc => trim(desc))} />
				</box>
			</button>

			<revealer
				valign={Gtk.Align.END}
				visible={bind(mcRevealed)}
				className="Dropdown"
				revealChild={bind(mcRevealed)}
				transitionType={Gtk.RevealerTransitionType.CROSSFADE}>
				<box vertical className="">
					{bind(wp, "microphones").as(mics =>
						mics.map(mic =>
							<button cursor="pointer" tooltipText={bind(mic, "description")}
								onClicked={() => setDefault(mic.id)}>
								<box>
									<icon icon={bind(mic, "volumeIcon")} />
									<label label={bind(mic, "description").as(desc => trim(desc))} />
								</box>
							</button>
						)
					)}
				</box>
			</revealer>
		</box>

	</box>
}


function trim(target: string): string {
	if (!target) return "";
	if (target.length < MAX_LENGTH) return target;

	return target.substring(0, MAX_LENGTH);
}

function setDefault(target: number): void {
	exec(`wpctl set-default ${target}`)
}
