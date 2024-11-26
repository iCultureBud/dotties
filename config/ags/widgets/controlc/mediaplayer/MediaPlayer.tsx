import { Astal, Gtk } from "astal/gtk3";
import { bind } from "astal";
import Mpris from "gi://AstalMpris";


function lengthStr(length: number) {
	const min = Math.floor(length / 60)
	const sec = Math.floor(length % 60)
	const sec0 = sec < 10 ? "0" : ""
	return `${min}:${sec0}${sec}`
}


//------------------------------------------------------------------------------
// Main widget -> macOS like control center
//
export function MediaPlayer({ player }: { player: Mpris.Player }) {
	const { START, END } = Gtk.Align;

	const title = bind(player, "title").as(t =>
		t || "Unknown Track");

	const artist = bind(player, "artist").as(a =>
		a || "Unknown Artist");

	const coverArt = bind(player, "coverArt").as(c =>
		`background-image: url('${c}')`);

	const playerIcon = bind(player, "entry").as(e =>
		Astal.Icon.lookup_icon(String(e))
			? e : "audio-player-symbolic"
	);

	const position = bind(player, "position").as(p => player.length > 0
		? p / player.length : 0);

	const playIcon = bind(player, "playbackStatus").as(s =>
		s === Mpris.PlaybackStatus.PLAYING
			? "media-playback-pause-symbolic"
			: "media-playback-start-symbolic"
	);

	return <overlay className="MediaPlayer">
		<box className="InnerBox shadowed cover-art" css={coverArt}>
			<box className="cover-art-gradient">
			<box vertical className="content">
				<box className="title">
					<label truncate hexpand halign={START} label={title} />
					<icon icon={playerIcon} />
				</box>
				<label halign={START} valign={START} vexpand wrap label={artist} />
				<slider
					cursor="pointer"
					visible={bind(player, "length").as(l => l > 0)}
					onDragged={({ value }) => player.position = value * player.length}
					value={position}
				/>
				<centerbox className="actions">
					<label
						hexpand
						className="position"
						halign={START}
						visible={bind(player, "length").as(l => l > 0)}
						label={bind(player, "position").as(lengthStr)}
					/>

					<box>
						<button
							cursor="pointer"
							onClicked={() => player.previous()}
							visible={bind(player, "canGoPrevious")}>
							<icon icon="media-skip-backward-symbolic" />
						</button>

						<button
							cursor="pointer"
							onClicked={() => player.play_pause()}
							visible={bind(player, "canControl")}>
							<icon icon={playIcon} />
						</button>

						<button
							cursor="pointer"
							onClicked={() => player.next()}
							visible={bind(player, "canGoNext")}>
							<icon icon="media-skip-forward-symbolic" />
						</button>
					</box>

					<label
						className="length"
						hexpand
						halign={END}
						visible={bind(player, "length").as(l => l > 0)}
						label={bind(player, "length").as(l => l > 0 ? lengthStr(l) : "0:00")}
					/>
				</centerbox>
			</box>
			</box>
		</box>
	</overlay>
}


