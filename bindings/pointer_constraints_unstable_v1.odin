package wayland_client

Zwp_Pointer_Constraints_V1 :: struct{}
Zwp_Locked_Pointer_V1 :: struct{}
Zwp_Confined_Pointer_V1 :: struct{}

zwp_pointer_constraints_v1_interfaces := [?]^Interface{
    &zwp_locked_pointer_v1_interface,
    &surface_interface,
    &pointer_interface,
    &region_interface,
    nil,
    &zwp_confined_pointer_v1_interface,
    &surface_interface,
    &pointer_interface,
    &region_interface,
    nil,
}

zwp_pointer_constraints_v1_requests := [?]Message{
    { "destroy", "", nil },
    { "lock_pointer", "noo?ou", &zwp_pointer_constraints_v1_interfaces[0] },
    { "confine_pointer", "noo?ou", &zwp_pointer_constraints_v1_interfaces[5] },
}


/*
 * constrain the movement of a pointer
 * The global interface exposing pointer constraining functionality. It
 * exposes two requests: lock_pointer for locking the pointer to its
 * position, and confine_pointer for locking the pointer to a region.
 * 
 * The lock_pointer and confine_pointer requests create the objects
 * wp_locked_pointer and wp_confined_pointer respectively, and the client can
 * use these objects to interact with the lock.
 * 
 * For any surface, only one lock or confinement may be active across all
 * wl_pointer objects of the same seat. If a lock or confinement is requested
 * when another lock or confinement is active or requested on the same surface
 * and with any of the wl_pointer objects of the same seat, an
 * 'already_constrained' error will be raised.
 */
zwp_pointer_constraints_v1_interface := Interface{
    "zwp_pointer_constraints_v1",
    1,
    0,
    nil,
    0,
    nil,
}

@(init)
zwp_pointer_constraints_v1_interface_init :: proc() {
    zwp_pointer_constraints_v1_interface.method_count = len(zwp_pointer_constraints_v1_requests)
    zwp_pointer_constraints_v1_interface.methods = &zwp_pointer_constraints_v1_requests[0]
}

zwp_locked_pointer_v1_interfaces := [?]^Interface{
    nil,
    nil,
    &region_interface,
}

zwp_locked_pointer_v1_requests := [?]Message{
    { "destroy", "", nil },
    { "set_cursor_position_hint", "ff", &zwp_locked_pointer_v1_interfaces[0] },
    { "set_region", "?o", &zwp_locked_pointer_v1_interfaces[2] },
}

zwp_locked_pointer_v1_events := [?]Message{
    { "locked", "", nil },
    { "unlocked", "", nil },
}

/*
 * receive relative pointer motion events
 * The wp_locked_pointer interface represents a locked pointer state.
 * 
 * While the lock of this object is active, the wl_pointer objects of the
 * associated seat will not emit any wl_pointer.motion events.
 * 
 * This object will send the event 'locked' when the lock is activated.
 * Whenever the lock is activated, it is guaranteed that the locked surface
 * will already have received pointer focus and that the pointer will be
 * within the region passed to the request creating this object.
 * 
 * To unlock the pointer, send the destroy request. This will also destroy
 * the wp_locked_pointer object.
 * 
 * If the compositor decides to unlock the pointer the unlocked event is
 * sent. See wp_locked_pointer.unlock for details.
 * 
 * When unlocking, the compositor may warp the cursor position to the set
 * cursor position hint. If it does, it will not result in any relative
 * motion events emitted via wp_relative_pointer.
 * 
 * If the surface the lock was requested on is destroyed and the lock is not
 * yet activated, the wp_locked_pointer object is now defunct and must be
 * destroyed.
 */
zwp_locked_pointer_v1_interface := Interface{
    "zwp_locked_pointer_v1",
    1,
    0,
    nil,
    0,
    nil,
}

@(init)
zwp_locked_pointer_v1_interface_init :: proc() {
    zwp_locked_pointer_v1_interface.method_count = len(zwp_locked_pointer_v1_requests)
    zwp_locked_pointer_v1_interface.methods = &zwp_locked_pointer_v1_requests[0]
    zwp_locked_pointer_v1_interface.event_count = len(zwp_locked_pointer_v1_events)
    zwp_locked_pointer_v1_interface.events = &zwp_locked_pointer_v1_events[0]
}

