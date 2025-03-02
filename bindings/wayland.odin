package wayland_client

Display :: struct{}
Registry :: struct{}
Callback :: struct{}
Compositor :: struct{}
Shm_Pool :: struct{}
Shm :: struct{}
Buffer :: struct{}
Data_Offer :: struct{}
Data_Source :: struct{}
Data_Device :: struct{}
Data_Device_Manager :: struct{}
Shell :: struct{}
Shell_Surface :: struct{}
Surface :: struct{}
Seat :: struct{}
Pointer :: struct{}
Keyboard :: struct{}
Touch :: struct{}
Output :: struct{}
Region :: struct{}
Subcompositor :: struct{}
Subsurface :: struct{}
Fixes :: struct{}

display_requests := []Message{
    { "sync", "n", raw_data([]^Interface{ &callback_interface, }) },
    { "get_registry", "n", raw_data([]^Interface{ &registry_interface, }) },
}

display_events := []Message{
    { "error", "ous", raw_data([]^Interface{ nil, nil, nil, }) },
    { "delete_id", "u", raw_data([]^Interface{ nil, }) },
}

display_interface := Interface{
    "wl_display",
    1,
    2,
    raw_data(display_requests),
    2,
    raw_data(display_events),
}

registry_requests := []Message{
    { "bind", "un", raw_data([]^Interface{ nil, nil, }) },
}

registry_events := []Message{
    { "global", "usu", raw_data([]^Interface{ nil, nil, nil, }) },
    { "global_remove", "u", raw_data([]^Interface{ nil, }) },
}

registry_interface := Interface{
    "wl_registry",
    1,
    1,
    raw_data(registry_requests),
    2,
    raw_data(registry_events),
}

callback_requests := []Message{
}

callback_events := []Message{
    { "done", "u", raw_data([]^Interface{ nil, }) },
}

callback_interface := Interface{
    "wl_callback",
    1,
    0,
    raw_data(callback_requests),
    1,
    raw_data(callback_events),
}

compositor_requests := []Message{
    { "create_surface", "n", raw_data([]^Interface{ &surface_interface, }) },
    { "create_region", "n", raw_data([]^Interface{ &region_interface, }) },
}

compositor_events := []Message{
}

compositor_interface := Interface{
    "wl_compositor",
    6,
    2,
    raw_data(compositor_requests),
    0,
    raw_data(compositor_events),
}

shm_pool_requests := []Message{
    { "create_buffer", "niiiiu", raw_data([]^Interface{ &buffer_interface, nil, nil, nil, nil, nil, }) },
    { "destroy", "", raw_data([]^Interface{ }) },
    { "resize", "i", raw_data([]^Interface{ nil, }) },
}

shm_pool_events := []Message{
}

shm_pool_interface := Interface{
    "wl_shm_pool",
    2,
    3,
    raw_data(shm_pool_requests),
    0,
    raw_data(shm_pool_events),
}

shm_requests := []Message{
    { "create_pool", "nhi", raw_data([]^Interface{ &shm_pool_interface, nil, nil, }) },
    { "release", "", raw_data([]^Interface{ }) },
}

shm_events := []Message{
    { "format", "u", raw_data([]^Interface{ nil, }) },
}

shm_interface := Interface{
    "wl_shm",
    2,
    2,
    raw_data(shm_requests),
    1,
    raw_data(shm_events),
}

buffer_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
}

buffer_events := []Message{
    { "release", "", raw_data([]^Interface{ }) },
}

buffer_interface := Interface{
    "wl_buffer",
    1,
    1,
    raw_data(buffer_requests),
    1,
    raw_data(buffer_events),
}

data_offer_requests := []Message{
    { "accept", "u?s", raw_data([]^Interface{ nil, nil, }) },
    { "receive", "sh", raw_data([]^Interface{ nil, nil, }) },
    { "destroy", "", raw_data([]^Interface{ }) },
    { "finish", "", raw_data([]^Interface{ }) },
    { "set_actions", "uu", raw_data([]^Interface{ nil, nil, }) },
}

data_offer_events := []Message{
    { "offer", "s", raw_data([]^Interface{ nil, }) },
    { "source_actions", "u", raw_data([]^Interface{ nil, }) },
    { "action", "u", raw_data([]^Interface{ nil, }) },
}

data_offer_interface := Interface{
    "wl_data_offer",
    3,
    5,
    raw_data(data_offer_requests),
    3,
    raw_data(data_offer_events),
}

data_source_requests := []Message{
    { "offer", "s", raw_data([]^Interface{ nil, }) },
    { "destroy", "", raw_data([]^Interface{ }) },
    { "set_actions", "u", raw_data([]^Interface{ nil, }) },
}

data_source_events := []Message{
    { "target", "?s", raw_data([]^Interface{ nil, }) },
    { "send", "sh", raw_data([]^Interface{ nil, nil, }) },
    { "cancelled", "", raw_data([]^Interface{ }) },
    { "dnd_drop_performed", "", raw_data([]^Interface{ }) },
    { "dnd_finished", "", raw_data([]^Interface{ }) },
    { "action", "u", raw_data([]^Interface{ nil, }) },
}

data_source_interface := Interface{
    "wl_data_source",
    3,
    3,
    raw_data(data_source_requests),
    6,
    raw_data(data_source_events),
}

data_device_requests := []Message{
    { "start_drag", "?oo?ou", raw_data([]^Interface{ &data_source_interface, &surface_interface, &surface_interface, nil, }) },
    { "set_selection", "?ou", raw_data([]^Interface{ &data_source_interface, nil, }) },
    { "release", "", raw_data([]^Interface{ }) },
}

data_device_events := []Message{
    { "data_offer", "n", raw_data([]^Interface{ &data_offer_interface, }) },
    { "enter", "uoff?o", raw_data([]^Interface{ nil, &surface_interface, nil, nil, &data_offer_interface, }) },
    { "leave", "", raw_data([]^Interface{ }) },
    { "motion", "uff", raw_data([]^Interface{ nil, nil, nil, }) },
    { "drop", "", raw_data([]^Interface{ }) },
    { "selection", "?o", raw_data([]^Interface{ &data_offer_interface, }) },
}

data_device_interface := Interface{
    "wl_data_device",
    3,
    3,
    raw_data(data_device_requests),
    6,
    raw_data(data_device_events),
}

data_device_manager_requests := []Message{
    { "create_data_source", "n", raw_data([]^Interface{ &data_source_interface, }) },
    { "get_data_device", "no", raw_data([]^Interface{ &data_device_interface, &seat_interface, }) },
}

data_device_manager_events := []Message{
}

data_device_manager_interface := Interface{
    "wl_data_device_manager",
    3,
    2,
    raw_data(data_device_manager_requests),
    0,
    raw_data(data_device_manager_events),
}

shell_requests := []Message{
    { "get_shell_surface", "no", raw_data([]^Interface{ &shell_surface_interface, &surface_interface, }) },
}

shell_events := []Message{
}

shell_interface := Interface{
    "wl_shell",
    1,
    1,
    raw_data(shell_requests),
    0,
    raw_data(shell_events),
}

shell_surface_requests := []Message{
    { "pong", "u", raw_data([]^Interface{ nil, }) },
    { "move", "ou", raw_data([]^Interface{ &seat_interface, nil, }) },
    { "resize", "ouu", raw_data([]^Interface{ &seat_interface, nil, nil, }) },
    { "set_toplevel", "", raw_data([]^Interface{ }) },
    { "set_transient", "oiiu", raw_data([]^Interface{ &surface_interface, nil, nil, nil, }) },
    { "set_fullscreen", "uu?o", raw_data([]^Interface{ nil, nil, &output_interface, }) },
    { "set_popup", "ouoiiu", raw_data([]^Interface{ &seat_interface, nil, &surface_interface, nil, nil, nil, }) },
    { "set_maximized", "?o", raw_data([]^Interface{ &output_interface, }) },
    { "set_title", "s", raw_data([]^Interface{ nil, }) },
    { "set_class", "s", raw_data([]^Interface{ nil, }) },
}

shell_surface_events := []Message{
    { "ping", "u", raw_data([]^Interface{ nil, }) },
    { "configure", "uii", raw_data([]^Interface{ nil, nil, nil, }) },
    { "popup_done", "", raw_data([]^Interface{ }) },
}

