package main

import "core:os"
import "core:encoding/xml"
import "core:fmt"
import "core:strconv"
import "core:strings"

import "base:runtime"

Arg_Type :: enum {
    Int,
    Uint,
    Fixed,
    String,
    Object,
    New_Id,
    Array,
    Fd
}

arg_type_syms := [Arg_Type]byte{
    .Int = 'i',
    .Uint = 'u',
    .Fixed = 'f',
    .String = 's',
    .Object = 'o',
    .New_Id = 'n',
    .Array = 'a',
    .Fd = 'h'
}

arg_type_odin_types := [Arg_Type]string{
    .Int = "i32",
    .Uint = "u32",
    .Fixed = "Fixed",
    .String = "cstring",
    .Object = "^Object",
    .New_Id = "rawptr",
    .Array = "^Array",
    .Fd = "i32"
}

Description :: struct {
    summary: string,
    value: Maybe(string)
}

parse_description :: proc(doc: ^xml.Document, elem: ^xml.Element) -> (desc: Description)  {
    desc.summary = elem.attribs[0].val

    if len(elem.value) > 0 {
        desc.value = elem.value[0].(string)
    }

    return
}

Arg :: struct {
    name: string,
    type: Arg_Type,
    summary: Maybe(string),
    interface: Maybe(string),
    nullable: bool,
    enum_: Maybe(string),

    description: Maybe(Description),
}

parse_arg :: proc(doc: ^xml.Document, elem: ^xml.Element) -> (arg: Arg)  {
    name: Maybe(string)
    type: Maybe(Arg_Type)

    for &attr in elem.attribs {
        switch attr.key {
        case "name":
            name = attr.val
        case "type":
            switch attr.val {
            case "int":
                type = .Int
            case "uint":
                type = .Uint
            case "fixed":
                type = .Fixed
            case "string":
                type = .String
            case "object":
                type = .Object
            case "new_id":
                type = .New_Id
            case "array":
                type = .Array
            case "fd":
                type = .Fd
            }
        case "summary":
            arg.summary = attr.val
        case "interface":
            arg.interface = attr.val
        case "allow-null":
            arg.nullable = attr.val == "true"
        case "enum":
            arg.enum_ = attr.val
        }
    }

    arg.name = name.(string)
    arg.type = type.(Arg_Type)

    for &val in elem.value {
        elem_id, elem_id_ok := val.(xml.Element_ID)
        if !elem_id_ok do continue
        child := doc.elements[elem_id]
        if child.kind != .Element do continue

        switch child.ident {
        case "description":
            arg.description = parse_description(doc, &child)
        }
    }

    return
}

Entry :: struct {
    name: string,
    value: int,
    summary: Maybe(string),
    avail_from: Maybe(uint),
    avail_to: Maybe(uint),

    description: Maybe(Description),
}

parse_entry :: proc(doc: ^xml.Document, elem: ^xml.Element) -> (entry: Entry)  {
    name: Maybe(string)
    value: Maybe(int)

    for &attr in elem.attribs {
        switch attr.key {
        case "name":
            name = attr.val
        case "value":
            value = assert_ok(strconv.parse_int(attr.val))
        case "summary":
            entry.summary = attr.val
        case "avail_from":
            entry.avail_from = assert_ok(strconv.parse_uint(attr.val))
        case "avail_to":
            entry.avail_to = assert_ok(strconv.parse_uint(attr.val))
        }
    }

    entry.name = name.(string)
    entry.value = value.(int)

    for &val in elem.value {
        elem_id, elem_id_ok := val.(xml.Element_ID)
        if !elem_id_ok do continue
        child := doc.elements[elem_id]
        if child.kind != .Element do continue

        switch child.ident {
        case "description":
            entry.description = parse_description(doc, &child)
        }
    }

    return
}

Enum :: struct {
    name: string,
    avail_from: Maybe(uint),
    bitfield: bool,

    description: Maybe(Description),
    entries: [dynamic]Entry,
}

parse_enum :: proc(doc: ^xml.Document, elem: ^xml.Element) -> (en: Enum)  {
    name: Maybe(string)

    for &attr in elem.attribs {
        switch attr.key {
        case "name":
            name = attr.val
        case "avail_from":
            en.avail_from = assert_ok(strconv.parse_uint(attr.val))
        case "bitfield":
            en.bitfield = attr.val == "true"
        }
    }

    en.name = name.(string)

    en.entries = make([dynamic]Entry)

    for &val in elem.value {
        elem_id, elem_id_ok := val.(xml.Element_ID)
        if !elem_id_ok do continue
        child := doc.elements[elem_id]
        if child.kind != .Element do continue

        switch child.ident {
        case "description":
            en.description = parse_description(doc, &child)
        case "entry":
            append(&en.entries, parse_entry(doc, &child))
        }
    }

    return
}