zwp_confined_pointer_v1_interfaces := [?]^Interface{
    &region_interface,
}

zwp_confined_pointer_v1_requests := [?]Message{
    { "destroy", "", nil },
    { "set_region", "?o", &zwp_confined_pointer_v1_interfaces[0] },
}

zwp_confined_pointer_v1_events := [?]Message{
    { "confined", "", nil },
    { "unconfined", "", nil },
}

/*
 * confined pointer object
 * The wp_confined_pointer interface represents a confined pointer state.
 * 
 * This object will send the event 'confined' when the confinement is
 * activated. Whenever the confinement is activated, it is guaranteed that
 * the surface the pointer is confined to will already have received pointer
 * focus and that the pointer will be within the region passed to the request
 * creating this object. It is up to the compositor to decide whether this
 * requires some user interaction and if the pointer will warp to within the
 * passed region if outside.
 * 
 * To unconfine the pointer, send the destroy request. This will also destroy
 * the wp_confined_pointer object.
 * 
 * If the compositor decides to unconfine the pointer the unconfined event is
 * sent. The wp_confined_pointer object is at this point defunct and should
 * be destroyed.
 */
zwp_confined_pointer_v1_interface := Interface{
    "zwp_confined_pointer_v1",
    1,
    0,
    nil,
    0,
    nil,
}

@(init)
zwp_confined_pointer_v1_interface_init :: proc() {
    zwp_confined_pointer_v1_interface.method_count = len(zwp_confined_pointer_v1_requests)
    zwp_confined_pointer_v1_interface.methods = &zwp_confined_pointer_v1_requests[0]
    zwp_confined_pointer_v1_interface.event_count = len(zwp_confined_pointer_v1_events)
    zwp_confined_pointer_v1_interface.events = &zwp_confined_pointer_v1_events[0]
}


/*
 * wp_pointer_constraints error values
 * These errors can be emitted in response to wp_pointer_constraints
 * requests.
 */
Zwp_Pointer_Constraints_V1_Error :: enum {
    /*
     * pointer constraint already requested on that surface
     */
    Already_Constrained = 1,
}

/*
 * constraint lifetime
 * These values represent different lifetime semantics. They are passed
 * as arguments to the factory requests to specify how the constraint
 * lifetimes should be managed.
 */
Zwp_Pointer_Constraints_V1_Lifetime :: enum {
    /*
     * the pointer constraint is defunct once deactivated
     * A oneshot pointer constraint will never reactivate once it has been
     * deactivated. See the corresponding deactivation event
     * (wp_locked_pointer.unlocked and wp_confined_pointer.unconfined) for
     * details.
     */
    Oneshot = 1,
    /*
     * the pointer constraint may reactivate
     * A persistent pointer constraint may again reactivate once it has
     * been deactivated. See the corresponding deactivation event
     * (wp_locked_pointer.unlocked and wp_confined_pointer.unconfined) for
     * details.
     */
    Persistent = 2,
}


zwp_pointer_constraints_v1_set_user_data :: #force_inline proc "contextless" (zwp_pointer_constraints_v1: ^Zwp_Pointer_Constraints_V1, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)zwp_pointer_constraints_v1,
        user_data
    )
}
zwp_pointer_constraints_v1_get_user_data :: #force_inline proc "contextless" (zwp_pointer_constraints_v1: ^Zwp_Pointer_Constraints_V1) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)zwp_pointer_constraints_v1)
}
zwp_pointer_constraints_v1_get_version :: #force_inline proc "contextless" (zwp_pointer_constraints_v1: ^Zwp_Pointer_Constraints_V1) -> u32 {
    return proxy_get_version(cast(^Proxy)zwp_pointer_constraints_v1);
}

ZWP_POINTER_CONSTRAINTS_V1_DESTROY :: 0
ZWP_POINTER_CONSTRAINTS_V1_LOCK_POINTER :: 1
ZWP_POINTER_CONSTRAINTS_V1_CONFINE_POINTER :: 2

/*
 * destroy the pointer constraints manager object
 * Used by the client to notify the server that it will no longer use this
 * pointer constraints object.
 */
