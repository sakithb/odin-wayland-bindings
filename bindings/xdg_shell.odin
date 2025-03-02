package wayland_client

Xdg_Wm_Base :: struct{}
Xdg_Positioner :: struct{}
Xdg_Surface :: struct{}
Xdg_Toplevel :: struct{}
Xdg_Popup :: struct{}

xdg_wm_base_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "create_positioner", "n", raw_data([]^Interface{ &xdg_positioner_interface, }) },
    { "get_xdg_surface", "no", raw_data([]^Interface{ &xdg_surface_interface, &surface_interface, }) },
    { "pong", "u", raw_data([]^Interface{ nil, }) },
}

xdg_wm_base_events := []Message{
    { "ping", "u", raw_data([]^Interface{ nil, }) },
}

xdg_wm_base_interface := Interface{
    "xdg_wm_base",
    6,
    4,
    raw_data(xdg_wm_base_requests),
    1,
    raw_data(xdg_wm_base_events),
}

xdg_positioner_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "set_size", "ii", raw_data([]^Interface{ nil, nil, }) },
    { "set_anchor_rect", "iiii", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "set_anchor", "u", raw_data([]^Interface{ nil, }) },
    { "set_gravity", "u", raw_data([]^Interface{ nil, }) },
    { "set_constraint_adjustment", "u", raw_data([]^Interface{ nil, }) },
    { "set_offset", "ii", raw_data([]^Interface{ nil, nil, }) },
    { "set_reactive", "", raw_data([]^Interface{ }) },
    { "set_parent_size", "ii", raw_data([]^Interface{ nil, nil, }) },
    { "set_parent_configure", "u", raw_data([]^Interface{ nil, }) },
}

xdg_positioner_events := []Message{
}

xdg_positioner_interface := Interface{
    "xdg_positioner",
    6,
    10,
    raw_data(xdg_positioner_requests),
    0,
    raw_data(xdg_positioner_events),
}

xdg_surface_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "get_toplevel", "n", raw_data([]^Interface{ &xdg_toplevel_interface, }) },
    { "get_popup", "n?oo", raw_data([]^Interface{ &xdg_popup_interface, &xdg_surface_interface, &xdg_positioner_interface, }) },
    { "set_window_geometry", "iiii", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "ack_configure", "u", raw_data([]^Interface{ nil, }) },
}

xdg_surface_events := []Message{
    { "configure", "u", raw_data([]^Interface{ nil, }) },
}

xdg_surface_interface := Interface{
    "xdg_surface",
    6,
    5,
    raw_data(xdg_surface_requests),
    1,
    raw_data(xdg_surface_events),
}

xdg_toplevel_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "set_parent", "?o", raw_data([]^Interface{ &xdg_toplevel_interface, }) },
    { "set_title", "s", raw_data([]^Interface{ nil, }) },
    { "set_app_id", "s", raw_data([]^Interface{ nil, }) },
    { "show_window_menu", "ouii", raw_data([]^Interface{ &seat_interface, nil, nil, nil, }) },
    { "move", "ou", raw_data([]^Interface{ &seat_interface, nil, }) },
    { "resize", "ouu", raw_data([]^Interface{ &seat_interface, nil, nil, }) },
    { "set_max_size", "ii", raw_data([]^Interface{ nil, nil, }) },
    { "set_min_size", "ii", raw_data([]^Interface{ nil, nil, }) },
    { "set_maximized", "", raw_data([]^Interface{ }) },
    { "unset_maximized", "", raw_data([]^Interface{ }) },
    { "set_fullscreen", "?o", raw_data([]^Interface{ &output_interface, }) },
    { "unset_fullscreen", "", raw_data([]^Interface{ }) },
    { "set_minimized", "", raw_data([]^Interface{ }) },
}

xdg_toplevel_events := []Message{
    { "configure", "iia", raw_data([]^Interface{ nil, nil, nil, }) },
    { "close", "", raw_data([]^Interface{ }) },
    { "configure_bounds", "ii", raw_data([]^Interface{ nil, nil, }) },
    { "wm_capabilities", "a", raw_data([]^Interface{ nil, }) },
}

xdg_toplevel_interface := Interface{
    "xdg_toplevel",
    6,
    14,
    raw_data(xdg_toplevel_requests),
    4,
    raw_data(xdg_toplevel_events),
}

xdg_popup_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "grab", "ou", raw_data([]^Interface{ &seat_interface, nil, }) },
    { "reposition", "ou", raw_data([]^Interface{ &xdg_positioner_interface, nil, }) },
}

