package main

import "core:fmt"
import "core:os"
import wl "bindings"

display: ^wl.Display = nil
compositor: ^wl.Compositor = nil
surface: ^wl.Surface
shell: ^wl.Shell = nil
shell_surface: ^wl.Shell_Surface

global_registry_handler :: proc(
	data: rawptr,
	registry: ^wl.Registry,
	id: uint,
	interface: cstring,
	version: uint,
) {
	fmt.printf("Got a registry event for  %s with id %d \r\n", interface, id)
	if (interface == "wl_compositor") {
		compositor =
		cast(^wl.Compositor)wl.registry_bind(
			registry,
			id,
			&wl.compositor_interface,
			1,
		)
	}
}

global_registry_remover :: proc(data: rawptr, registry: ^wl.Registry, id: uint) {
	fmt.printf("Got a registry losing event for %d", id)
}

registry_listener := wl.Registry_Listener {
	global_registry_handler,
	global_registry_remover,
}

main :: proc() {
	display := wl.display_connect(nil)
	if display == nil {
		fmt.println("Could not connect to display")
		return
	}

	fmt.println("Connected to Wayland display!")
	registry := wl.display_get_registry(display)
	wl.registry_add_listener(registry, &registry_listener, nil)

	fmt.println("Dispath")
	wl.display_dispatch(display)
	wl.display_roundtrip(display)

	if compositor == nil {
		fmt.println("Cannot find compositor")
		os.exit(1)
	} else {
		fmt.println("Found Compositor")
	}

	surface = wl.compositor_create_surface(compositor)
	if surface == nil {
		fmt.println("Cannot create surface")
		os.exit(1)
	}
	fmt.println("Surface created")

	if shell == nil {
		fmt.println("havent got a wayland shell")
		os.exit(1)
	}
	shell_surface = wl.shell_get_shell_surface(shell, surface)
	if shell_surface == nil {
		fmt.println("cannot create shell surface")
	}
	fmt.println("Created shell surface")

	wl.shell_surface_set_toplevel(shell_surface)
	//disconnect from display
	wl.display_disconnect(display)
	fmt.println("Disconnected from wayland display")
}