zwp_pointer_constraints_v1_destroy :: #force_inline proc "contextless" (
    zwp_pointer_constraints_v1: ^Zwp_Pointer_Constraints_V1,
) {
    proxy_marshal_flags(
        cast(^Proxy)zwp_pointer_constraints_v1,
        ZWP_POINTER_CONSTRAINTS_V1_DESTROY,
        nil,
        1,
        {},
    )
}

/*
 * lock pointer to a position
 * The lock_pointer request lets the client request to disable movements of
 * the virtual pointer (i.e. the cursor), effectively locking the pointer
 * to a position. This request may not take effect immediately; in the
 * future, when the compositor deems implementation-specific constraints
 * are satisfied, the pointer lock will be activated and the compositor
 * sends a locked event.
 * 
 * The protocol provides no guarantee that the constraints are ever
 * satisfied, and does not require the compositor to send an error if the
 * constraints cannot ever be satisfied. It is thus possible to request a
 * lock that will never activate.
 * 
 * There may not be another pointer constraint of any kind requested or
 * active on the surface for any of the wl_pointer objects of the seat of
 * the passed pointer when requesting a lock. If there is, an error will be
 * raised. See general pointer lock documentation for more details.
 * 
 * The intersection of the region passed with this request and the input
 * region of the surface is used to determine where the pointer must be
 * in order for the lock to activate. It is up to the compositor whether to
 * warp the pointer or require some kind of user interaction for the lock
 * to activate. If the region is null the surface input region is used.
 * 
 * A surface may receive pointer focus without the lock being activated.
 * 
 * The request creates a new object wp_locked_pointer which is used to
 * interact with the lock as well as receive updates about its state. See
 * the the description of wp_locked_pointer for further information.
 * 
 * Note that while a pointer is locked, the wl_pointer objects of the
 * corresponding seat will not emit any wl_pointer.motion events, but
 * relative motion events will still be emitted via wp_relative_pointer
 * objects of the same seat. wl_pointer.axis and wl_pointer.button events
 * are unaffected.
 */
zwp_pointer_constraints_v1_lock_pointer :: #force_inline proc "contextless" (
    zwp_pointer_constraints_v1: ^Zwp_Pointer_Constraints_V1,
    /*
     * surface to lock pointer to
     */
    surface: ^Surface,
    /*
     * the pointer that should be locked
     */
    pointer: ^Pointer,
    /*
     * region of surface
     */
    region: ^Region,
    /*
     * lock lifetime
     */
    lifetime: Zwp_Pointer_Constraints_V1_Lifetime,
) -> ^Zwp_Locked_Pointer_V1 {
    return cast(^Zwp_Locked_Pointer_V1)proxy_marshal_flags(
        cast(^Proxy)zwp_pointer_constraints_v1,
        ZWP_POINTER_CONSTRAINTS_V1_LOCK_POINTER,
        &zwp_locked_pointer_v1_interface,
        proxy_get_version(cast(^Proxy)zwp_pointer_constraints_v1),
        {},
        nil,
        surface,
        pointer,
        region,
        lifetime,
    )
}

/*
 * confine pointer to a region
 * The confine_pointer request lets the client request to confine the
 * pointer cursor to a given region. This request may not take effect
 * immediately; in the future, when the compositor deems implementation-
 * specific constraints are satisfied, the pointer confinement will be
 * activated and the compositor sends a confined event.
 * 
 * The intersection of the region passed with this request and the input
 * region of the surface is used to determine where the pointer must be
 * in order for the confinement to activate. It is up to the compositor
 * whether to warp the pointer or require some kind of user interaction for
 * the confinement to activate. If the region is null the surface input
 * region is used.
 * 
 * The request will create a new object wp_confined_pointer which is used
 * to interact with the confinement as well as receive updates about its
 * state. See the the description of wp_confined_pointer for further
 * information.
 */