xdg_popup_events := []Message{
    { "configure", "iiii", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "popup_done", "", raw_data([]^Interface{ }) },
    { "repositioned", "u", raw_data([]^Interface{ nil, }) },
}

xdg_popup_interface := Interface{
    "xdg_popup",
    6,
    3,
    raw_data(xdg_popup_requests),
    3,
    raw_data(xdg_popup_events),
}


Xdg_Wm_Base_Error :: enum {
    Role = 0,
    Defunct_Surfaces = 1,
    Not_The_Topmost_Popup = 2,
    Invalid_Popup_Parent = 3,
    Invalid_Surface_State = 4,
    Invalid_Positioner = 5,
    Unresponsive = 6,
}

Xdg_Wm_Base_Listener :: struct{
    ping: proc(
        data: rawptr,
        xdg_wm_base: ^Xdg_Wm_Base,
        serial: u32,
    ),
}

xdg_wm_base_add_listener :: #force_inline proc(xdg_wm_base: ^Xdg_Wm_Base, listener: ^Xdg_Wm_Base_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)xdg_wm_base,
        rawptr(listener),
        data
    )
}
xdg_wm_base_set_user_data :: #force_inline proc(xdg_wm_base: ^Xdg_Wm_Base, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)xdg_wm_base,
        user_data
    )
}
xdg_wm_base_get_user_data :: #force_inline proc(xdg_wm_base: ^Xdg_Wm_Base) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)xdg_wm_base)
}
xdg_wm_base_get_version :: #force_inline proc(xdg_wm_base: ^Xdg_Wm_Base) -> u32 {
    return proxy_get_version(cast(^Proxy)xdg_wm_base);
}

XDG_WM_BASE_DESTROY :: 0
XDG_WM_BASE_CREATE_POSITIONER :: 1
XDG_WM_BASE_GET_XDG_SURFACE :: 2
XDG_WM_BASE_PONG :: 3

xdg_wm_base_destroy :: #force_inline proc(
    xdg_wm_base: ^Xdg_Wm_Base,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_wm_base,
        XDG_WM_BASE_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

xdg_wm_base_create_positioner :: #force_inline proc(
    xdg_wm_base: ^Xdg_Wm_Base,
) -> ^Xdg_Positioner {
    return cast(^Xdg_Positioner)proxy_marshal_flags(
        cast(^Proxy)xdg_wm_base,
        XDG_WM_BASE_CREATE_POSITIONER,
        &xdg_wm_base_interface,
        proxy_get_version(cast(^Proxy)xdg_wm_base),
        {},
        nil,
    )
}

xdg_wm_base_get_xdg_surface :: #force_inline proc(
    xdg_wm_base: ^Xdg_Wm_Base,
    surface: ^Surface,
) -> ^Xdg_Surface {
    return cast(^Xdg_Surface)proxy_marshal_flags(
        cast(^Proxy)xdg_wm_base,
        XDG_WM_BASE_GET_XDG_SURFACE,
        &xdg_wm_base_interface,
        proxy_get_version(cast(^Proxy)xdg_wm_base),
        {},
        nil,
        surface,
    )
}

xdg_wm_base_pong :: #force_inline proc(
    xdg_wm_base: ^Xdg_Wm_Base,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_wm_base,
        XDG_WM_BASE_PONG,
        nil,
        1, //Unused
        {},
        serial,
    )
}


Xdg_Positioner_Error :: enum {
    Invalid_Input = 0,
}

Xdg_Positioner_Anchor :: enum {
    None = 0,
    Top = 1,
    Bottom = 2,
    Left = 3,
    Right = 4,
    Top_Left = 5,
    Bottom_Left = 6,
    Top_Right = 7,
    Bottom_Right = 8,
}

Xdg_Positioner_Gravity :: enum {
    None = 0,
    Top = 1,
    Bottom = 2,
    Left = 3,
    Right = 4,
    Top_Left = 5,
    Bottom_Left = 6,
    Top_Right = 7,
    Bottom_Right = 8,
}

Xdg_Positioner_Constraint_Adjustment_Flag :: enum {
    None = 0,
    Slide_X = 1,
    Slide_Y = 2,
    Flip_X = 4,
    Flip_Y = 8,
    Resize_X = 16,
    Resize_Y = 32,
}
Xdg_Positioner_Constraint_Adjustment_Flags :: bit_set[Xdg_Positioner_Constraint_Adjustment_Flag]

Xdg_Positioner_Listener :: struct{
}