Event :: struct {
    name: string,
    type: Maybe(string),
    avail_from: Maybe(uint),
    avail_to: Maybe(uint),

    description: Maybe(Description),
    args: [dynamic]Arg
}

parse_event :: proc(doc: ^xml.Document, elem: ^xml.Element) -> (ev: Event)  {
    name: Maybe(string)

    for &attr in elem.attribs {
        switch attr.key {
        case "name":
            name = attr.val
        case "type":
            ev.type = attr.val
        case "avail_from":
            ev.avail_from = assert_ok(strconv.parse_uint(attr.val))
        case "avail_to":
            ev.avail_to = assert_ok(strconv.parse_uint(attr.val))
        }
    }

    ev.name = name.(string)

    ev.args = make([dynamic]Arg)

    for &val in elem.value {
        elem_id, elem_id_ok := val.(xml.Element_ID)
        if !elem_id_ok do continue
        child := doc.elements[elem_id]
        if child.kind != .Element do continue

        switch child.ident {
        case "description":
            ev.description = parse_description(doc, &child)
        case "arg":
            append(&ev.args, parse_arg(doc, &child))
        }
    }

    return
}

Request :: struct {
    name: string,
    type: Maybe(string),
    avail_from: Maybe(uint),
    avail_to: Maybe(uint),

    description: Maybe(Description),
    args: [dynamic]Arg
}

parse_request :: proc(doc: ^xml.Document, elem: ^xml.Element) -> (req: Request)  {
    name: Maybe(string)

    for &attr in elem.attribs {
        switch attr.key {
        case "name":
            name = attr.val
        case "type":
            req.type = attr.val
        case "avail_from":
            req.avail_from = assert_ok(strconv.parse_uint(attr.val))
        case "avail_to":
            req.avail_to = assert_ok(strconv.parse_uint(attr.val))
        }
    }

    req.name = name.(string)

    req.args = make([dynamic]Arg)

    for &val in elem.value {
        elem_id, elem_id_ok := val.(xml.Element_ID)
        if !elem_id_ok do continue
        child := doc.elements[elem_id]
        if child.kind != .Element do continue

        switch child.ident {
        case "description":
            req.description = parse_description(doc, &child)
        case "arg":
            append(&req.args, parse_arg(doc, &child))
        }
    }

    return
}

Interface :: struct {
    name: string,
    version: uint,

    description: Maybe(Description),
    requests: [dynamic]Request,
    events: [dynamic]Event,
    enums: [dynamic]Enum
}

parse_interface :: proc(doc: ^xml.Document, elem: ^xml.Element) -> (iface: Interface)  {
    name: Maybe(string)
    version: Maybe(uint)

    for &attr in elem.attribs {
        switch attr.key {
        case "name":
            name = attr.val
        case "version":
            version = assert_ok(strconv.parse_uint(attr.val))
        }
    }

    iface.name = name.(string)
    iface.version = version.(uint)

    iface.requests = make([dynamic]Request)
    iface.events = make([dynamic]Event)
    iface.enums = make([dynamic]Enum)

    for &val in elem.value {
        elem_id, elem_id_ok := val.(xml.Element_ID)
        if !elem_id_ok do continue
        child := doc.elements[elem_id]
        if child.kind != .Element do continue

        switch child.ident {
        case "description":
            iface.description = parse_description(doc, &child)
        case "request":
            append(&iface.requests, parse_request(doc, &child))
        case "event":
            append(&iface.events, parse_event(doc, &child))
        case "enum":
            append(&iface.enums, parse_enum(doc, &child))
        }
    }

    return
}

ADD_LISTENER_TMPL :: `%[0]s_add_listener :: #force_inline proc(%[0]s: ^%[1]s, listener: ^%[1]s_Listener, data: rawptr) -> i32 {{
    return proxy_add_listener(
        cast(^Proxy)%[0]s,
        rawptr(listener),
        data
    )
}}`

SET_USER_DATA_TMPL :: `%[0]s_set_user_data :: #force_inline proc(%[0]s: ^%[1]s, user_data: rawptr) {{
	proxy_set_user_data(
        cast(^Proxy)%[0]s,
        user_data
    )
}}`

