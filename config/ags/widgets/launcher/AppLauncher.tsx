import { toggleWindow } from "../../utils/utils";

import { Astal, Gtk, Gdk, App } from "astal/gtk3";
import { Variable } from "astal";

import Apps from "gi://AstalApps"


const MAX_ITEMS = 8;

function AppButton({ app }: { app: Apps.Application }) {
	return <button
		className="AppButton"
		onClicked={() => { toggleWindow("AppLauncher"); app.launch(); }}>
		<box>
			{Astal.Icon.lookup_icon(app.iconName) &&
				<icon icon={app.iconName} />}
		
			<box valign={Gtk.Align.CENTER} vertical>
				<label
					className="name"
					truncate
					xalign={0}
					label={app.name}
				/>
				{app.description && <label
					className="description"
					wrap
					xalign={0}
					label={app.description}
				/>}
			</box>
		</box>
	</button>
}


//------------------------------------------------------------------------------
// Export point -> Bar Widget
//
export default function AppLauncher() {
	const { CENTER } = Gtk.Align
	const apps = new Apps.Apps()

	const text = Variable("")
	const list = text(text =>
		apps.fuzzy_query(text).slice(0, MAX_ITEMS))
	const onEnter = () => {
		apps.fuzzy_query(text.get())?.[0].launch();
		toggleWindow("AppLauncher");
	}

	return (
		<window
			name="AppLauncher"
			className="AppLauncher"
			visible={true}
			application={App}
			namespace="iculture-shell"
			keymode={Astal.Keymode.ON_DEMAND}
			exclusivity={Astal.Exclusivity.EXCLUSIVE}
			onShow={() => text.set("")}
			onKeyPressEvent={function(self, event: Gdk.Event) {
				if (event.get_keyval()[1] === Gdk.KEY_Escape)
					self.hide()
			}}>
			<box>
				<eventbox widthRequest={200} expand onClick={() => toggleWindow("AppLauncher")} />
				<box hexpand={false} vertical>
					<eventbox heightRequest={1000} onClick={() => toggleWindow("AppLauncher")} />
					<box widthRequest={400} className="Applauncher" vertical>
						<entry
							placeholderText="Search"
							text={text()}
							onChanged={self => text.set(self.text)}
							onActivate={onEnter}
						/>
						<box spacing={6} vertical>
							{list.as(list => list.map(app => (
								<AppButton app={app} />
							)))}
						</box>
						<box
							halign={CENTER}
							className="not-found"
							vertical
							visible={list.as(l => l.length === 0)}>
							<icon icon="system-search-symbolic" />
							<label label="No match found" />
						</box>
					</box>
					<eventbox expand onClick={() => toggleWindow("AppLauncher")} />
				</box>
				<eventbox widthRequest={400} expand onClick={() => toggleWindow("AppLauncher")} />
			</box>
		</window>
	)
}