shell_surface_interface := Interface{
    "wl_shell_surface",
    1,
    10,
    raw_data(shell_surface_requests),
    3,
    raw_data(shell_surface_events),
}

surface_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "attach", "?oii", raw_data([]^Interface{ &buffer_interface, nil, nil, }) },
    { "damage", "iiii", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "frame", "n", raw_data([]^Interface{ &callback_interface, }) },
    { "set_opaque_region", "?o", raw_data([]^Interface{ &region_interface, }) },
    { "set_input_region", "?o", raw_data([]^Interface{ &region_interface, }) },
    { "commit", "", raw_data([]^Interface{ }) },
    { "set_buffer_transform", "i", raw_data([]^Interface{ nil, }) },
    { "set_buffer_scale", "i", raw_data([]^Interface{ nil, }) },
    { "damage_buffer", "iiii", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "offset", "ii", raw_data([]^Interface{ nil, nil, }) },
}

surface_events := []Message{
    { "enter", "o", raw_data([]^Interface{ &output_interface, }) },
    { "leave", "o", raw_data([]^Interface{ &output_interface, }) },
    { "preferred_buffer_scale", "i", raw_data([]^Interface{ nil, }) },
    { "preferred_buffer_transform", "u", raw_data([]^Interface{ nil, }) },
}

surface_interface := Interface{
    "wl_surface",
    6,
    11,
    raw_data(surface_requests),
    4,
    raw_data(surface_events),
}

seat_requests := []Message{
    { "get_pointer", "n", raw_data([]^Interface{ &pointer_interface, }) },
    { "get_keyboard", "n", raw_data([]^Interface{ &keyboard_interface, }) },
    { "get_touch", "n", raw_data([]^Interface{ &touch_interface, }) },
    { "release", "", raw_data([]^Interface{ }) },
}

seat_events := []Message{
    { "capabilities", "u", raw_data([]^Interface{ nil, }) },
    { "name", "s", raw_data([]^Interface{ nil, }) },
}

seat_interface := Interface{
    "wl_seat",
    10,
    4,
    raw_data(seat_requests),
    2,
    raw_data(seat_events),
}

pointer_requests := []Message{
    { "set_cursor", "u?oii", raw_data([]^Interface{ nil, &surface_interface, nil, nil, }) },
    { "release", "", raw_data([]^Interface{ }) },
}

pointer_events := []Message{
    { "enter", "uoff", raw_data([]^Interface{ nil, &surface_interface, nil, nil, }) },
    { "leave", "uo", raw_data([]^Interface{ nil, &surface_interface, }) },
    { "motion", "uff", raw_data([]^Interface{ nil, nil, nil, }) },
    { "button", "uuuu", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "axis", "uuf", raw_data([]^Interface{ nil, nil, nil, }) },
    { "frame", "", raw_data([]^Interface{ }) },
    { "axis_source", "u", raw_data([]^Interface{ nil, }) },
    { "axis_stop", "uu", raw_data([]^Interface{ nil, nil, }) },
    { "axis_discrete", "ui", raw_data([]^Interface{ nil, nil, }) },
    { "axis_value120", "ui", raw_data([]^Interface{ nil, nil, }) },
    { "axis_relative_direction", "uu", raw_data([]^Interface{ nil, nil, }) },
}

pointer_interface := Interface{
    "wl_pointer",
    10,
    2,
    raw_data(pointer_requests),
    11,
    raw_data(pointer_events),
}

keyboard_requests := []Message{
    { "release", "", raw_data([]^Interface{ }) },
}

keyboard_events := []Message{
    { "keymap", "uhu", raw_data([]^Interface{ nil, nil, nil, }) },
    { "enter", "uoa", raw_data([]^Interface{ nil, &surface_interface, nil, }) },
    { "leave", "uo", raw_data([]^Interface{ nil, &surface_interface, }) },
    { "key", "uuuu", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "modifiers", "uuuuu", raw_data([]^Interface{ nil, nil, nil, nil, nil, }) },
    { "repeat_info", "ii", raw_data([]^Interface{ nil, nil, }) },
}

keyboard_interface := Interface{
    "wl_keyboard",
    10,
    1,
    raw_data(keyboard_requests),
    6,
    raw_data(keyboard_events),
}

touch_requests := []Message{
    { "release", "", raw_data([]^Interface{ }) },
}

touch_events := []Message{
    { "down", "uuoiff", raw_data([]^Interface{ nil, nil, &surface_interface, nil, nil, nil, }) },
    { "up", "uui", raw_data([]^Interface{ nil, nil, nil, }) },
    { "motion", "uiff", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "frame", "", raw_data([]^Interface{ }) },
    { "cancel", "", raw_data([]^Interface{ }) },
    { "shape", "iff", raw_data([]^Interface{ nil, nil, nil, }) },
    { "orientation", "if", raw_data([]^Interface{ nil, nil, }) },
}

touch_interface := Interface{
    "wl_touch",
    10,
    1,
    raw_data(touch_requests),
    7,
    raw_data(touch_events),
}

output_requests := []Message{
    { "release", "", raw_data([]^Interface{ }) },
}

output_events := []Message{
    { "geometry", "iiiiissi", raw_data([]^Interface{ nil, nil, nil, nil, nil, nil, nil, nil, }) },
    { "mode", "uiii", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "done", "", raw_data([]^Interface{ }) },
    { "scale", "i", raw_data([]^Interface{ nil, }) },
    { "name", "s", raw_data([]^Interface{ nil, }) },
    { "description", "s", raw_data([]^Interface{ nil, }) },
}

output_interface := Interface{
    "wl_output",
    4,
    1,
    raw_data(output_requests),
    6,
    raw_data(output_events),
}

region_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "add", "iiii", raw_data([]^Interface{ nil, nil, nil, nil, }) },
    { "subtract", "iiii", raw_data([]^Interface{ nil, nil, nil, nil, }) },
}

region_events := []Message{
}

region_interface := Interface{
    "wl_region",
    1,
    3,
    raw_data(region_requests),
    0,
    raw_data(region_events),
}

subcompositor_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "get_subsurface", "noo", raw_data([]^Interface{ &subsurface_interface, &surface_interface, &surface_interface, }) },
}

subcompositor_events := []Message{
}

subcompositor_interface := Interface{
    "wl_subcompositor",
    1,
    2,
    raw_data(subcompositor_requests),
    0,
    raw_data(subcompositor_events),
}

subsurface_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "set_position", "ii", raw_data([]^Interface{ nil, nil, }) },
    { "place_above", "o", raw_data([]^Interface{ &surface_interface, }) },
    { "place_below", "o", raw_data([]^Interface{ &surface_interface, }) },
    { "set_sync", "", raw_data([]^Interface{ }) },
    { "set_desync", "", raw_data([]^Interface{ }) },
}

subsurface_events := []Message{
}

subsurface_interface := Interface{
    "wl_subsurface",
    1,
    6,
    raw_data(subsurface_requests),
    0,
    raw_data(subsurface_events),
}

fixes_requests := []Message{
    { "destroy", "", raw_data([]^Interface{ }) },
    { "destroy_registry", "o", raw_data([]^Interface{ &registry_interface, }) },
}

fixes_events := []Message{
}

fixes_interface := Interface{
    "wl_fixes",
    1,
    2,
    raw_data(fixes_requests),
    0,
    raw_data(fixes_events),
}


Display_Error :: enum {
    Invalid_Object = 0,
    Invalid_Method = 1,
    No_Memory = 2,
    Implementation = 3,
}

Display_Listener :: struct{
    error: proc(
        data: rawptr,
        display: ^Display,
        object_id: ^Object,
        code: u32,
        message: cstring,
    ),
    delete_id: proc(
        data: rawptr,
        display: ^Display,
        id: u32,
    ),
}

display_add_listener :: #force_inline proc(display: ^Display, listener: ^Display_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)display,
        rawptr(listener),
        data
    )
}
display_set_user_data :: #force_inline proc(display: ^Display, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)display,
        user_data
    )
}
display_get_user_data :: #force_inline proc(display: ^Display) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)display)
}
display_get_version :: #force_inline proc(display: ^Display) -> u32 {
    return proxy_get_version(cast(^Proxy)display);
}