zwp_pointer_constraints_v1_confine_pointer :: #force_inline proc "contextless" (
    zwp_pointer_constraints_v1: ^Zwp_Pointer_Constraints_V1,
    /*
     * surface to lock pointer to
     */
    surface: ^Surface,
    /*
     * the pointer that should be confined
     */
    pointer: ^Pointer,
    /*
     * region of surface
     */
    region: ^Region,
    /*
     * confinement lifetime
     */
    lifetime: Zwp_Pointer_Constraints_V1_Lifetime,
) -> ^Zwp_Confined_Pointer_V1 {
    return cast(^Zwp_Confined_Pointer_V1)proxy_marshal_flags(
        cast(^Proxy)zwp_pointer_constraints_v1,
        ZWP_POINTER_CONSTRAINTS_V1_CONFINE_POINTER,
        &zwp_confined_pointer_v1_interface,
        proxy_get_version(cast(^Proxy)zwp_pointer_constraints_v1),
        {},
        nil,
        surface,
        pointer,
        region,
        lifetime,
    )
}


Zwp_Locked_Pointer_V1_Listener :: struct{
    /*
     * lock activation event
     * Notification that the pointer lock of the seat's pointer is activated.
     */
    locked: proc "c" (
        data: rawptr,
        zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1,
    ),

    /*
     * lock deactivation event
     * Notification that the pointer lock of the seat's pointer is no longer
     * active. If this is a oneshot pointer lock (see
     * wp_pointer_constraints.lifetime) this object is now defunct and should
     * be destroyed. If this is a persistent pointer lock (see
     * wp_pointer_constraints.lifetime) this pointer lock may again
     * reactivate in the future.
     */
    unlocked: proc "c" (
        data: rawptr,
        zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1,
    ),

}

zwp_locked_pointer_v1_add_listener :: #force_inline proc "contextless" (zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1, listener: ^Zwp_Locked_Pointer_V1_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)zwp_locked_pointer_v1,
        rawptr(listener),
        data
    )
}
zwp_locked_pointer_v1_set_user_data :: #force_inline proc "contextless" (zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)zwp_locked_pointer_v1,
        user_data
    )
}
zwp_locked_pointer_v1_get_user_data :: #force_inline proc "contextless" (zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)zwp_locked_pointer_v1)
}
zwp_locked_pointer_v1_get_version :: #force_inline proc "contextless" (zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1) -> u32 {
    return proxy_get_version(cast(^Proxy)zwp_locked_pointer_v1);
}

ZWP_LOCKED_POINTER_V1_DESTROY :: 0
ZWP_LOCKED_POINTER_V1_SET_CURSOR_POSITION_HINT :: 1
ZWP_LOCKED_POINTER_V1_SET_REGION :: 2

/*
 * destroy the locked pointer object
 * Destroy the locked pointer object. If applicable, the compositor will
 * unlock the pointer.
 */
zwp_locked_pointer_v1_destroy :: #force_inline proc "contextless" (
    zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1,
) {
    proxy_marshal_flags(
        cast(^Proxy)zwp_locked_pointer_v1,
        ZWP_LOCKED_POINTER_V1_DESTROY,
        nil,
        1,
        {},
    )
}

/*
 * set the pointer cursor position hint
 * Set the cursor position hint relative to the top left corner of the
 * surface.
 * 
 * If the client is drawing its own cursor, it should update the position
 * hint to the position of its own cursor. A compositor may use this
 * information to warp the pointer upon unlock in order to avoid pointer
 * jumps.
 * 
 * The cursor position hint is double-buffered state, see
 * wl_surface.commit.
 */
zwp_locked_pointer_v1_set_cursor_position_hint :: #force_inline proc "contextless" (
    zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1,
    /*
     * surface-local x coordinate
     */
    surface_x: Fixed,
    /*
     * surface-local y coordinate
     */
    surface_y: Fixed,
) {
    proxy_marshal_flags(
        cast(^Proxy)zwp_locked_pointer_v1,
        ZWP_LOCKED_POINTER_V1_SET_CURSOR_POSITION_HINT,
        nil,
        1,
        {},
        surface_x,
        surface_y,
    )
}

/*
 * set a new lock region
 * Set a new region used to lock the pointer.
 * 
 * The new lock region is double-buffered, see wl_surface.commit.
 * 
 * For details about the lock region, see wp_locked_pointer.
 */
