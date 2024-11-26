import { App, Gtk } from "astal/gtk3";


//------------------------------------------------------------------------------
// Toggle a window in astal application.
//
export const toggleWindow = (name: string) => {
	const window: Gtk.Window | null = App.get_window(name)!;
	return window.visible ? window.hide() : window.show()
}