DISPLAY_SYNC :: 0
DISPLAY_GET_REGISTRY :: 1

display_sync :: #force_inline proc(
    display: ^Display,
) -> ^Callback {
    return cast(^Callback)proxy_marshal_flags(
        cast(^Proxy)display,
        DISPLAY_SYNC,
        &display_interface,
        proxy_get_version(cast(^Proxy)display),
        {},
        nil,
    )
}

display_get_registry :: #force_inline proc(
    display: ^Display,
) -> ^Registry {
    return cast(^Registry)proxy_marshal_flags(
        cast(^Proxy)display,
        DISPLAY_GET_REGISTRY,
        &display_interface,
        proxy_get_version(cast(^Proxy)display),
        {},
        nil,
    )
}


Registry_Listener :: struct{
    global: proc(
        data: rawptr,
        registry: ^Registry,
        name: u32,
        interface: cstring,
        version: u32,
    ),
    global_remove: proc(
        data: rawptr,
        registry: ^Registry,
        name: u32,
    ),
}

registry_add_listener :: #force_inline proc(registry: ^Registry, listener: ^Registry_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)registry,
        rawptr(listener),
        data
    )
}
registry_set_user_data :: #force_inline proc(registry: ^Registry, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)registry,
        user_data
    )
}
registry_get_user_data :: #force_inline proc(registry: ^Registry) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)registry)
}
registry_get_version :: #force_inline proc(registry: ^Registry) -> u32 {
    return proxy_get_version(cast(^Proxy)registry);
}

REGISTRY_BIND :: 0

registry_bind :: #force_inline proc(
    registry: ^Registry,
    name: u32,
    interface: ^Interface,
    version: u32,
) -> rawptr {
    return cast(rawptr)proxy_marshal_flags(
        cast(^Proxy)registry,
        REGISTRY_BIND,
        &registry_interface,
        version,
        {},
        name,
        nil,
    interface.name,
    version,
    )
}


Callback_Listener :: struct{
    done: proc(
        data: rawptr,
        callback: ^Callback,
        callback_data: u32,
    ),
}

callback_add_listener :: #force_inline proc(callback: ^Callback, listener: ^Callback_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)callback,
        rawptr(listener),
        data
    )
}
callback_set_user_data :: #force_inline proc(callback: ^Callback, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)callback,
        user_data
    )
}
callback_get_user_data :: #force_inline proc(callback: ^Callback) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)callback)
}
callback_get_version :: #force_inline proc(callback: ^Callback) -> u32 {
    return proxy_get_version(cast(^Proxy)callback);
}



Compositor_Listener :: struct{
}

compositor_add_listener :: #force_inline proc(compositor: ^Compositor, listener: ^Compositor_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)compositor,
        rawptr(listener),
        data
    )
}
compositor_set_user_data :: #force_inline proc(compositor: ^Compositor, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)compositor,
        user_data
    )
}
compositor_get_user_data :: #force_inline proc(compositor: ^Compositor) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)compositor)
}
compositor_get_version :: #force_inline proc(compositor: ^Compositor) -> u32 {
    return proxy_get_version(cast(^Proxy)compositor);
}

COMPOSITOR_CREATE_SURFACE :: 0
COMPOSITOR_CREATE_REGION :: 1

compositor_create_surface :: #force_inline proc(
    compositor: ^Compositor,
) -> ^Surface {
    return cast(^Surface)proxy_marshal_flags(
        cast(^Proxy)compositor,
        COMPOSITOR_CREATE_SURFACE,
        &compositor_interface,
        proxy_get_version(cast(^Proxy)compositor),
        {},
        nil,
    )
}

compositor_create_region :: #force_inline proc(
    compositor: ^Compositor,
) -> ^Region {
    return cast(^Region)proxy_marshal_flags(
        cast(^Proxy)compositor,
        COMPOSITOR_CREATE_REGION,
        &compositor_interface,
        proxy_get_version(cast(^Proxy)compositor),
        {},
        nil,
    )
}


Shm_Pool_Listener :: struct{
}

shm_pool_add_listener :: #force_inline proc(shm_pool: ^Shm_Pool, listener: ^Shm_Pool_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)shm_pool,
        rawptr(listener),
        data
    )
}
shm_pool_set_user_data :: #force_inline proc(shm_pool: ^Shm_Pool, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)shm_pool,
        user_data
    )
}
shm_pool_get_user_data :: #force_inline proc(shm_pool: ^Shm_Pool) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)shm_pool)
}
shm_pool_get_version :: #force_inline proc(shm_pool: ^Shm_Pool) -> u32 {
    return proxy_get_version(cast(^Proxy)shm_pool);
}

SHM_POOL_CREATE_BUFFER :: 0
SHM_POOL_DESTROY :: 1
SHM_POOL_RESIZE :: 2

shm_pool_create_buffer :: #force_inline proc(
    shm_pool: ^Shm_Pool,
    offset: i32,
    width: i32,
    height: i32,
    stride: i32,
    format: Shm_Format,
) -> ^Buffer {
    return cast(^Buffer)proxy_marshal_flags(
        cast(^Proxy)shm_pool,
        SHM_POOL_CREATE_BUFFER,
        &shm_pool_interface,
        proxy_get_version(cast(^Proxy)shm_pool),
        {},
        nil,
        offset,
        width,
        height,
        stride,
        format,
    )
}

shm_pool_destroy :: #force_inline proc(
    shm_pool: ^Shm_Pool,
) {
    proxy_marshal_flags(
        cast(^Proxy)shm_pool,
        SHM_POOL_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

shm_pool_resize :: #force_inline proc(
    shm_pool: ^Shm_Pool,
    size: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)shm_pool,
        SHM_POOL_RESIZE,
        nil,
        1, //Unused
        {},
        size,
    )
}


Shm_Error :: enum {
    Invalid_Format = 0,
    Invalid_Stride = 1,
    Invalid_Fd = 2,
}

Shm_Format :: enum {
    Argb8888 = 0,
    Xrgb8888 = 1,
    C8 = 538982467,
    Rgb332 = 943867730,
    Bgr233 = 944916290,
    Xrgb4444 = 842093144,
    Xbgr4444 = 842089048,
    Rgbx4444 = 842094674,
    Bgrx4444 = 842094658,
    Argb4444 = 842093121,
    Abgr4444 = 842089025,
    Rgba4444 = 842088786,
    Bgra4444 = 842088770,
    Xrgb1555 = 892424792,
    Xbgr1555 = 892420696,
    Rgbx5551 = 892426322,
    Bgrx5551 = 892426306,
    Argb1555 = 892424769,
    Abgr1555 = 892420673,
    Rgba5551 = 892420434,
    Bgra5551 = 892420418,
    Rgb565 = 909199186,
    Bgr565 = 909199170,
    Rgb888 = 875710290,
    Bgr888 = 875710274,
    Xbgr8888 = 875709016,
    Rgbx8888 = 875714642,
    Bgrx8888 = 875714626,
    Abgr8888 = 875708993,
    Rgba8888 = 875708754,
    Bgra8888 = 875708738,
    Xrgb2101010 = 808669784,
    Xbgr2101010 = 808665688,
    Rgbx1010102 = 808671314,
    Bgrx1010102 = 808671298,
    Argb2101010 = 808669761,
    Abgr2101010 = 808665665,
    Rgba1010102 = 808665426,
    Bgra1010102 = 808665410,
    Yuyv = 1448695129,
    Yvyu = 1431918169,
    Uyvy = 1498831189,
    Vyuy = 1498765654,
    Ayuv = 1448433985,
    Nv12 = 842094158,
    Nv21 = 825382478,
    Nv16 = 909203022,
    Nv61 = 825644622,
    Yuv410 = 961959257,
    Yvu410 = 961893977,
    Yuv411 = 825316697,
    Yvu411 = 825316953,
    Yuv420 = 842093913,
    Yvu420 = 842094169,
    Yuv422 = 909202777,
    Yvu422 = 909203033,
    Yuv444 = 875713881,
    Yvu444 = 875714137,
    R8 = 538982482,
    R16 = 540422482,
    Rg88 = 943212370,
    Gr88 = 943215175,
    Rg1616 = 842221394,
    Gr1616 = 842224199,
    Xrgb16161616f = 1211388504,
    Xbgr16161616f = 1211384408,
    Argb16161616f = 1211388481,
    Abgr16161616f = 1211384385,
    Xyuv8888 = 1448434008,
    Vuy888 = 875713878,
    Vuy101010 = 808670550,
    Y210 = 808530521,
    Y212 = 842084953,
    Y216 = 909193817,
    Y410 = 808531033,
    Y412 = 842085465,
    Y416 = 909194329,
    Xvyu2101010 = 808670808,
    Xvyu12_16161616 = 909334104,
    Xvyu16161616 = 942954072,
    Y0l0 = 810299481,
    X0l0 = 810299480,
    Y0l2 = 843853913,
    X0l2 = 843853912,
    Yuv420_8bit = 942691673,
    Yuv420_10bit = 808539481,
    Xrgb8888_A8 = 943805016,
    Xbgr8888_A8 = 943800920,
    Rgbx8888_A8 = 943806546,
    Bgrx8888_A8 = 943806530,
    Rgb888_A8 = 943798354,
    Bgr888_A8 = 943798338,
    Rgb565_A8 = 943797586,
    Bgr565_A8 = 943797570,
    Nv24 = 875714126,
    Nv42 = 842290766,
    P210 = 808530512,
    P010 = 808530000,
    P012 = 842084432,
    P016 = 909193296,
    Axbxgxrx106106106106 = 808534593,
    Nv15 = 892425806,
    Q410 = 808531025,
    Q401 = 825242705,
    Xrgb16161616 = 942953048,
    Xbgr16161616 = 942948952,
    Argb16161616 = 942953025,
    Abgr16161616 = 942948929,
    C1 = 538980675,
    C2 = 538980931,
    C4 = 538981443,
    D1 = 538980676,
    D2 = 538980932,
    D4 = 538981444,
    D8 = 538982468,
    R1 = 538980690,
    R2 = 538980946,
    R4 = 538981458,
    R10 = 540029266,
    R12 = 540160338,
    Avuy8888 = 1498764865,
    Xvuy8888 = 1498764888,
    P030 = 808661072,
}