xdg_positioner_add_listener :: #force_inline proc(xdg_positioner: ^Xdg_Positioner, listener: ^Xdg_Positioner_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)xdg_positioner,
        rawptr(listener),
        data
    )
}
xdg_positioner_set_user_data :: #force_inline proc(xdg_positioner: ^Xdg_Positioner, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)xdg_positioner,
        user_data
    )
}
xdg_positioner_get_user_data :: #force_inline proc(xdg_positioner: ^Xdg_Positioner) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)xdg_positioner)
}
xdg_positioner_get_version :: #force_inline proc(xdg_positioner: ^Xdg_Positioner) -> u32 {
    return proxy_get_version(cast(^Proxy)xdg_positioner);
}

XDG_POSITIONER_DESTROY :: 0
XDG_POSITIONER_SET_SIZE :: 1
XDG_POSITIONER_SET_ANCHOR_RECT :: 2
XDG_POSITIONER_SET_ANCHOR :: 3
XDG_POSITIONER_SET_GRAVITY :: 4
XDG_POSITIONER_SET_CONSTRAINT_ADJUSTMENT :: 5
XDG_POSITIONER_SET_OFFSET :: 6
XDG_POSITIONER_SET_REACTIVE :: 7
XDG_POSITIONER_SET_PARENT_SIZE :: 8
XDG_POSITIONER_SET_PARENT_CONFIGURE :: 9

xdg_positioner_destroy :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

xdg_positioner_set_size :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_SIZE,
        nil,
        1, //Unused
        {},
        width,
        height,
    )
}

xdg_positioner_set_anchor_rect :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_ANCHOR_RECT,
        nil,
        1, //Unused
        {},
        x,
        y,
        width,
        height,
    )
}

xdg_positioner_set_anchor :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
    anchor: Xdg_Positioner_Anchor,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_ANCHOR,
        nil,
        1, //Unused
        {},
        anchor,
    )
}

xdg_positioner_set_gravity :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
    gravity: Xdg_Positioner_Gravity,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_GRAVITY,
        nil,
        1, //Unused
        {},
        gravity,
    )
}

xdg_positioner_set_constraint_adjustment :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
    constraint_adjustment: Xdg_Positioner_Constraint_Adjustment_Flags,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_CONSTRAINT_ADJUSTMENT,
        nil,
        1, //Unused
        {},
        constraint_adjustment,
    )
}

xdg_positioner_set_offset :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
    x: i32,
    y: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_OFFSET,
        nil,
        1, //Unused
        {},
        x,
        y,
    )
}

xdg_positioner_set_reactive :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_REACTIVE,
        nil,
        1, //Unused
        {},
    )
}

xdg_positioner_set_parent_size :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
    parent_width: i32,
    parent_height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_PARENT_SIZE,
        nil,
        1, //Unused
        {},
        parent_width,
        parent_height,
    )
}

xdg_positioner_set_parent_configure :: #force_inline proc(
    xdg_positioner: ^Xdg_Positioner,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_positioner,
        XDG_POSITIONER_SET_PARENT_CONFIGURE,
        nil,
        1, //Unused
        {},
        serial,
    )
}


Xdg_Surface_Error :: enum {
    Not_Constructed = 1,
    Already_Constructed = 2,
    Unconfigured_Buffer = 3,
    Invalid_Serial = 4,
    Invalid_Size = 5,
    Defunct_Role_Object = 6,
}

Xdg_Surface_Listener :: struct{
    configure: proc(
        data: rawptr,
        xdg_surface: ^Xdg_Surface,
        serial: u32,
    ),
}

xdg_surface_add_listener :: #force_inline proc(xdg_surface: ^Xdg_Surface, listener: ^Xdg_Surface_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)xdg_surface,
        rawptr(listener),
        data
    )
}
xdg_surface_set_user_data :: #force_inline proc(xdg_surface: ^Xdg_Surface, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)xdg_surface,
        user_data
    )
}
xdg_surface_get_user_data :: #force_inline proc(xdg_surface: ^Xdg_Surface) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)xdg_surface)
}
xdg_surface_get_version :: #force_inline proc(xdg_surface: ^Xdg_Surface) -> u32 {
    return proxy_get_version(cast(^Proxy)xdg_surface);
}

XDG_SURFACE_DESTROY :: 0
XDG_SURFACE_GET_TOPLEVEL :: 1
XDG_SURFACE_GET_POPUP :: 2
XDG_SURFACE_SET_WINDOW_GEOMETRY :: 3
XDG_SURFACE_ACK_CONFIGURE :: 4

xdg_surface_destroy :: #force_inline proc(
    xdg_surface: ^Xdg_Surface,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_surface,
        XDG_SURFACE_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