GET_USER_DATA_TMPL :: `%[0]s_get_user_data :: #force_inline proc(%[0]s: ^%[1]s) -> rawptr {{
	return proxy_get_user_data(cast(^Proxy)%[0]s)
}}`

GET_VERSION_TMPL :: `%[0]s_get_version :: #force_inline proc(%[0]s: ^%[1]s) -> u32 {{
    return proxy_get_version(cast(^Proxy)%[0]s);
}}`

TMPL_FNS :: [?]string{
    ADD_LISTENER_TMPL,
    SET_USER_DATA_TMPL,
    GET_USER_DATA_TMPL,
    GET_VERSION_TMPL,
}

Interface_Gen :: struct {
    interfaces: string,
    requests: string,
    events: string,
    var_str: string,
    var_str_init: string,

    struct_str: string,
    enums: [dynamic]string,
    listener: string,
    tmpl_fns: string,
    request_idxs: [dynamic]string,
    request_fns: [dynamic]string,
}

get_args_sig :: proc (args: []Arg) -> string {
    sb := strings.builder_make()

    for arg in args {
        if _, ok := arg.interface.?; arg.type == .New_Id && !ok {
            strings.write_byte(&sb, 's')
            strings.write_byte(&sb, 'u')
        }

        if arg.nullable {
            strings.write_byte(&sb, '?')
        }

        strings.write_byte(&sb, arg_type_syms[arg.type])
    }

    return strings.to_string(sb)
}

get_arg_type :: proc(arg: Arg, iface: ^Interface, ifaces: []Interface) -> string {
    if t, ok := arg.interface.?; ok {
        return strings.concatenate({
            "^",
            strings.to_ada_case(strings.trim_prefix(t, "wl_")) //could error
        }) // could error
    } else if t, ok := arg.enum_.?; ok {
        if_t, _, enum_t := strings.partition(t, ".")

        if if_t == t {
            for e in iface.enums {
                if e.name == t {
                    if e.bitfield {
                        t = strings.concatenate({iface.name, "_", t, "_flags"}) //could error
                    } else {
                        t = strings.concatenate({iface.name, "_", t}) //could error
                    }

                    break
                }
            }
        } else {
            t, _ = strings.replace(t, ".", "_", 1)

            for i in ifaces {
                if i.name == if_t {
                    for e in i.enums {
                        if e.name == enum_t && e.bitfield {
                            t = strings.concatenate({t, "_flags"}) //could error

                            break
                        }
                    }
                }
            }
        }

        return strings.to_ada_case(strings.trim_prefix(t, "wl_")) //could error
    } else {
        return arg_type_odin_types[arg.type]
    }
}

get_description :: proc(desc: Maybe(Description), summary: Maybe(string) = nil, level: int = 0) -> string {
    desc, desc_ok := desc.?;
    summary, summary_ok := summary.?;
    if !desc_ok && !summary_ok do return ""

    has_summary := summary_ok && summary != ""

    v, v_ok := desc.value.?

    has_v := v_ok && v != ""
    has_s := desc.summary != ""

    if !has_v && !has_s && !has_summary do return ""
        
    sb := strings.builder_make()
    
    indent := strings.repeat(" ", level * 4) //could error

    fmt.sbprintfln(&sb, "%s/*", indent)

    if has_summary {
        fmt.sbprintfln(&sb, "%s * %s", indent, summary)
    }

    if has_s {
        fmt.sbprintfln(&sb, "%s * %s", indent, desc.summary)
    }

    if has_v {
        lines := strings.split_lines(v) //could error
        for line in lines {
            fmt.sbprintfln(&sb, "%s * %s", indent, strings.trim_space(line))
        }
    }

    fmt.sbprintfln(&sb, "%s */", indent)

    return strings.to_string(sb)
}

