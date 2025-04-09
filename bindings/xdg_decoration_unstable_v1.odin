package wayland_client

Zxdg_Decoration_Manager_V1 :: struct{}
Zxdg_Toplevel_Decoration_V1 :: struct{}

zxdg_decoration_manager_v1_interfaces := [?]^Interface{
    &zxdg_toplevel_decoration_v1_interface,
    &xdg_toplevel_interface,
}

zxdg_decoration_manager_v1_requests := [?]Message{
    { "destroy", "", nil },
    { "get_toplevel_decoration", "no", &zxdg_decoration_manager_v1_interfaces[0] },
}


/*
 * window decoration manager
 * This interface allows a compositor to announce support for server-side
 * decorations.
 * 
 * A window decoration is a set of window controls as deemed appropriate by
 * the party managing them, such as user interface components used to move,
 * resize and change a window's state.
 * 
 * A client can use this protocol to request being decorated by a supporting
 * compositor.
 * 
 * If compositor and client do not negotiate the use of a server-side
 * decoration using this protocol, clients continue to self-decorate as they
 * see fit.
 * 
 * Warning! The protocol described in this file is experimental and
 * backward incompatible changes may be made. Backward compatible changes
 * may be added together with the corresponding interface version bump.
 * Backward incompatible changes are done by bumping the version number in
 * the protocol and interface names and resetting the interface version.
 * Once the protocol is to be declared stable, the 'z' prefix and the
 * version number in the protocol and interface names are removed and the
 * interface version number is reset.
 */
zxdg_decoration_manager_v1_interface := Interface{
    "zxdg_decoration_manager_v1",
    1,
    0,
    nil,
    0,
    nil,
}

@(init)
zxdg_decoration_manager_v1_interface_init :: proc() {
    zxdg_decoration_manager_v1_interface.method_count = len(zxdg_decoration_manager_v1_requests)
    zxdg_decoration_manager_v1_interface.methods = &zxdg_decoration_manager_v1_requests[0]
}

zxdg_toplevel_decoration_v1_interfaces := [?]^Interface{
    nil,
    nil,
}

zxdg_toplevel_decoration_v1_requests := [?]Message{
    { "destroy", "", nil },
    { "set_mode", "u", &zxdg_toplevel_decoration_v1_interfaces[0] },
    { "unset_mode", "", nil },
}

zxdg_toplevel_decoration_v1_events := [?]Message{
    { "configure", "u", &zxdg_toplevel_decoration_v1_interfaces[1] },
}

/*
 * decoration object for a toplevel surface
 * The decoration object allows the compositor to toggle server-side window
 * decorations for a toplevel surface. The client can request to switch to
 * another mode.
 * 
 * The xdg_toplevel_decoration object must be destroyed before its
 * xdg_toplevel.
 */
zxdg_toplevel_decoration_v1_interface := Interface{
    "zxdg_toplevel_decoration_v1",
    1,
    0,
    nil,
    0,
    nil,
}

@(init)
zxdg_toplevel_decoration_v1_interface_init :: proc() {
    zxdg_toplevel_decoration_v1_interface.method_count = len(zxdg_toplevel_decoration_v1_requests)
    zxdg_toplevel_decoration_v1_interface.methods = &zxdg_toplevel_decoration_v1_requests[0]
    zxdg_toplevel_decoration_v1_interface.event_count = len(zxdg_toplevel_decoration_v1_events)
    zxdg_toplevel_decoration_v1_interface.events = &zxdg_toplevel_decoration_v1_events[0]
}



zxdg_decoration_manager_v1_set_user_data :: #force_inline proc "contextless" (zxdg_decoration_manager_v1: ^Zxdg_Decoration_Manager_V1, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)zxdg_decoration_manager_v1,
        user_data
    )
}
zxdg_decoration_manager_v1_get_user_data :: #force_inline proc "contextless" (zxdg_decoration_manager_v1: ^Zxdg_Decoration_Manager_V1) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)zxdg_decoration_manager_v1)
}
zxdg_decoration_manager_v1_get_version :: #force_inline proc "contextless" (zxdg_decoration_manager_v1: ^Zxdg_Decoration_Manager_V1) -> u32 {
    return proxy_get_version(cast(^Proxy)zxdg_decoration_manager_v1);
}

