package wayland_client

foreign import wl_cursor "system:wayland-cursor"

Cursor_Theme :: struct {}

/** A still image part of a cursor
*
* Use `wl_cursor_image_get_buffer()` to get the corresponding `struct
* wl_buffer` to attach to your `struct wl_surface`. */
Cursor_Image :: struct {
	/** Actual width */
	width: u32,

	/** Actual height */
	height: u32,

	/** Hot spot x (must be inside image) */
	hotspot_x: u32,

	/** Hot spot y (must be inside image) */
	hotspot_y: u32,

	/** Animation delay to next frame (ms) */
	delay: u32,
}

/** A cursor, as returned by `wl_cursor_theme_get_cursor()` */
Cursor :: struct {
	/** How many images there are in this cursor’s animation */
	image_count: u32,

	/** The array of still images composing this animation */
	images: [^]^Cursor_Image,

	/** The name of this cursor */
	name: cstring,
}

@(default_calling_convention="c", link_prefix="wl_")
foreign wl_cursor {
	cursor_theme_load         :: proc(name: cstring, size: i32, shm: ^Shm) -> ^Cursor_Theme ---
	cursor_theme_destroy      :: proc(theme: ^Cursor_Theme) ---
	cursor_theme_get_cursor   :: proc(theme: ^Cursor_Theme, name: cstring) -> ^Cursor ---
	cursor_image_get_buffer   :: proc(image: ^Cursor_Image) -> ^Buffer ---
	cursor_frame              :: proc(cursor: ^Cursor, time: u32) -> i32 ---
	cursor_frame_and_duration :: proc(cursor: ^Cursor, time: u32, duration: ^u32) -> i32 ---
}