gen_interface :: proc(ifaces: []Interface, iface: ^Interface) -> (iface_gen: Interface_Gen) {
    sb := strings.builder_make()
    defer strings.builder_destroy(&sb)

    iname_sc := strings.trim_prefix(iface.name, "wl_")
    iname_ac := strings.to_ada_case(iname_sc) //could error
    iname_ssc := strings.to_screaming_snake_case(iname_sc) //could error

    has_reqs := len(iface.requests) > 0
    has_evs := len(iface.events) > 0

    // Request and event interfaces
    if has_reqs || has_evs {
        fmt.sbprintfln(&sb, "%s_interfaces := [?]^Interface{{", iname_sc)
        for req in iface.requests {
            for arg in req.args {
                if arg_iface, ok := arg.interface.(string); ok {
                    fmt.sbprintfln(&sb, "    &%s_interface,", strings.trim_prefix(arg_iface, "wl_"))
                } else {
                    fmt.sbprintln(&sb, "    nil,")
                }
            }
        }
        for ev in iface.events {
            for arg in ev.args {
                if arg_iface, ok := arg.interface.(string); ok {
                    fmt.sbprintfln(&sb, "    &%s_interface,", strings.trim_prefix(arg_iface, "wl_"))
                } else {
                    fmt.sbprintln(&sb, "    nil,")
                }
            }
        }
        fmt.sbprintln(&sb, "}")

        iface_gen.interfaces = strings.clone_from_bytes(sb.buf[:])
        strings.builder_reset(&sb)
    }

    // Requests

    interface_offset := 0

    if has_reqs {
        fmt.sbprintfln(&sb, "%s_requests := [?]Message{{", iname_sc)
        for req in iface.requests {
            fmt.sbprintf(&sb, "    {{ %q, %q, ", req.name, get_args_sig(req.args[:]))
            if len(req.args) > 0 {
                fmt.sbprintfln(&sb, "&%s_interfaces[%d] }},", iname_sc, interface_offset)
            } else {
                fmt.sbprintln(&sb, "nil },")
            }
            interface_offset += len(req.args)
        }
        fmt.sbprintln(&sb, "}")

        iface_gen.requests = strings.clone_from_bytes(sb.buf[:])
        strings.builder_reset(&sb)
    }

    // Events

    if has_evs {
        fmt.sbprintfln(&sb, "%s_events := [?]Message{{", iname_sc)
        for ev in iface.events {
            fmt.sbprintf(&sb, "    {{ %q, %q, ", ev.name, get_args_sig(ev.args[:]))
            if len(ev.args) > 0 {
                fmt.sbprintfln(&sb, "&%s_interfaces[%d] }},", iname_sc, interface_offset)
            } else {
                fmt.sbprintln(&sb, "nil },")
            }
            interface_offset += len(ev.args)
        }
        fmt.sbprintln(&sb, "}")

        iface_gen.events = strings.clone_from_bytes(sb.buf[:])
        strings.builder_reset(&sb)
    }

    // Interface definition

    fmt.sbprint(&sb, get_description(iface.description))
    fmt.sbprintfln(&sb, "%s_interface := Interface{{", iname_sc)
    fmt.sbprintfln(&sb, "    %q,", iface.name)
    fmt.sbprintfln(&sb, "    %d,", iface.version)
    fmt.sbprintln(&sb, "    0,")
    fmt.sbprintln(&sb, "    nil,")
    fmt.sbprintln(&sb, "    0,")
    fmt.sbprintln(&sb, "    nil,")
    fmt.sbprintln(&sb, "}")

    iface_gen.var_str = strings.clone_from_bytes(sb.buf[:])
    strings.builder_reset(&sb)

    // Interface init

    if has_reqs || has_evs {
        fmt.sbprintln(&sb, "@(init)")
        fmt.sbprintfln(&sb, "%s_interface_init :: proc() {{", iname_sc)
        if has_reqs {
            fmt.sbprintfln(&sb, "    %[0]s_interface.method_count = len(%[0]s_requests)", iname_sc)
            fmt.sbprintfln(&sb, "    %[0]s_interface.methods = &%[0]s_requests[0]", iname_sc)
        }
        if has_evs {
            fmt.sbprintfln(&sb, "    %[0]s_interface.event_count = len(%[0]s_events)", iname_sc)
            fmt.sbprintfln(&sb, "    %[0]s_interface.events = &%[0]s_events[0]", iname_sc)
        }
        fmt.sbprintln(&sb, "}")
    }

    iface_gen.var_str_init = strings.clone_from_bytes(sb.buf[:])
    strings.builder_reset(&sb)

    // Struct type definition

    iface_gen.struct_str = fmt.aprintfln("%s :: struct{{}}", iname_ac)

    // Enums

    iface_gen.enums = make([dynamic]string)

    for enum_ in iface.enums {
        ename_ac := strings.to_ada_case(enum_.name) //could error

        fmt.sbprint(&sb, get_description(enum_.description))

        if enum_.bitfield {
            fmt.sbprintfln(&sb, "%s_%s_Flag :: enum {{", iname_ac, ename_ac)
        } else {
            fmt.sbprintfln(&sb, "%s_%s :: enum {{", iname_ac, ename_ac)
        }

        for entry in enum_.entries {
            ename_ac := strings.to_ada_case(entry.name) //could error

            if (byte(entry.name[0]) < 65) {
                ename_ac = strings.concatenate({"_", ename_ac})
            }

            fmt.sbprint(&sb, get_description(entry.description, entry.summary, 1))
            fmt.sbprintfln(&sb, "    %s = %d,", ename_ac, entry.value)
        }
        fmt.sbprintln(&sb, "}")

        if enum_.bitfield {
            fmt.sbprintfln(&sb, "%[0]s_%[1]s_Flags :: bit_set[%[0]s_%[1]s_Flag]", iname_ac, ename_ac)
        }

        append(&iface_gen.enums, strings.clone_from_bytes(sb.buf[:]))
        strings.builder_reset(&sb)
    }

    // Event listener struct

    if has_evs {
        fmt.sbprintfln(&sb, "%s_Listener :: struct{{", iname_ac)
        for ev in iface.events {
            fmt.sbprint(&sb, get_description(ev.description, level = 1))
            fmt.sbprintfln(&sb, "    %s: proc(", ev.name)
            fmt.sbprintln(&sb, "        data: rawptr,")
            fmt.sbprintfln(&sb, "        %s: ^%s,", iname_sc, iname_ac)
            for arg in ev.args {
                fmt.sbprint(&sb, get_description(arg.description, arg.summary, 2))
                fmt.sbprintfln(&sb, "        %s: %s,", arg.name, get_arg_type(arg, iface, ifaces))
            }
            fmt.sbprintln(&sb, "    ),")
            fmt.sbprintln(&sb, "")
        }
        fmt.sbprintln(&sb, "}")

        iface_gen.listener = strings.clone_from_bytes(sb.buf[:])
        strings.builder_reset(&sb)
    }

    // Helper functions

    for tmpl_fn in TMPL_FNS {
        if tmpl_fn == ADD_LISTENER_TMPL && !has_evs do continue
        fmt.sbprintfln(&sb, tmpl_fn, iname_sc, iname_ac)
    }

    iface_gen.tmpl_fns = strings.clone_from_bytes(sb.buf[:])
    strings.builder_reset(&sb)

    // Requests/methods

    iface_gen.request_idxs = make([dynamic]string)
    iface_gen.request_fns = make([dynamic]string)

    for req, i in iface.requests {
        rname_ssc := strings.to_screaming_snake_case(req.name) //could error

        fmt.sbprint(&sb, get_description(req.description))
        fmt.sbprintfln(&sb, "%s_%s :: #force_inline proc(", iname_sc, req.name)
        fmt.sbprintfln(&sb, "    %s: ^%s,", iname_sc, iname_ac)

        ret_arg: ^Arg
        ret_ifc: string
        ret_ifc_ac: string
        ret_ifc_exists: bool
        for &arg in req.args {
            if arg.type == .New_Id {
                ret_arg = &arg
                ret_ifc, ret_ifc_exists = ret_arg.interface.(string)
                if ret_ifc_exists {
                    ret_ifc_ac = strings.to_ada_case(strings.trim_prefix(ret_ifc, "wl_")) //could error
                }
                continue
            }

            fmt.sbprint(&sb, get_description(arg.description, arg.summary, 1))
            fmt.sbprintfln(&sb, "    %s: %s,", arg.name, get_arg_type(arg, iface, ifaces))
        }

        if ret_arg == nil {
            fmt.sbprintln(&sb, ") {")
            fmt.sbprintln(&sb, "    proxy_marshal_flags(")
        } else {
            if ret_ifc_exists {
                fmt.sbprintfln(&sb, ") -> ^%s {{", ret_ifc_ac)
                fmt.sbprintfln(&sb, "    return cast(^%s)proxy_marshal_flags(", ret_ifc_ac)
            } else {
                fmt.sbprintln(&sb, "    interface: ^Interface,")
                fmt.sbprintln(&sb, "    version: u32,")

                fmt.sbprintln(&sb, ") -> rawptr {")
                fmt.sbprintln(&sb, "    return cast(rawptr)proxy_marshal_flags(")
            }
        }

        fmt.sbprintfln(&sb, "        cast(^Proxy)%s,", iname_sc)
        fmt.sbprintfln(&sb, "        %s_%s,", iname_ssc, rname_ssc)

        if ret_arg == nil {
            fmt.sbprintln(&sb, "        nil,")
        } else {
            if ret_ifc_exists {
                fmt.sbprintfln(&sb, "        &%s_interface,", ret_ifc)
            } else {
                fmt.sbprintln(&sb, "        interface,")
            }
        }

        if ret_arg == nil {
            fmt.sbprintln(&sb, "        1,")
        } else {
            if ret_ifc_exists {
                fmt.sbprintfln(&sb, "        proxy_get_version(cast(^Proxy)%s),", iname_sc)
            } else {
                fmt.sbprintln(&sb, "        version,")
            }
        }

        fmt.sbprintln(&sb, "        {},")

        for &arg in req.args {
            if arg.type == .New_Id {
                if !ret_ifc_exists {
                    fmt.sbprintln(&sb, "        interface.name,")
                    fmt.sbprintln(&sb, "        version,")
                }
                fmt.sbprintln(&sb, "        nil,")
            } else {
                fmt.sbprintfln(&sb, "        %s,", arg.name)
            }
        }

        fmt.sbprintln(&sb, "    )")
        fmt.sbprintln(&sb, "}")

        append(&iface_gen.request_idxs, fmt.aprintfln("%s_%s :: %d", iname_ssc, rname_ssc, i))
        append(&iface_gen.request_fns, strings.clone_from_bytes(sb.buf[:]))
        strings.builder_reset(&sb)
    }

    return
}

