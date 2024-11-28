import { bind, Binding } from "astal";
import Mpris from "gi://AstalMpris";

// const MAX_TITLE: number = 20;
//

//------------------------------------------------------------------------------
// Media status for bar.
//
export function MediaStatus({ player }: { player: Mpris.Player }) {
	// let artist, title: any = "";
	// const isSpot: Boolean = player.identity === "Spotify";

	// if (isSpot) {
	// 	artist = bind(player, "artist").as(a => a && a + " - " || "");
	// 	title = bind(player, "title").as(t => {
	// 		return t.length < MAX_TITLE
	// 			? t : !t ? "" : t.substring(0, 1) + "...";
	// 	});
	// }

	return <box className="MainBox MediaStatus">
		<button cursor="pointer" onClicked={() => player.play_pause()}>
			{bind(player, "playbackStatus").as(status =>
				status === Mpris.PlaybackStatus.PLAYING
					? <icon icon="media-playback-pause-symbolic" />
					: <icon icon="media-playback-start-symbolic" />)}
		</button>
	</box>
}

// Really don't know if I need this anymore.
// Player are listed in ControlCenter
// Insert before button above
// {isSpot && <box className="info">{artist}{title}</box>}