ZXDG_DECORATION_MANAGER_V1_DESTROY :: 0
ZXDG_DECORATION_MANAGER_V1_GET_TOPLEVEL_DECORATION :: 1

/*
 * destroy the decoration manager object
 * Destroy the decoration manager. This doesn't destroy objects created
 * with the manager.
 */
zxdg_decoration_manager_v1_destroy :: #force_inline proc "contextless" (
    zxdg_decoration_manager_v1: ^Zxdg_Decoration_Manager_V1,
) {
    proxy_marshal_flags(
        cast(^Proxy)zxdg_decoration_manager_v1,
        ZXDG_DECORATION_MANAGER_V1_DESTROY,
        nil,
        1,
        {},
    )
}

/*
 * create a new toplevel decoration object
 * Create a new decoration object associated with the given toplevel.
 * 
 * Creating an xdg_toplevel_decoration from an xdg_toplevel which has a
 * buffer attached or committed is a client error, and any attempts by a
 * client to attach or manipulate a buffer prior to the first
 * xdg_toplevel_decoration.configure event must also be treated as
 * errors.
 */
zxdg_decoration_manager_v1_get_toplevel_decoration :: #force_inline proc "contextless" (
    zxdg_decoration_manager_v1: ^Zxdg_Decoration_Manager_V1,
    toplevel: ^Xdg_Toplevel,
) -> ^Zxdg_Toplevel_Decoration_V1 {
    return cast(^Zxdg_Toplevel_Decoration_V1)proxy_marshal_flags(
        cast(^Proxy)zxdg_decoration_manager_v1,
        ZXDG_DECORATION_MANAGER_V1_GET_TOPLEVEL_DECORATION,
        &zxdg_toplevel_decoration_v1_interface,
        proxy_get_version(cast(^Proxy)zxdg_decoration_manager_v1),
        {},
        nil,
        toplevel,
    )
}


Zxdg_Toplevel_Decoration_V1_Error :: enum {
    /*
     * xdg_toplevel has a buffer attached before configure
     */
    Unconfigured_Buffer = 0,
    /*
     * xdg_toplevel already has a decoration object
     */
    Already_Constructed = 1,
    /*
     * xdg_toplevel destroyed before the decoration object
     */
    Orphaned = 2,
    /*
     * invalid mode
     */
    Invalid_Mode = 3,
}

/*
 * window decoration modes
 * These values describe window decoration modes.
 */
Zxdg_Toplevel_Decoration_V1_Mode :: enum {
    /*
     * no server-side window decoration
     */
    Client_Side = 1,
    /*
     * server-side window decoration
     */
    Server_Side = 2,
}

Zxdg_Toplevel_Decoration_V1_Listener :: struct{
    /*
     * notify a decoration mode change
     * The configure event configures the effective decoration mode. The
     * configured state should not be applied immediately. Clients must send an
     * ack_configure in response to this event. See xdg_surface.configure and
     * xdg_surface.ack_configure for details.
     * 
     * A configure event can be sent at any time. The specified mode must be
     * obeyed by the client.
     */
    configure: proc "c" (
        data: rawptr,
        zxdg_toplevel_decoration_v1: ^Zxdg_Toplevel_Decoration_V1,
        /*
         * the decoration mode
         */
        mode: Zxdg_Toplevel_Decoration_V1_Mode,
    ),

}