gen_def :: proc(path: string) {
    context.allocator = context.temp_allocator
    defer free_all(context.allocator)

    doc := assert_err(xml.load_from_file(path))

    protocol: ^xml.Element
    for &elem in doc.elements {
        if elem.ident == "protocol" {
            protocol = &elem
            break
        }
    }
    assert(protocol != nil)

    ifaces := make([dynamic]Interface)

    for &val in protocol.value {
        elem_id, elem_id_ok := val.(xml.Element_ID)
        if !elem_id_ok do continue
        elem := doc.elements[elem_id]
        if elem.ident != "interface" do continue

        append(&ifaces, parse_interface(doc, &elem))
    }

    g_ifaces := make([dynamic]Interface_Gen)

    for &iface in ifaces {
        append(&g_ifaces, gen_interface(ifaces[:], &iface))
    }

    pname: string
    for attr in protocol.attribs {
        if attr.key == "name" {
            pname = attr.val
            break
        }
    }
    assert(pname != "")

    fd_path := strings.concatenate({"bindings/", pname, ".odin"}) //could error
    fd := assert_err(os.open(
        fd_path,
        os.O_WRONLY|os.O_CREATE|os.O_TRUNC,
        os.S_IRUSR|os.S_IWUSR|os.S_IRGRP|os.S_IROTH
    ))
    defer assert(os.close(fd) == nil)

    fmt.fprintln(fd, "package wayland_client")
    fmt.fprintln(fd, "")

    for g_iface in g_ifaces {
        fmt.fprint(fd, g_iface.struct_str)
    }

    fmt.fprintln(fd, "")

    for g_iface in g_ifaces {
        fmt.fprintln(fd, g_iface.interfaces)
        fmt.fprintln(fd, g_iface.requests)
        fmt.fprintln(fd, g_iface.events)
        fmt.fprintln(fd, g_iface.var_str)
        fmt.fprintln(fd, g_iface.var_str_init)
    }

    fmt.fprintln(fd, "")

    for g_iface in g_ifaces {
        for enum_ in g_iface.enums do fmt.fprintln(fd, enum_)
        fmt.fprintln(fd, g_iface.listener)
        fmt.fprintln(fd, g_iface.tmpl_fns)
        for r_idx in g_iface.request_idxs do fmt.fprint(fd, r_idx)
        fmt.fprintln(fd, "")
        for r_fn in g_iface.request_fns do fmt.fprintln(fd, r_fn)

        fmt.fprintln(fd, "")
    }
}

main :: proc() {
    fd := assert_err(os.open("defs"))
    defer assert(os.close(fd) == nil)
    defs := assert_err(os.read_dir(fd, -1))

    for def in defs {
        gen_def(def.fullpath)
    }
}

assert_err :: proc(v: $T, err: $E, loc := #caller_location) -> T {
    assert(err == nil)
    return v
}

assert_ok :: proc(v: $T, ok: bool = false, loc := #caller_location) -> T {
    assert(ok, loc = loc)
    return v
}