zwp_locked_pointer_v1_set_region :: #force_inline proc "contextless" (
    zwp_locked_pointer_v1: ^Zwp_Locked_Pointer_V1,
    /*
     * region of surface
     */
    region: ^Region,
) {
    proxy_marshal_flags(
        cast(^Proxy)zwp_locked_pointer_v1,
        ZWP_LOCKED_POINTER_V1_SET_REGION,
        nil,
        1,
        {},
        region,
    )
}


Zwp_Confined_Pointer_V1_Listener :: struct{
    /*
     * pointer confined
     * Notification that the pointer confinement of the seat's pointer is
     * activated.
     */
    confined: proc "c" (
        data: rawptr,
        zwp_confined_pointer_v1: ^Zwp_Confined_Pointer_V1,
    ),

    /*
     * pointer unconfined
     * Notification that the pointer confinement of the seat's pointer is no
     * longer active. If this is a oneshot pointer confinement (see
     * wp_pointer_constraints.lifetime) this object is now defunct and should
     * be destroyed. If this is a persistent pointer confinement (see
     * wp_pointer_constraints.lifetime) this pointer confinement may again
     * reactivate in the future.
     */
    unconfined: proc "c" (
        data: rawptr,
        zwp_confined_pointer_v1: ^Zwp_Confined_Pointer_V1,
    ),

}

zwp_confined_pointer_v1_add_listener :: #force_inline proc "contextless" (zwp_confined_pointer_v1: ^Zwp_Confined_Pointer_V1, listener: ^Zwp_Confined_Pointer_V1_Listener, data: rawptr) -> i32 {
    return proxy_add_listener(
        cast(^Proxy)zwp_confined_pointer_v1,
        rawptr(listener),
        data
    )
}
zwp_confined_pointer_v1_set_user_data :: #force_inline proc "contextless" (zwp_confined_pointer_v1: ^Zwp_Confined_Pointer_V1, user_data: rawptr) {
	proxy_set_user_data(
        cast(^Proxy)zwp_confined_pointer_v1,
        user_data
    )
}
zwp_confined_pointer_v1_get_user_data :: #force_inline proc "contextless" (zwp_confined_pointer_v1: ^Zwp_Confined_Pointer_V1) -> rawptr {
	return proxy_get_user_data(cast(^Proxy)zwp_confined_pointer_v1)
}
zwp_confined_pointer_v1_get_version :: #force_inline proc "contextless" (zwp_confined_pointer_v1: ^Zwp_Confined_Pointer_V1) -> u32 {
    return proxy_get_version(cast(^Proxy)zwp_confined_pointer_v1);
}

ZWP_CONFINED_POINTER_V1_DESTROY :: 0
ZWP_CONFINED_POINTER_V1_SET_REGION :: 1

/*
 * destroy the confined pointer object
 * Destroy the confined pointer object. If applicable, the compositor will
 * unconfine the pointer.
 */
zwp_confined_pointer_v1_destroy :: #force_inline proc "contextless" (
    zwp_confined_pointer_v1: ^Zwp_Confined_Pointer_V1,
) {
    proxy_marshal_flags(
        cast(^Proxy)zwp_confined_pointer_v1,
        ZWP_CONFINED_POINTER_V1_DESTROY,
        nil,
        1,
        {},
    )
}

/*
 * set a new confine region
 * Set a new region used to confine the pointer.
 * 
 * The new confine region is double-buffered, see wl_surface.commit.
 * 
 * If the confinement is active when the new confinement region is applied
 * and the pointer ends up outside of newly applied region, the pointer may
 * warped to a position within the new confinement region. If warped, a
 * wl_pointer.motion event will be emitted, but no
 * wp_relative_pointer.relative_motion event.
 * 
 * The compositor may also, instead of using the new region, unconfine the
 * pointer.
 * 
 * For details about the confine region, see wp_confined_pointer.
 */
zwp_confined_pointer_v1_set_region :: #force_inline proc "contextless" (
    zwp_confined_pointer_v1: ^Zwp_Confined_Pointer_V1,
    /*
     * region of surface
     */
    region: ^Region,
) {
    proxy_marshal_flags(
        cast(^Proxy)zwp_confined_pointer_v1,
        ZWP_CONFINED_POINTER_V1_SET_REGION,
        nil,
        1,
        {},
        region,
    )
}