Shm_Listener :: struct{
    format: proc(
        data: rawptr,
        shm: ^Shm,
        format: u32,
    ),
}

shm_add_listener :: #force_inline proc(shm: ^Shm, listener: ^Shm_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)shm,
        rawptr(listener),
        data
    )
}
shm_set_user_data :: #force_inline proc(shm: ^Shm, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)shm,
        user_data
    )
}
shm_get_user_data :: #force_inline proc(shm: ^Shm) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)shm)
}
shm_get_version :: #force_inline proc(shm: ^Shm) -> u32 {
    return proxy_get_version(cast(^Proxy)shm);
}

SHM_CREATE_POOL :: 0
SHM_RELEASE :: 1

shm_create_pool :: #force_inline proc(
    shm: ^Shm,
    fd: i32,
    size: i32,
) -> ^Shm_Pool {
    return cast(^Shm_Pool)proxy_marshal_flags(
        cast(^Proxy)shm,
        SHM_CREATE_POOL,
        &shm_interface,
        proxy_get_version(cast(^Proxy)shm),
        {},
        nil,
        fd,
        size,
    )
}

shm_release :: #force_inline proc(
    shm: ^Shm,
) {
    proxy_marshal_flags(
        cast(^Proxy)shm,
        SHM_RELEASE,
        nil,
        1, //Unused
        {},
    )
}


Buffer_Listener :: struct{
    release: proc(
        data: rawptr,
        buffer: ^Buffer,
    ),
}

buffer_add_listener :: #force_inline proc(buffer: ^Buffer, listener: ^Buffer_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)buffer,
        rawptr(listener),
        data
    )
}
buffer_set_user_data :: #force_inline proc(buffer: ^Buffer, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)buffer,
        user_data
    )
}
buffer_get_user_data :: #force_inline proc(buffer: ^Buffer) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)buffer)
}
buffer_get_version :: #force_inline proc(buffer: ^Buffer) -> u32 {
    return proxy_get_version(cast(^Proxy)buffer);
}

BUFFER_DESTROY :: 0

buffer_destroy :: #force_inline proc(
    buffer: ^Buffer,
) {
    proxy_marshal_flags(
        cast(^Proxy)buffer,
        BUFFER_DESTROY,
        nil,
        1, //Unused
        {},
    )
}


Data_Offer_Error :: enum {
    Invalid_Finish = 0,
    Invalid_Action_Mask = 1,
    Invalid_Action = 2,
    Invalid_Offer = 3,
}

Data_Offer_Listener :: struct{
    offer: proc(
        data: rawptr,
        data_offer: ^Data_Offer,
        mime_type: cstring,
    ),
    source_actions: proc(
        data: rawptr,
        data_offer: ^Data_Offer,
        source_actions: u32,
    ),
    action: proc(
        data: rawptr,
        data_offer: ^Data_Offer,
        dnd_action: u32,
    ),
}

data_offer_add_listener :: #force_inline proc(data_offer: ^Data_Offer, listener: ^Data_Offer_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)data_offer,
        rawptr(listener),
        data
    )
}
data_offer_set_user_data :: #force_inline proc(data_offer: ^Data_Offer, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)data_offer,
        user_data
    )
}
data_offer_get_user_data :: #force_inline proc(data_offer: ^Data_Offer) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)data_offer)
}
data_offer_get_version :: #force_inline proc(data_offer: ^Data_Offer) -> u32 {
    return proxy_get_version(cast(^Proxy)data_offer);
}

DATA_OFFER_ACCEPT :: 0
DATA_OFFER_RECEIVE :: 1
DATA_OFFER_DESTROY :: 2
DATA_OFFER_FINISH :: 3
DATA_OFFER_SET_ACTIONS :: 4

data_offer_accept :: #force_inline proc(
    data_offer: ^Data_Offer,
    serial: u32,
    mime_type: cstring,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_offer,
        DATA_OFFER_ACCEPT,
        nil,
        1, //Unused
        {},
        serial,
        mime_type,
    )
}

data_offer_receive :: #force_inline proc(
    data_offer: ^Data_Offer,
    mime_type: cstring,
    fd: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_offer,
        DATA_OFFER_RECEIVE,
        nil,
        1, //Unused
        {},
        mime_type,
        fd,
    )
}

data_offer_destroy :: #force_inline proc(
    data_offer: ^Data_Offer,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_offer,
        DATA_OFFER_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

data_offer_finish :: #force_inline proc(
    data_offer: ^Data_Offer,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_offer,
        DATA_OFFER_FINISH,
        nil,
        1, //Unused
        {},
    )
}

data_offer_set_actions :: #force_inline proc(
    data_offer: ^Data_Offer,
    dnd_actions: Data_Device_Manager_Dnd_Action_Flags,
    preferred_action: Data_Device_Manager_Dnd_Action_Flags,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_offer,
        DATA_OFFER_SET_ACTIONS,
        nil,
        1, //Unused
        {},
        dnd_actions,
        preferred_action,
    )
}


Data_Source_Error :: enum {
    Invalid_Action_Mask = 0,
    Invalid_Source = 1,
}

Data_Source_Listener :: struct{
    target: proc(
        data: rawptr,
        data_source: ^Data_Source,
        mime_type: cstring,
    ),
    send: proc(
        data: rawptr,
        data_source: ^Data_Source,
        mime_type: cstring,
        fd: i32,
    ),
    cancelled: proc(
        data: rawptr,
        data_source: ^Data_Source,
    ),
    dnd_drop_performed: proc(
        data: rawptr,
        data_source: ^Data_Source,
    ),
    dnd_finished: proc(
        data: rawptr,
        data_source: ^Data_Source,
    ),
    action: proc(
        data: rawptr,
        data_source: ^Data_Source,
        dnd_action: u32,
    ),
}

data_source_add_listener :: #force_inline proc(data_source: ^Data_Source, listener: ^Data_Source_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)data_source,
        rawptr(listener),
        data
    )
}
data_source_set_user_data :: #force_inline proc(data_source: ^Data_Source, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)data_source,
        user_data
    )
}
data_source_get_user_data :: #force_inline proc(data_source: ^Data_Source) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)data_source)
}
data_source_get_version :: #force_inline proc(data_source: ^Data_Source) -> u32 {
    return proxy_get_version(cast(^Proxy)data_source);
}

