package wayland_client

Zwp_Relative_Pointer_Manager_V1 :: struct{}
Zwp_Relative_Pointer_V1 :: struct{}

zwp_relative_pointer_manager_v1_interfaces := [?]^Interface{
    &zwp_relative_pointer_v1_interface,
    &pointer_interface,
}

zwp_relative_pointer_manager_v1_requests := [?]Message{
    { "destroy", "", nil },
    { "get_relative_pointer", "no", &zwp_relative_pointer_manager_v1_interfaces[0] },
}


/*
 * get relative pointer objects
 * A global interface used for getting the relative pointer object for a
 * given pointer.
 */
zwp_relative_pointer_manager_v1_interface := Interface{
    "zwp_relative_pointer_manager_v1",
    1,
    0,
    nil,
    0,
    nil,
}

@(init)
zwp_relative_pointer_manager_v1_interface_init :: proc() {
    zwp_relative_pointer_manager_v1_interface.method_count = len(zwp_relative_pointer_manager_v1_requests)
    zwp_relative_pointer_manager_v1_interface.methods = &zwp_relative_pointer_manager_v1_requests[0]
}

zwp_relative_pointer_v1_interfaces := [?]^Interface{
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
}

zwp_relative_pointer_v1_requests := [?]Message{
    { "destroy", "", nil },
}

zwp_relative_pointer_v1_events := [?]Message{
    { "relative_motion", "uuffff", &zwp_relative_pointer_v1_interfaces[0] },
}

/*
 * relative pointer object
 * A wp_relative_pointer object is an extension to the wl_pointer interface
 * used for emitting relative pointer events. It shares the same focus as
 * wl_pointer objects of the same seat and will only emit events when it has
 * focus.
 */
zwp_relative_pointer_v1_interface := Interface{
    "zwp_relative_pointer_v1",
    1,
    0,
    nil,
    0,
    nil,
}

@(init)
zwp_relative_pointer_v1_interface_init :: proc() {
    zwp_relative_pointer_v1_interface.method_count = len(zwp_relative_pointer_v1_requests)
    zwp_relative_pointer_v1_interface.methods = &zwp_relative_pointer_v1_requests[0]
    zwp_relative_pointer_v1_interface.event_count = len(zwp_relative_pointer_v1_events)
    zwp_relative_pointer_v1_interface.events = &zwp_relative_pointer_v1_events[0]
}



zwp_relative_pointer_manager_v1_set_user_data :: #force_inline proc "contextless" (zwp_relative_pointer_manager_v1: ^Zwp_Relative_Pointer_Manager_V1, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)zwp_relative_pointer_manager_v1,
        user_data
    )
}
zwp_relative_pointer_manager_v1_get_user_data :: #force_inline proc "contextless" (zwp_relative_pointer_manager_v1: ^Zwp_Relative_Pointer_Manager_V1) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)zwp_relative_pointer_manager_v1)
}
zwp_relative_pointer_manager_v1_get_version :: #force_inline proc "contextless" (zwp_relative_pointer_manager_v1: ^Zwp_Relative_Pointer_Manager_V1) -> u32 {
    return proxy_get_version(cast(^Proxy)zwp_relative_pointer_manager_v1);
}

ZWP_RELATIVE_POINTER_MANAGER_V1_DESTROY :: 0
ZWP_RELATIVE_POINTER_MANAGER_V1_GET_RELATIVE_POINTER :: 1

/*
 * destroy the relative pointer manager object
 * Used by the client to notify the server that it will no longer use this
 * relative pointer manager object.
 */
zwp_relative_pointer_manager_v1_destroy :: #force_inline proc "contextless" (
    zwp_relative_pointer_manager_v1: ^Zwp_Relative_Pointer_Manager_V1,
) {
    proxy_marshal_flags(
        cast(^Proxy)zwp_relative_pointer_manager_v1,
        ZWP_RELATIVE_POINTER_MANAGER_V1_DESTROY,
        nil,
        1,
        {},
    )
}

/*
 * get a relative pointer object
 * Create a relative pointer interface given a wl_pointer object. See the
 * wp_relative_pointer interface for more details.
 */