zxdg_toplevel_decoration_v1_add_listener :: #force_inline proc "contextless" (zxdg_toplevel_decoration_v1: ^Zxdg_Toplevel_Decoration_V1, listener: ^Zxdg_Toplevel_Decoration_V1_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)zxdg_toplevel_decoration_v1,
        rawptr(listener),
        data
    )
}
zxdg_toplevel_decoration_v1_set_user_data :: #force_inline proc "contextless" (zxdg_toplevel_decoration_v1: ^Zxdg_Toplevel_Decoration_V1, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)zxdg_toplevel_decoration_v1,
        user_data
    )
}
zxdg_toplevel_decoration_v1_get_user_data :: #force_inline proc "contextless" (zxdg_toplevel_decoration_v1: ^Zxdg_Toplevel_Decoration_V1) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)zxdg_toplevel_decoration_v1)
}
zxdg_toplevel_decoration_v1_get_version :: #force_inline proc "contextless" (zxdg_toplevel_decoration_v1: ^Zxdg_Toplevel_Decoration_V1) -> u32 {
    return proxy_get_version(cast(^Proxy)zxdg_toplevel_decoration_v1);
}

ZXDG_TOPLEVEL_DECORATION_V1_DESTROY :: 0
ZXDG_TOPLEVEL_DECORATION_V1_SET_MODE :: 1
ZXDG_TOPLEVEL_DECORATION_V1_UNSET_MODE :: 2

/*
 * destroy the decoration object
 * Switch back to a mode without any server-side decorations at the next
 * commit.
 */
zxdg_toplevel_decoration_v1_destroy :: #force_inline proc "contextless" (
    zxdg_toplevel_decoration_v1: ^Zxdg_Toplevel_Decoration_V1,
) {
    proxy_marshal_flags(
        cast(^Proxy)zxdg_toplevel_decoration_v1,
        ZXDG_TOPLEVEL_DECORATION_V1_DESTROY,
        nil,
        1,
        {},
    )
}

/*
 * set the decoration mode
 * Set the toplevel surface decoration mode. This informs the compositor
 * that the client prefers the provided decoration mode.
 * 
 * After requesting a decoration mode, the compositor will respond by
 * emitting an xdg_surface.configure event. The client should then update
 * its content, drawing it without decorations if the received mode is
 * server-side decorations. The client must also acknowledge the configure
 * when committing the new content (see xdg_surface.ack_configure).
 * 
 * The compositor can decide not to use the client's mode and enforce a
 * different mode instead.
 * 
 * Clients whose decoration mode depend on the xdg_toplevel state may send
 * a set_mode request in response to an xdg_surface.configure event and wait
 * for the next xdg_surface.configure event to prevent unwanted state.
 * Such clients are responsible for preventing configure loops and must
 * make sure not to send multiple successive set_mode requests with the
 * same decoration mode.
 * 
 * If an invalid mode is supplied by the client, the invalid_mode protocol
 * error is raised by the compositor.
 */
zxdg_toplevel_decoration_v1_set_mode :: #force_inline proc "contextless" (
    zxdg_toplevel_decoration_v1: ^Zxdg_Toplevel_Decoration_V1,
    /*
     * the decoration mode
     */
    mode: Zxdg_Toplevel_Decoration_V1_Mode,
) {
    proxy_marshal_flags(
        cast(^Proxy)zxdg_toplevel_decoration_v1,
        ZXDG_TOPLEVEL_DECORATION_V1_SET_MODE,
        nil,
        1,
        {},
        mode,
    )
}

/*
 * unset the decoration mode
 * Unset the toplevel surface decoration mode. This informs the compositor
 * that the client doesn't prefer a particular decoration mode.
 * 
 * This request has the same semantics as set_mode.
 */
zxdg_toplevel_decoration_v1_unset_mode :: #force_inline proc "contextless" (
    zxdg_toplevel_decoration_v1: ^Zxdg_Toplevel_Decoration_V1,
) {
    proxy_marshal_flags(
        cast(^Proxy)zxdg_toplevel_decoration_v1,
        ZXDG_TOPLEVEL_DECORATION_V1_UNSET_MODE,
        nil,
        1,
        {},
    )
}


