import { i_activeWs, i_defaultWs } from "../../../utils/icons";

import { bind } from "astal";
import Hyprland from "gi://AstalHyprland";


//------------------------------------------------------------------------------
// Hyprland Workspaces Widget
//
export const WorkSpaces = ({ currMon }: { currMon: string }) => {
	const hypr = Hyprland.get_default();

	return <box className="MainBox Workspaces">
		{bind(hypr, "workspaces").as(workspaces =>
			workspaces.filter(workspace =>
				workspace.monitor.name == currMon && workspace.id > 0)
 				.sort((a, b) => a.id - b.id)
				.map(workspace => (
					<button cursor="pointer"
						className={bind(hypr, "focusedWorkspace").as(focused =>
							workspace === focused ? "active" : "")}
						onClicked={() => workspace.focus()}>
						<label label={bind(hypr, "focusedWorkspace").as(fw =>
							workspace === fw ? i_activeWs : i_defaultWs).as(String)}
					/>
					</button>
				))
		)}
	</box>
}