DATA_SOURCE_OFFER :: 0
DATA_SOURCE_DESTROY :: 1
DATA_SOURCE_SET_ACTIONS :: 2

data_source_offer :: #force_inline proc(
    data_source: ^Data_Source,
    mime_type: cstring,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_source,
        DATA_SOURCE_OFFER,
        nil,
        1, //Unused
        {},
        mime_type,
    )
}

data_source_destroy :: #force_inline proc(
    data_source: ^Data_Source,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_source,
        DATA_SOURCE_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

data_source_set_actions :: #force_inline proc(
    data_source: ^Data_Source,
    dnd_actions: Data_Device_Manager_Dnd_Action_Flags,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_source,
        DATA_SOURCE_SET_ACTIONS,
        nil,
        1, //Unused
        {},
        dnd_actions,
    )
}


Data_Device_Error :: enum {
    Role = 0,
    Used_Source = 1,
}

Data_Device_Listener :: struct{
    data_offer: proc(
        data: rawptr,
        data_device: ^Data_Device,
        id: rawptr,
    ),
    enter: proc(
        data: rawptr,
        data_device: ^Data_Device,
        serial: u32,
        surface: ^Object,
        x: Fixed,
        y: Fixed,
        id: ^Object,
    ),
    leave: proc(
        data: rawptr,
        data_device: ^Data_Device,
    ),
    motion: proc(
        data: rawptr,
        data_device: ^Data_Device,
        time: u32,
        x: Fixed,
        y: Fixed,
    ),
    drop: proc(
        data: rawptr,
        data_device: ^Data_Device,
    ),
    selection: proc(
        data: rawptr,
        data_device: ^Data_Device,
        id: ^Object,
    ),
}

data_device_add_listener :: #force_inline proc(data_device: ^Data_Device, listener: ^Data_Device_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)data_device,
        rawptr(listener),
        data
    )
}
data_device_set_user_data :: #force_inline proc(data_device: ^Data_Device, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)data_device,
        user_data
    )
}
data_device_get_user_data :: #force_inline proc(data_device: ^Data_Device) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)data_device)
}
data_device_get_version :: #force_inline proc(data_device: ^Data_Device) -> u32 {
    return proxy_get_version(cast(^Proxy)data_device);
}

DATA_DEVICE_START_DRAG :: 0
DATA_DEVICE_SET_SELECTION :: 1
DATA_DEVICE_RELEASE :: 2

data_device_start_drag :: #force_inline proc(
    data_device: ^Data_Device,
    source: ^Data_Source,
    origin: ^Surface,
    icon: ^Surface,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_device,
        DATA_DEVICE_START_DRAG,
        nil,
        1, //Unused
        {},
        source,
        origin,
        icon,
        serial,
    )
}

data_device_set_selection :: #force_inline proc(
    data_device: ^Data_Device,
    source: ^Data_Source,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_device,
        DATA_DEVICE_SET_SELECTION,
        nil,
        1, //Unused
        {},
        source,
        serial,
    )
}

data_device_release :: #force_inline proc(
    data_device: ^Data_Device,
) {
    proxy_marshal_flags(
        cast(^Proxy)data_device,
        DATA_DEVICE_RELEASE,
        nil,
        1, //Unused
        {},
    )
}


Data_Device_Manager_Dnd_Action_Flag :: enum {
    None = 0,
    Copy = 1,
    Move = 2,
    Ask = 4,
}
Data_Device_Manager_Dnd_Action_Flags :: bit_set[Data_Device_Manager_Dnd_Action_Flag]

Data_Device_Manager_Listener :: struct{
}

data_device_manager_add_listener :: #force_inline proc(data_device_manager: ^Data_Device_Manager, listener: ^Data_Device_Manager_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)data_device_manager,
        rawptr(listener),
        data
    )
}
data_device_manager_set_user_data :: #force_inline proc(data_device_manager: ^Data_Device_Manager, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)data_device_manager,
        user_data
    )
}
data_device_manager_get_user_data :: #force_inline proc(data_device_manager: ^Data_Device_Manager) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)data_device_manager)
}
data_device_manager_get_version :: #force_inline proc(data_device_manager: ^Data_Device_Manager) -> u32 {
    return proxy_get_version(cast(^Proxy)data_device_manager);
}

DATA_DEVICE_MANAGER_CREATE_DATA_SOURCE :: 0
DATA_DEVICE_MANAGER_GET_DATA_DEVICE :: 1

data_device_manager_create_data_source :: #force_inline proc(
    data_device_manager: ^Data_Device_Manager,
) -> ^Data_Source {
    return cast(^Data_Source)proxy_marshal_flags(
        cast(^Proxy)data_device_manager,
        DATA_DEVICE_MANAGER_CREATE_DATA_SOURCE,
        &data_device_manager_interface,
        proxy_get_version(cast(^Proxy)data_device_manager),
        {},
        nil,
    )
}

data_device_manager_get_data_device :: #force_inline proc(
    data_device_manager: ^Data_Device_Manager,
    seat: ^Seat,
) -> ^Data_Device {
    return cast(^Data_Device)proxy_marshal_flags(
        cast(^Proxy)data_device_manager,
        DATA_DEVICE_MANAGER_GET_DATA_DEVICE,
        &data_device_manager_interface,
        proxy_get_version(cast(^Proxy)data_device_manager),
        {},
        nil,
        seat,
    )
}


Shell_Error :: enum {
    Role = 0,
}

Shell_Listener :: struct{
}

shell_add_listener :: #force_inline proc(shell: ^Shell, listener: ^Shell_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)shell,
        rawptr(listener),
        data
    )
}
shell_set_user_data :: #force_inline proc(shell: ^Shell, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)shell,
        user_data
    )
}
shell_get_user_data :: #force_inline proc(shell: ^Shell) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)shell)
}
shell_get_version :: #force_inline proc(shell: ^Shell) -> u32 {
    return proxy_get_version(cast(^Proxy)shell);
}

SHELL_GET_SHELL_SURFACE :: 0

shell_get_shell_surface :: #force_inline proc(
    shell: ^Shell,
    surface: ^Surface,
) -> ^Shell_Surface {
    return cast(^Shell_Surface)proxy_marshal_flags(
        cast(^Proxy)shell,
        SHELL_GET_SHELL_SURFACE,
        &shell_interface,
        proxy_get_version(cast(^Proxy)shell),
        {},
        nil,
        surface,
    )
}


Shell_Surface_Resize_Flag :: enum {
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
Shell_Surface_Resize_Flags :: bit_set[Shell_Surface_Resize_Flag]

Shell_Surface_Transient_Flag :: enum {
    Inactive = 1,
}
Shell_Surface_Transient_Flags :: bit_set[Shell_Surface_Transient_Flag]

Shell_Surface_Fullscreen_Method :: enum {
    Default = 0,
    Scale = 1,
    Driver = 2,
    Fill = 3,
}

Shell_Surface_Listener :: struct{
    ping: proc(
        data: rawptr,
        shell_surface: ^Shell_Surface,
        serial: u32,
    ),
    configure: proc(
        data: rawptr,
        shell_surface: ^Shell_Surface,
        edges: u32,
        width: i32,
        height: i32,
    ),
    popup_done: proc(
        data: rawptr,
        shell_surface: ^Shell_Surface,
    ),
}

shell_surface_add_listener :: #force_inline proc(shell_surface: ^Shell_Surface, listener: ^Shell_Surface_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)shell_surface,
        rawptr(listener),
        data
    )
}
shell_surface_set_user_data :: #force_inline proc(shell_surface: ^Shell_Surface, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)shell_surface,
        user_data
    )
}
shell_surface_get_user_data :: #force_inline proc(shell_surface: ^Shell_Surface) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)shell_surface)
}
shell_surface_get_version :: #force_inline proc(shell_surface: ^Shell_Surface) -> u32 {
    return proxy_get_version(cast(^Proxy)shell_surface);
}