xdg_surface_get_toplevel :: #force_inline proc(
    xdg_surface: ^Xdg_Surface,
) -> ^Xdg_Toplevel {
    return cast(^Xdg_Toplevel)proxy_marshal_flags(
        cast(^Proxy)xdg_surface,
        XDG_SURFACE_GET_TOPLEVEL,
        &xdg_surface_interface,
        proxy_get_version(cast(^Proxy)xdg_surface),
        {},
        nil,
    )
}

xdg_surface_get_popup :: #force_inline proc(
    xdg_surface: ^Xdg_Surface,
    parent: ^Xdg_Surface,
    positioner: ^Xdg_Positioner,
) -> ^Xdg_Popup {
    return cast(^Xdg_Popup)proxy_marshal_flags(
        cast(^Proxy)xdg_surface,
        XDG_SURFACE_GET_POPUP,
        &xdg_surface_interface,
        proxy_get_version(cast(^Proxy)xdg_surface),
        {},
        nil,
        parent,
        positioner,
    )
}

xdg_surface_set_window_geometry :: #force_inline proc(
    xdg_surface: ^Xdg_Surface,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_surface,
        XDG_SURFACE_SET_WINDOW_GEOMETRY,
        nil,
        1, //Unused
        {},
        x,
        y,
        width,
        height,
    )
}

xdg_surface_ack_configure :: #force_inline proc(
    xdg_surface: ^Xdg_Surface,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_surface,
        XDG_SURFACE_ACK_CONFIGURE,
        nil,
        1, //Unused
        {},
        serial,
    )
}


Xdg_Toplevel_Error :: enum {
    Invalid_Resize_Edge = 0,
    Invalid_Parent = 1,
    Invalid_Size = 2,
}

Xdg_Toplevel_Resize_Edge :: enum {
    None = 0,
    Top = 1,
    Bottom = 2,
    Left = 4,
    Top_Left = 5,
    Bottom_Left = 6,
    Right = 8,
    Top_Right = 9,
    Bottom_Right = 10,
}

Xdg_Toplevel_State :: enum {
    Maximized = 1,
    Fullscreen = 2,
    Resizing = 3,
    Activated = 4,
    Tiled_Left = 5,
    Tiled_Right = 6,
    Tiled_Top = 7,
    Tiled_Bottom = 8,
    Suspended = 9,
}

Xdg_Toplevel_Wm_Capabilities :: enum {
    Window_Menu = 1,
    Maximize = 2,
    Fullscreen = 3,
    Minimize = 4,
}

Xdg_Toplevel_Listener :: struct{
    configure: proc(
        data: rawptr,
        xdg_toplevel: ^Xdg_Toplevel,
        width: i32,
        height: i32,
        states: ^Array,
    ),
    close: proc(
        data: rawptr,
        xdg_toplevel: ^Xdg_Toplevel,
    ),
    configure_bounds: proc(
        data: rawptr,
        xdg_toplevel: ^Xdg_Toplevel,
        width: i32,
        height: i32,
    ),
    wm_capabilities: proc(
        data: rawptr,
        xdg_toplevel: ^Xdg_Toplevel,
        capabilities: ^Array,
    ),
}

xdg_toplevel_add_listener :: #force_inline proc(xdg_toplevel: ^Xdg_Toplevel, listener: ^Xdg_Toplevel_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)xdg_toplevel,
        rawptr(listener),
        data
    )
}
xdg_toplevel_set_user_data :: #force_inline proc(xdg_toplevel: ^Xdg_Toplevel, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)xdg_toplevel,
        user_data
    )
}
xdg_toplevel_get_user_data :: #force_inline proc(xdg_toplevel: ^Xdg_Toplevel) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)xdg_toplevel)
}
xdg_toplevel_get_version :: #force_inline proc(xdg_toplevel: ^Xdg_Toplevel) -> u32 {
    return proxy_get_version(cast(^Proxy)xdg_toplevel);
}

XDG_TOPLEVEL_DESTROY :: 0
XDG_TOPLEVEL_SET_PARENT :: 1
XDG_TOPLEVEL_SET_TITLE :: 2
XDG_TOPLEVEL_SET_APP_ID :: 3
XDG_TOPLEVEL_SHOW_WINDOW_MENU :: 4
XDG_TOPLEVEL_MOVE :: 5
XDG_TOPLEVEL_RESIZE :: 6
XDG_TOPLEVEL_SET_MAX_SIZE :: 7
XDG_TOPLEVEL_SET_MIN_SIZE :: 8
XDG_TOPLEVEL_SET_MAXIMIZED :: 9
XDG_TOPLEVEL_UNSET_MAXIMIZED :: 10
XDG_TOPLEVEL_SET_FULLSCREEN :: 11
XDG_TOPLEVEL_UNSET_FULLSCREEN :: 12
XDG_TOPLEVEL_SET_MINIMIZED :: 13