zwp_relative_pointer_manager_v1_get_relative_pointer :: #force_inline proc "contextless" (
    zwp_relative_pointer_manager_v1: ^Zwp_Relative_Pointer_Manager_V1,
    pointer: ^Pointer,
) -> ^Zwp_Relative_Pointer_V1 {
    return cast(^Zwp_Relative_Pointer_V1)proxy_marshal_flags(
        cast(^Proxy)zwp_relative_pointer_manager_v1,
        ZWP_RELATIVE_POINTER_MANAGER_V1_GET_RELATIVE_POINTER,
        &zwp_relative_pointer_v1_interface,
        proxy_get_version(cast(^Proxy)zwp_relative_pointer_manager_v1),
        {},
        nil,
        pointer,
    )
}


Zwp_Relative_Pointer_V1_Listener :: struct{
    /*
     * relative pointer motion
     * Relative x/y pointer motion from the pointer of the seat associated with
     * this object.
     * 
     * A relative motion is in the same dimension as regular wl_pointer motion
     * events, except they do not represent an absolute position. For example,
     * moving a pointer from (x, y) to (x', y') would have the equivalent
     * relative motion (x' - x, y' - y). If a pointer motion caused the
     * absolute pointer position to be clipped by for example the edge of the
     * monitor, the relative motion is unaffected by the clipping and will
     * represent the unclipped motion.
     * 
     * This event also contains non-accelerated motion deltas. The
     * non-accelerated delta is, when applicable, the regular pointer motion
     * delta as it was before having applied motion acceleration and other
     * transformations such as normalization.
     * 
     * Note that the non-accelerated delta does not represent 'raw' events as
     * they were read from some device. Pointer motion acceleration is device-
     * and configuration-specific and non-accelerated deltas and accelerated
     * deltas may have the same value on some devices.
     * 
     * Relative motions are not coupled to wl_pointer.motion events, and can be
     * sent in combination with such events, but also independently. There may
     * also be scenarios where wl_pointer.motion is sent, but there is no
     * relative motion. The order of an absolute and relative motion event
     * originating from the same physical motion is not guaranteed.
     * 
     * If the client needs button events or focus state, it can receive them
     * from a wl_pointer object of the same seat that the wp_relative_pointer
     * object is associated with.
     */
    relative_motion: proc "c" (
        data: rawptr,
        zwp_relative_pointer_v1: ^Zwp_Relative_Pointer_V1,
        /*
         * high 32 bits of a 64 bit timestamp with microsecond granularity
         */
        utime_hi: u32,
        /*
         * low 32 bits of a 64 bit timestamp with microsecond granularity
         */
        utime_lo: u32,
        /*
         * the x component of the motion vector
         */
        dx: Fixed,
        /*
         * the y component of the motion vector
         */
        dy: Fixed,
        /*
         * the x component of the unaccelerated motion vector
         */
        dx_unaccel: Fixed,
        /*
         * the y component of the unaccelerated motion vector
         */
        dy_unaccel: Fixed,
    ),

}

zwp_relative_pointer_v1_add_listener :: #force_inline proc "contextless" (zwp_relative_pointer_v1: ^Zwp_Relative_Pointer_V1, listener: ^Zwp_Relative_Pointer_V1_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)zwp_relative_pointer_v1,
        rawptr(listener),
        data
    )
}
zwp_relative_pointer_v1_set_user_data :: #force_inline proc "contextless" (zwp_relative_pointer_v1: ^Zwp_Relative_Pointer_V1, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)zwp_relative_pointer_v1,
        user_data
    )
}
zwp_relative_pointer_v1_get_user_data :: #force_inline proc "contextless" (zwp_relative_pointer_v1: ^Zwp_Relative_Pointer_V1) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)zwp_relative_pointer_v1)
}
zwp_relative_pointer_v1_get_version :: #force_inline proc "contextless" (zwp_relative_pointer_v1: ^Zwp_Relative_Pointer_V1) -> u32 {
    return proxy_get_version(cast(^Proxy)zwp_relative_pointer_v1);
}

ZWP_RELATIVE_POINTER_V1_DESTROY :: 0

/*
 * release the relative pointer object
 */
zwp_relative_pointer_v1_destroy :: #force_inline proc "contextless" (
    zwp_relative_pointer_v1: ^Zwp_Relative_Pointer_V1,
) {
    proxy_marshal_flags(
        cast(^Proxy)zwp_relative_pointer_v1,
        ZWP_RELATIVE_POINTER_V1_DESTROY,
        nil,
        1,
        {},
    )
}