SHELL_SURFACE_PONG :: 0
SHELL_SURFACE_MOVE :: 1
SHELL_SURFACE_RESIZE :: 2
SHELL_SURFACE_SET_TOPLEVEL :: 3
SHELL_SURFACE_SET_TRANSIENT :: 4
SHELL_SURFACE_SET_FULLSCREEN :: 5
SHELL_SURFACE_SET_POPUP :: 6
SHELL_SURFACE_SET_MAXIMIZED :: 7
SHELL_SURFACE_SET_TITLE :: 8
SHELL_SURFACE_SET_CLASS :: 9

shell_surface_pong :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_PONG,
        nil,
        1, //Unused
        {},
        serial,
    )
}

shell_surface_move :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    seat: ^Seat,
    serial: u32,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_MOVE,
        nil,
        1, //Unused
        {},
        seat,
        serial,
    )
}

shell_surface_resize :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    seat: ^Seat,
    serial: u32,
    edges: Shell_Surface_Resize_Flags,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_RESIZE,
        nil,
        1, //Unused
        {},
        seat,
        serial,
        edges,
    )
}

shell_surface_set_toplevel :: #force_inline proc(
    shell_surface: ^Shell_Surface,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_SET_TOPLEVEL,
        nil,
        1, //Unused
        {},
    )
}

shell_surface_set_transient :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    parent: ^Surface,
    x: i32,
    y: i32,
    flags: Shell_Surface_Transient_Flags,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_SET_TRANSIENT,
        nil,
        1, //Unused
        {},
        parent,
        x,
        y,
        flags,
    )
}

shell_surface_set_fullscreen :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    method: Shell_Surface_Fullscreen_Method,
    framerate: u32,
    output: ^Output,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_SET_FULLSCREEN,
        nil,
        1, //Unused
        {},
        method,
        framerate,
        output,
    )
}

shell_surface_set_popup :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    seat: ^Seat,
    serial: u32,
    parent: ^Surface,
    x: i32,
    y: i32,
    flags: Shell_Surface_Transient_Flags,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_SET_POPUP,
        nil,
        1, //Unused
        {},
        seat,
        serial,
        parent,
        x,
        y,
        flags,
    )
}

shell_surface_set_maximized :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    output: ^Output,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_SET_MAXIMIZED,
        nil,
        1, //Unused
        {},
        output,
    )
}

shell_surface_set_title :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    title: cstring,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_SET_TITLE,
        nil,
        1, //Unused
        {},
        title,
    )
}

shell_surface_set_class :: #force_inline proc(
    shell_surface: ^Shell_Surface,
    class_: cstring,
) {
    proxy_marshal_flags(
        cast(^Proxy)shell_surface,
        SHELL_SURFACE_SET_CLASS,
        nil,
        1, //Unused
        {},
        class_,
    )
}


Surface_Error :: enum {
    Invalid_Scale = 0,
    Invalid_Transform = 1,
    Invalid_Size = 2,
    Invalid_Offset = 3,
    Defunct_Role_Object = 4,
}

Surface_Listener :: struct{
    enter: proc(
        data: rawptr,
        surface: ^Surface,
        output: ^Object,
    ),
    leave: proc(
        data: rawptr,
        surface: ^Surface,
        output: ^Object,
    ),
    preferred_buffer_scale: proc(
        data: rawptr,
        surface: ^Surface,
        factor: i32,
    ),
    preferred_buffer_transform: proc(
        data: rawptr,
        surface: ^Surface,
        transform: u32,
    ),
}

surface_add_listener :: #force_inline proc(surface: ^Surface, listener: ^Surface_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)surface,
        rawptr(listener),
        data
    )
}
surface_set_user_data :: #force_inline proc(surface: ^Surface, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)surface,
        user_data
    )
}
surface_get_user_data :: #force_inline proc(surface: ^Surface) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)surface)
}
surface_get_version :: #force_inline proc(surface: ^Surface) -> u32 {
    return proxy_get_version(cast(^Proxy)surface);
}

SURFACE_DESTROY :: 0
SURFACE_ATTACH :: 1
SURFACE_DAMAGE :: 2
SURFACE_FRAME :: 3
SURFACE_SET_OPAQUE_REGION :: 4
SURFACE_SET_INPUT_REGION :: 5
SURFACE_COMMIT :: 6
SURFACE_SET_BUFFER_TRANSFORM :: 7
SURFACE_SET_BUFFER_SCALE :: 8
SURFACE_DAMAGE_BUFFER :: 9
SURFACE_OFFSET :: 10

surface_destroy :: #force_inline proc(
    surface: ^Surface,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

surface_attach :: #force_inline proc(
    surface: ^Surface,
    buffer: ^Buffer,
    x: i32,
    y: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_ATTACH,
        nil,
        1, //Unused
        {},
        buffer,
        x,
        y,
    )
}

surface_damage :: #force_inline proc(
    surface: ^Surface,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_DAMAGE,
        nil,
        1, //Unused
        {},
        x,
        y,
        width,
        height,
    )
}

surface_frame :: #force_inline proc(
    surface: ^Surface,
) -> ^Callback {
    return cast(^Callback)proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_FRAME,
        &surface_interface,
        proxy_get_version(cast(^Proxy)surface),
        {},
        nil,
    )
}

surface_set_opaque_region :: #force_inline proc(
    surface: ^Surface,
    region: ^Region,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_SET_OPAQUE_REGION,
        nil,
        1, //Unused
        {},
        region,
    )
}

surface_set_input_region :: #force_inline proc(
    surface: ^Surface,
    region: ^Region,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_SET_INPUT_REGION,
        nil,
        1, //Unused
        {},
        region,
    )
}

surface_commit :: #force_inline proc(
    surface: ^Surface,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_COMMIT,
        nil,
        1, //Unused
        {},
    )
}

surface_set_buffer_transform :: #force_inline proc(
    surface: ^Surface,
    transform: Output_Transform,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_SET_BUFFER_TRANSFORM,
        nil,
        1, //Unused
        {},
        transform,
    )
}

surface_set_buffer_scale :: #force_inline proc(
    surface: ^Surface,
    scale: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_SET_BUFFER_SCALE,
        nil,
        1, //Unused
        {},
        scale,
    )
}

surface_damage_buffer :: #force_inline proc(
    surface: ^Surface,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_DAMAGE_BUFFER,
        nil,
        1, //Unused
        {},
        x,
        y,
        width,
        height,
    )
}

surface_offset :: #force_inline proc(
    surface: ^Surface,
    x: i32,
    y: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)surface,
        SURFACE_OFFSET,
        nil,
        1, //Unused
        {},
        x,
        y,
    )
}


Seat_Capability_Flag :: enum {
    Pointer = 1,
    Keyboard = 2,
    Touch = 4,
}
Seat_Capability_Flags :: bit_set[Seat_Capability_Flag]

Seat_Error :: enum {
    Missing_Capability = 0,
}

Seat_Listener :: struct{
    capabilities: proc(
        data: rawptr,
        seat: ^Seat,
        capabilities: u32,
    ),
    name: proc(
        data: rawptr,
        seat: ^Seat,
        name: cstring,
    ),
}

seat_add_listener :: #force_inline proc(seat: ^Seat, listener: ^Seat_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)seat,
        rawptr(listener),
        data
    )
}
seat_set_user_data :: #force_inline proc(seat: ^Seat, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)seat,
        user_data
    )
}
seat_get_user_data :: #force_inline proc(seat: ^Seat) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)seat)
}
seat_get_version :: #force_inline proc(seat: ^Seat) -> u32 {
    return proxy_get_version(cast(^Proxy)seat);
}

SEAT_GET_POINTER :: 0
SEAT_GET_KEYBOARD :: 1
SEAT_GET_TOUCH :: 2
SEAT_RELEASE :: 3

seat_get_pointer :: #force_inline proc(
    seat: ^Seat,
) -> ^Pointer {
    return cast(^Pointer)proxy_marshal_flags(
        cast(^Proxy)seat,
        SEAT_GET_POINTER,
        &seat_interface,
        proxy_get_version(cast(^Proxy)seat),
        {},
        nil,
    )
}

seat_get_keyboard :: #force_inline proc(
    seat: ^Seat,
) -> ^Keyboard {
    return cast(^Keyboard)proxy_marshal_flags(
        cast(^Proxy)seat,
        SEAT_GET_KEYBOARD,
        &seat_interface,
        proxy_get_version(cast(^Proxy)seat),
        {},
        nil,
    )
}

