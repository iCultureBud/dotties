import { GLib } from "astal"
import { Gtk, Astal } from "astal/gtk3"
import { type EventBox } from "astal/gtk3/widget"

import Notifd from "gi://AstalNotifd"

const MAX_TITLE: number = 40;

const isIcon = (icon: string) =>
	!!Astal.Icon.lookup_icon(icon);

const fileExists = (path: string) =>
	GLib.file_test(path, GLib.FileTest.EXISTS);

const time = (time: number, format = "%H:%M") => GLib.DateTime
	.new_from_unix_local(time)
	.format(format)!;

const urgency = (notif: Notifd.Notification) => {
	const { LOW, NORMAL, CRITICAL } = Notifd.Urgency;
	switch (notif.urgency) {
		case LOW: return "low"
		case CRITICAL: return "critical"
		case NORMAL:
		default: return "normal"
	}
}

type Props = {
	setup(self: EventBox): void
	onHoverLost(self: EventBox): void
	notification: Notifd.Notification
}

export function Notification(props: Props) {
	const { notification: notif, onHoverLost, setup } = props;
	const { START, CENTER, END } = Gtk.Align;
	let notifBody: string = notif.body;
	if (notifBody && notifBody.length > MAX_TITLE)
		notifBody = notifBody.substring(0, MAX_TITLE) + "...";

	// NOTE: Urgency is always `low`
	// Fixed in source, but AUR package not updated
	return <eventbox
		className="Notification normal"
		setup={setup}
		onHoverLost={onHoverLost}>
		<box vertical className="MainBox">
			<box className="Header">
				{(notif.appIcon || notif.desktopEntry) && <icon
					className="app-icon"
					visible={Boolean(notif.appIcon || notif.desktopEntry)}
					icon={notif.appIcon || notif.desktopEntry}
				/>}
				<label
					className="app-name"
					halign={START}
					truncate
					label={notif.appName || "Unknown"}
				/>
				<label
					className="time"
					hexpand
					halign={END}
					label={time(notif.time)}
				/>
				<button onClicked={() => notif.dismiss()}>
					<icon icon="window-close-symbolic" />
				</button>
			</box>
			<Gtk.Separator visible />
			<box className="Content">
				{notif.image && fileExists(notif.image) && <box
					valign={START}
					className="image"
					css={`background-image: url('${notif.image}')`}
				/>}
				{notif.image && isIcon(notif.image) && <box
					expand={false}
					valign={START}
					className="icon-image">
					<icon icon={notif.image} expand halign={CENTER} valign={CENTER} />
				</box>}
				<box vertical>
					<label
						className="summary"
						halign={START}
						xalign={0}
						label={notif.summary}
						truncate
					/>
					{notifBody && <label
						className="body"
						wrap
						useMarkup
						halign={START}
						xalign={0}
						justifyFill
						label={notifBody}
					/>}
				</box>
			</box>
			{notif.get_actions().length > 0 && <box className="Actions">
				{notif.get_actions().map(({ label, id }) => (
					<button
						hexpand
						onClicked={() => notif.invoke(id)}>
						<label label={label} halign={CENTER} hexpand />
					</button>
				))}
			</box>}
		</box>
	</eventbox>;
}