xdg_toplevel_destroy :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

xdg_toplevel_set_parent :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    parent: ^Xdg_Toplevel,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SET_PARENT,
        nil,
        1, //Unused
        {},
        parent,
    )
}

xdg_toplevel_set_title :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    title: cstring,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SET_TITLE,
        nil,
        1, //Unused
        {},
        title,
    )
}

xdg_toplevel_set_app_id :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    app_id: cstring,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SET_APP_ID,
        nil,
        1, //Unused
        {},
        app_id,
    )
}

xdg_toplevel_show_window_menu :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    seat: ^Seat,
    serial: u32,
    x: i32,
    y: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SHOW_WINDOW_MENU,
        nil,
        1, //Unused
        {},
        seat,
        serial,
        x,
        y,
    )
}

xdg_toplevel_move :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    seat: ^Seat,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_MOVE,
        nil,
        1, //Unused
        {},
        seat,
        serial,
    )
}

xdg_toplevel_resize :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    seat: ^Seat,
    serial: u32,
    edges: Xdg_Toplevel_Resize_Edge,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_RESIZE,
        nil,
        1, //Unused
        {},
        seat,
        serial,
        edges,
    )
}

xdg_toplevel_set_max_size :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SET_MAX_SIZE,
        nil,
        1, //Unused
        {},
        width,
        height,
    )
}

xdg_toplevel_set_min_size :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SET_MIN_SIZE,
        nil,
        1, //Unused
        {},
        width,
        height,
    )
}

xdg_toplevel_set_maximized :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SET_MAXIMIZED,
        nil,
        1, //Unused
        {},
    )
}

xdg_toplevel_unset_maximized :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_UNSET_MAXIMIZED,
        nil,
        1, //Unused
        {},
    )
}

xdg_toplevel_set_fullscreen :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
    output: ^Output,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SET_FULLSCREEN,
        nil,
        1, //Unused
        {},
        output,
    )
}

xdg_toplevel_unset_fullscreen :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_UNSET_FULLSCREEN,
        nil,
        1, //Unused
        {},
    )
}

xdg_toplevel_set_minimized :: #force_inline proc(
    xdg_toplevel: ^Xdg_Toplevel,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_toplevel,
        XDG_TOPLEVEL_SET_MINIMIZED,
        nil,
        1, //Unused
        {},
    )
}


Xdg_Popup_Error :: enum {
    Invalid_Grab = 0,
}

Xdg_Popup_Listener :: struct{
    configure: proc(
        data: rawptr,
        xdg_popup: ^Xdg_Popup,
        x: i32,
        y: i32,
        width: i32,
        height: i32,
    ),
    popup_done: proc(
        data: rawptr,
        xdg_popup: ^Xdg_Popup,
    ),
    repositioned: proc(
        data: rawptr,
        xdg_popup: ^Xdg_Popup,
        token: u32,
    ),
}

xdg_popup_add_listener :: #force_inline proc(xdg_popup: ^Xdg_Popup, listener: ^Xdg_Popup_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)xdg_popup,
        rawptr(listener),
        data
    )
}
xdg_popup_set_user_data :: #force_inline proc(xdg_popup: ^Xdg_Popup, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)xdg_popup,
        user_data
    )
}
xdg_popup_get_user_data :: #force_inline proc(xdg_popup: ^Xdg_Popup) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)xdg_popup)
}
xdg_popup_get_version :: #force_inline proc(xdg_popup: ^Xdg_Popup) -> u32 {
    return proxy_get_version(cast(^Proxy)xdg_popup);
}

XDG_POPUP_DESTROY :: 0
XDG_POPUP_GRAB :: 1
XDG_POPUP_REPOSITION :: 2

xdg_popup_destroy :: #force_inline proc(
    xdg_popup: ^Xdg_Popup,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_popup,
        XDG_POPUP_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

xdg_popup_grab :: #force_inline proc(
    xdg_popup: ^Xdg_Popup,
    seat: ^Seat,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_popup,
        XDG_POPUP_GRAB,
        nil,
        1, //Unused
        {},
        seat,
        serial,
    )
}

xdg_popup_reposition :: #force_inline proc(
    xdg_popup: ^Xdg_Popup,
    positioner: ^Xdg_Positioner,
    token: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)xdg_popup,
        XDG_POPUP_REPOSITION,
        nil,
        1, //Unused
        {},
        positioner,
        token,
    )
}