seat_get_touch :: #force_inline proc(
    seat: ^Seat,
) -> ^Touch {
    return cast(^Touch)proxy_marshal_flags(
        cast(^Proxy)seat,
        SEAT_GET_TOUCH,
        &seat_interface,
        proxy_get_version(cast(^Proxy)seat),
        {},
        nil,
    )
}

seat_release :: #force_inline proc(
    seat: ^Seat,
) {
    proxy_marshal_flags(
        cast(^Proxy)seat,
        SEAT_RELEASE,
        nil,
        1, //Unused
        {},
    )
}


Pointer_Error :: enum {
    Role = 0,
}

Pointer_Button_State :: enum {
    Released = 0,
    Pressed = 1,
}

Pointer_Axis :: enum {
    Vertical_Scroll = 0,
    Horizontal_Scroll = 1,
}

Pointer_Axis_Source :: enum {
    Wheel = 0,
    Finger = 1,
    Continuous = 2,
    Wheel_Tilt = 3,
}

Pointer_Axis_Relative_Direction :: enum {
    Identical = 0,
    Inverted = 1,
}

Pointer_Listener :: struct{
    enter: proc(
        data: rawptr,
        pointer: ^Pointer,
        serial: u32,
        surface: ^Object,
        surface_x: Fixed,
        surface_y: Fixed,
    ),
    leave: proc(
        data: rawptr,
        pointer: ^Pointer,
        serial: u32,
        surface: ^Object,
    ),
    motion: proc(
        data: rawptr,
        pointer: ^Pointer,
        time: u32,
        surface_x: Fixed,
        surface_y: Fixed,
    ),
    button: proc(
        data: rawptr,
        pointer: ^Pointer,
        serial: u32,
        time: u32,
        button: u32,
        state: u32,
    ),
    axis: proc(
        data: rawptr,
        pointer: ^Pointer,
        time: u32,
        axis: u32,
        value: Fixed,
    ),
    frame: proc(
        data: rawptr,
        pointer: ^Pointer,
    ),
    axis_source: proc(
        data: rawptr,
        pointer: ^Pointer,
        axis_source: u32,
    ),
    axis_stop: proc(
        data: rawptr,
        pointer: ^Pointer,
        time: u32,
        axis: u32,
    ),
    axis_discrete: proc(
        data: rawptr,
        pointer: ^Pointer,
        axis: u32,
        discrete: i32,
    ),
    axis_value120: proc(
        data: rawptr,
        pointer: ^Pointer,
        axis: u32,
        value120: i32,
    ),
    axis_relative_direction: proc(
        data: rawptr,
        pointer: ^Pointer,
        axis: u32,
        direction: u32,
    ),
}

pointer_add_listener :: #force_inline proc(pointer: ^Pointer, listener: ^Pointer_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)pointer,
        rawptr(listener),
        data
    )
}
pointer_set_user_data :: #force_inline proc(pointer: ^Pointer, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)pointer,
        user_data
    )
}
pointer_get_user_data :: #force_inline proc(pointer: ^Pointer) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)pointer)
}
pointer_get_version :: #force_inline proc(pointer: ^Pointer) -> u32 {
    return proxy_get_version(cast(^Proxy)pointer);
}

POINTER_SET_CURSOR :: 0
POINTER_RELEASE :: 1

pointer_set_cursor :: #force_inline proc(
    pointer: ^Pointer,
    serial: u32,
    surface: ^Surface,
    hotspot_x: i32,
    hotspot_y: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)pointer,
        POINTER_SET_CURSOR,
        nil,
        1, //Unused
        {},
        serial,
        surface,
        hotspot_x,
        hotspot_y,
    )
}

pointer_release :: #force_inline proc(
    pointer: ^Pointer,
) {
    proxy_marshal_flags(
        cast(^Proxy)pointer,
        POINTER_RELEASE,
        nil,
        1, //Unused
        {},
    )
}


Keyboard_Keymap_Format :: enum {
    No_Keymap = 0,
    Xkb_V1 = 1,
}

Keyboard_Key_State :: enum {
    Released = 0,
    Pressed = 1,
    Repeated = 2,
}

Keyboard_Listener :: struct{
    keymap: proc(
        data: rawptr,
        keyboard: ^Keyboard,
        format: u32,
        fd: i32,
        size: u32,
    ),
    enter: proc(
        data: rawptr,
        keyboard: ^Keyboard,
        serial: u32,
        surface: ^Object,
        keys: ^Array,
    ),
    leave: proc(
        data: rawptr,
        keyboard: ^Keyboard,
        serial: u32,
        surface: ^Object,
    ),
    key: proc(
        data: rawptr,
        keyboard: ^Keyboard,
        serial: u32,
        time: u32,
        key: u32,
        state: u32,
    ),
    modifiers: proc(
        data: rawptr,
        keyboard: ^Keyboard,
        serial: u32,
        mods_depressed: u32,
        mods_latched: u32,
        mods_locked: u32,
        group: u32,
    ),
    repeat_info: proc(
        data: rawptr,
        keyboard: ^Keyboard,
        rate: i32,
        delay: i32,
    ),
}

keyboard_add_listener :: #force_inline proc(keyboard: ^Keyboard, listener: ^Keyboard_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)keyboard,
        rawptr(listener),
        data
    )
}
keyboard_set_user_data :: #force_inline proc(keyboard: ^Keyboard, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)keyboard,
        user_data
    )
}
keyboard_get_user_data :: #force_inline proc(keyboard: ^Keyboard) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)keyboard)
}
keyboard_get_version :: #force_inline proc(keyboard: ^Keyboard) -> u32 {
    return proxy_get_version(cast(^Proxy)keyboard);
}

KEYBOARD_RELEASE :: 0

keyboard_release :: #force_inline proc(
    keyboard: ^Keyboard,
) {
    proxy_marshal_flags(
        cast(^Proxy)keyboard,
        KEYBOARD_RELEASE,
        nil,
        1, //Unused
        {},
    )
}


Touch_Listener :: struct{
    down: proc(
        data: rawptr,
        touch: ^Touch,
        serial: u32,
        time: u32,
        surface: ^Object,
        id: i32,
        x: Fixed,
        y: Fixed,
    ),
    up: proc(
        data: rawptr,
        touch: ^Touch,
        serial: u32,
        time: u32,
        id: i32,
    ),
    motion: proc(
        data: rawptr,
        touch: ^Touch,
        time: u32,
        id: i32,
        x: Fixed,
        y: Fixed,
    ),
    frame: proc(
        data: rawptr,
        touch: ^Touch,
    ),
    cancel: proc(
        data: rawptr,
        touch: ^Touch,
    ),
    shape: proc(
        data: rawptr,
        touch: ^Touch,
        id: i32,
        major: Fixed,
        minor: Fixed,
    ),
    orientation: proc(
        data: rawptr,
        touch: ^Touch,
        id: i32,
        orientation: Fixed,
    ),
}

touch_add_listener :: #force_inline proc(touch: ^Touch, listener: ^Touch_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)touch,
        rawptr(listener),
        data
    )
}
touch_set_user_data :: #force_inline proc(touch: ^Touch, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)touch,
        user_data
    )
}
touch_get_user_data :: #force_inline proc(touch: ^Touch) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)touch)
}
touch_get_version :: #force_inline proc(touch: ^Touch) -> u32 {
    return proxy_get_version(cast(^Proxy)touch);
}

TOUCH_RELEASE :: 0

touch_release :: #force_inline proc(
    touch: ^Touch,
) {
    proxy_marshal_flags(
        cast(^Proxy)touch,
        TOUCH_RELEASE,
        nil,
        1, //Unused
        {},
    )
}


Output_Subpixel :: enum {
    Unknown = 0,
    None = 1,
    Horizontal_Rgb = 2,
    Horizontal_Bgr = 3,
    Vertical_Rgb = 4,
    Vertical_Bgr = 5,
}

Output_Transform :: enum {
    Normal = 0,
    _90 = 1,
    _180 = 2,
    _270 = 3,
    Flipped = 4,
    Flipped_90 = 5,
    Flipped_180 = 6,
    Flipped_270 = 7,
}

Output_Mode_Flag :: enum {
    Current = 1,
    Preferred = 2,
}
Output_Mode_Flags :: bit_set[Output_Mode_Flag]

Output_Listener :: struct{
    geometry: proc(
        data: rawptr,
        output: ^Output,
        x: i32,
        y: i32,
        physical_width: i32,
        physical_height: i32,
        subpixel: i32,
        make: cstring,
        model: cstring,
        transform: i32,
    ),
    mode: proc(
        data: rawptr,
        output: ^Output,
        flags: u32,
        width: i32,
        height: i32,
        refresh: i32,
    ),
    done: proc(
        data: rawptr,
        output: ^Output,
    ),
    scale: proc(
        data: rawptr,
        output: ^Output,
        factor: i32,
    ),
    name: proc(
        data: rawptr,
        output: ^Output,
        name: cstring,
    ),
    description: proc(
        data: rawptr,
        output: ^Output,
        description: cstring,
    ),
}

output_add_listener :: #force_inline proc(output: ^Output, listener: ^Output_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)output,
        rawptr(listener),
        data
    )
}
output_set_user_data :: #force_inline proc(output: ^Output, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)output,
        user_data
    )
}
output_get_user_data :: #force_inline proc(output: ^Output) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)output)
}
output_get_version :: #force_inline proc(output: ^Output) -> u32 {
    return proxy_get_version(cast(^Proxy)output);
}

OUTPUT_RELEASE :: 0

output_release :: #force_inline proc(
    output: ^Output,
) {
    proxy_marshal_flags(
        cast(^Proxy)output,
        OUTPUT_RELEASE,
        nil,
        1, //Unused
        {},
    )
}


Region_Listener :: struct{
}

region_add_listener :: #force_inline proc(region: ^Region, listener: ^Region_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)region,
        rawptr(listener),
        data
    )
}
region_set_user_data :: #force_inline proc(region: ^Region, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)region,
        user_data
    )
}
region_get_user_data :: #force_inline proc(region: ^Region) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)region)
}
region_get_version :: #force_inline proc(region: ^Region) -> u32 {
    return proxy_get_version(cast(^Proxy)region);
}

REGION_DESTROY :: 0
REGION_ADD :: 1
REGION_SUBTRACT :: 2

region_destroy :: #force_inline proc(
    region: ^Region,
) {
    proxy_marshal_flags(
        cast(^Proxy)region,
        REGION_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

region_add :: #force_inline proc(
    region: ^Region,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)region,
        REGION_ADD,
        nil,
        1, //Unused
        {},
        x,
        y,
        width,
        height,
    )
}

region_subtract :: #force_inline proc(
    region: ^Region,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)region,
        REGION_SUBTRACT,
        nil,
        1, //Unused
        {},
        x,
        y,
        width,
        height,
    )
}


Subcompositor_Error :: enum {
    Bad_Surface = 0,
    Bad_Parent = 1,
}

Subcompositor_Listener :: struct{
}

subcompositor_add_listener :: #force_inline proc(subcompositor: ^Subcompositor, listener: ^Subcompositor_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)subcompositor,
        rawptr(listener),
        data
    )
}
subcompositor_set_user_data :: #force_inline proc(subcompositor: ^Subcompositor, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)subcompositor,
        user_data
    )
}
subcompositor_get_user_data :: #force_inline proc(subcompositor: ^Subcompositor) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)subcompositor)
}
subcompositor_get_version :: #force_inline proc(subcompositor: ^Subcompositor) -> u32 {
    return proxy_get_version(cast(^Proxy)subcompositor);
}

SUBCOMPOSITOR_DESTROY :: 0
SUBCOMPOSITOR_GET_SUBSURFACE :: 1

subcompositor_destroy :: #force_inline proc(
    subcompositor: ^Subcompositor,
) {
    proxy_marshal_flags(
        cast(^Proxy)subcompositor,
        SUBCOMPOSITOR_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

subcompositor_get_subsurface :: #force_inline proc(
    subcompositor: ^Subcompositor,
    surface: ^Surface,
    parent: ^Surface,
) -> ^Subsurface {
    return cast(^Subsurface)proxy_marshal_flags(
        cast(^Proxy)subcompositor,
        SUBCOMPOSITOR_GET_SUBSURFACE,
        &subcompositor_interface,
        proxy_get_version(cast(^Proxy)subcompositor),
        {},
        nil,
        surface,
        parent,
    )
}


Subsurface_Error :: enum {
    Bad_Surface = 0,
}

Subsurface_Listener :: struct{
}

subsurface_add_listener :: #force_inline proc(subsurface: ^Subsurface, listener: ^Subsurface_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)subsurface,
        rawptr(listener),
        data
    )
}
subsurface_set_user_data :: #force_inline proc(subsurface: ^Subsurface, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)subsurface,
        user_data
    )
}
subsurface_get_user_data :: #force_inline proc(subsurface: ^Subsurface) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)subsurface)
}
subsurface_get_version :: #force_inline proc(subsurface: ^Subsurface) -> u32 {
    return proxy_get_version(cast(^Proxy)subsurface);
}

SUBSURFACE_DESTROY :: 0
SUBSURFACE_SET_POSITION :: 1
SUBSURFACE_PLACE_ABOVE :: 2
SUBSURFACE_PLACE_BELOW :: 3
SUBSURFACE_SET_SYNC :: 4
SUBSURFACE_SET_DESYNC :: 5

subsurface_destroy :: #force_inline proc(
    subsurface: ^Subsurface,
) {
    proxy_marshal_flags(
        cast(^Proxy)subsurface,
        SUBSURFACE_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

subsurface_set_position :: #force_inline proc(
    subsurface: ^Subsurface,
    x: i32,
    y: i32,
) {
    proxy_marshal_flags(
        cast(^Proxy)subsurface,
        SUBSURFACE_SET_POSITION,
        nil,
        1, //Unused
        {},
        x,
        y,
    )
}

subsurface_place_above :: #force_inline proc(
    subsurface: ^Subsurface,
    sibling: ^Surface,
) {
    proxy_marshal_flags(
        cast(^Proxy)subsurface,
        SUBSURFACE_PLACE_ABOVE,
        nil,
        1, //Unused
        {},
        sibling,
    )
}

subsurface_place_below :: #force_inline proc(
    subsurface: ^Subsurface,
    sibling: ^Surface,
) {
    proxy_marshal_flags(
        cast(^Proxy)subsurface,
        SUBSURFACE_PLACE_BELOW,
        nil,
        1, //Unused
        {},
        sibling,
    )
}

subsurface_set_sync :: #force_inline proc(
    subsurface: ^Subsurface,
) {
    proxy_marshal_flags(
        cast(^Proxy)subsurface,
        SUBSURFACE_SET_SYNC,
        nil,
        1, //Unused
        {},
    )
}

subsurface_set_desync :: #force_inline proc(
    subsurface: ^Subsurface,
) {
    proxy_marshal_flags(
        cast(^Proxy)subsurface,
        SUBSURFACE_SET_DESYNC,
        nil,
        1, //Unused
        {},
    )
}


Fixes_Listener :: struct{
}

fixes_add_listener :: #force_inline proc(fixes: ^Fixes, listener: ^Fixes_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)fixes,
        rawptr(listener),
        data
    )
}
fixes_set_user_data :: #force_inline proc(fixes: ^Fixes, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)fixes,
        user_data
    )
}
fixes_get_user_data :: #force_inline proc(fixes: ^Fixes) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)fixes)
}
fixes_get_version :: #force_inline proc(fixes: ^Fixes) -> u32 {
    return proxy_get_version(cast(^Proxy)fixes);
}

FIXES_DESTROY :: 0
FIXES_DESTROY_REGISTRY :: 1

fixes_destroy :: #force_inline proc(
    fixes: ^Fixes,
) {
    proxy_marshal_flags(
        cast(^Proxy)fixes,
        FIXES_DESTROY,
        nil,
        1, //Unused
        {},
    )
}

fixes_destroy_registry :: #force_inline proc(
    fixes: ^Fixes,
    registry: ^Registry,
) {
    proxy_marshal_flags(
        cast(^Proxy)fixes,
        FIXES_DESTROY_REGISTRY,
        nil,
        1, //Unused
        {},
        registry,
    )
}


