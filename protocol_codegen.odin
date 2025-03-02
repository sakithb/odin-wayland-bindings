package main

import "core:os"
import "core:encoding/xml"
import "core:fmt"
import "core:strconv"
import "core:strings"

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
            v, ok := strconv.parse_int(attr.val)
            fmt.ensuref(ok, "could not parse entry value")
            value = v
        case "summary":
            entry.summary = attr.val
        case "avail_from":
            v, ok := strconv.parse_uint(attr.val)
            fmt.ensuref(ok, "could not parse entry avail_from")
            entry.avail_from = v
        case "avail_to":
            v, ok := strconv.parse_uint(attr.val)
            fmt.ensuref(ok, "could not parse entry avail_to")
            entry.avail_to = v
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
            v, ok := strconv.parse_uint(attr.val)
            fmt.ensuref(ok, "could not parse enum avail_from")
            en.avail_from = v
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
            v, ok := strconv.parse_uint(attr.val)
            fmt.ensuref(ok, "could not parse event avail_from")
            ev.avail_from = v
        case "avail_to":
            v, ok := strconv.parse_uint(attr.val)
            fmt.ensuref(ok, "could not parse event avail_to")
            ev.avail_to = v
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
            v, ok := strconv.parse_uint(attr.val)
            fmt.ensuref(ok, "could not parse request avail_from")
            req.avail_from = v
        case "avail_to":
            v, ok := strconv.parse_uint(attr.val)
            fmt.ensuref(ok, "could not parse request avail_to")
            req.avail_to = v
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
            v, ok := strconv.parse_uint(attr.val)
            fmt.ensuref(ok, "could not parse interface version")
            version = v
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
    requests: string,
    events: string,
    var_str: string,

    struct_str: string,
    enums: [dynamic]string,
    listener: string,
    tmpl_fns: string,
    request_idxs: [dynamic]string,
    request_fns: [dynamic]string,
}

gen_interface :: proc(ifaces: []Interface, iface: ^Interface) -> (iface_gen: Interface_Gen) {
    sb := strings.builder_make()
    defer strings.builder_destroy(&sb)

    // Requests

    iname_sc := strings.trim_prefix(iface.name, "wl_")
    iname_ac, iname_ac_err := strings.to_ada_case(iname_sc)
    fmt.ensuref(iname_ac_err == nil, "could not convert interface name to ada case: %s", iname_sc)
    iname_ssc, iname_ssc_err := strings.to_screaming_snake_case(iname_sc)
    fmt.ensuref(iname_ssc_err == nil, "could not convert interface name to screaming snake case: %s", iname_sc)

    //fmt.sbprintfln(&sb, "%s_request_interfaces := []^Interface{{", iname_sc)
    //for req in iface.requests {
    //    for arg in req.args {
    //        if arg_iface, ok := arg.interface.(string); ok {
    //            fmt.sbprintfln(&sb, " &%s_interface,", strings.trim_prefix(arg_iface, "wl_"))
    //        } else {
    //            fmt.sbprintln(&sb, " nil,")
    //        }
    //    }
    //}
    //fmt.sbprintln(&sb, "}")

    fmt.sbprintfln(&sb, "%s_requests := []Message{{", iname_sc)
    //interface_offset := 0
    for req in iface.requests {
        fmt.sbprintf(&sb, "    {{ %q, \"", req.name)
        for arg in req.args {
            if arg.nullable do fmt.sbprint(&sb, "?")
            strings.write_byte(&sb, arg_type_syms[arg.type])
        }
        //fmt.sbprintfln(&sb, "\", raw_data(%s_request_interfaces[%d:]) }},", iname_sc, interface_offset)
        //interface_offset += len(req.args)
        fmt.sbprintf(&sb, "\", raw_data([]^Interface{{")
        for arg in req.args {
            if arg_iface, ok := arg.interface.(string); ok {
                fmt.sbprintf(&sb, " &%s_interface,", strings.trim_prefix(arg_iface, "wl_"))
            } else {
                fmt.sbprint(&sb, " nil,")
            }
        }
        fmt.sbprintln(&sb, " }) },")
    }
    fmt.sbprintln(&sb, "}")

    iface_gen.requests = strings.clone_from_bytes(sb.buf[:])
    strings.builder_reset(&sb)

    // Events

    //fmt.sbprintfln(&sb, "%s_event_interfaces := []^Interface{{", iname_sc)
    //for ev in iface.events {
    //    for arg in ev.args {
    //        if arg_iface, ok := arg.interface.(string); ok {
    //            fmt.sbprintfln(&sb, " &%s_interface,", strings.trim_prefix(arg_iface, "wl_"))
    //        } else {
    //            fmt.sbprintln(&sb, " nil,")
    //        }
    //    }
    //}
    //fmt.sbprintln(&sb, "}")

    fmt.sbprintfln(&sb, "%s_events := []Message{{", iname_sc)
    //interface_offset = 0
    for ev in iface.events {
        fmt.sbprintf(&sb, "    {{ %q, \"", ev.name)
        for arg in ev.args {
            if arg.nullable do fmt.sbprint(&sb, "?")
            strings.write_byte(&sb, arg_type_syms[arg.type])
        }
        //fmt.sbprintfln(&sb, "\", raw_data(%s_event_interfaces[%d:]) }},", iname_sc, interface_offset)
        //interface_offset += len(ev.args)
        fmt.sbprintf(&sb, "\", raw_data([]^Interface{{")
        for arg in ev.args {
            if arg_iface, ok := arg.interface.(string); ok {
                fmt.sbprintf(&sb, " &%s_interface,", strings.trim_prefix(arg_iface, "wl_"))
            } else {
                fmt.sbprint(&sb, " nil,")
            }
        }
        fmt.sbprintln(&sb, " }) },")
    }
    fmt.sbprintln(&sb, "}")

    iface_gen.events = strings.clone_from_bytes(sb.buf[:])
    strings.builder_reset(&sb)

    // Interface definition

    fmt.sbprintfln(&sb, "%s_interface := Interface{{", iname_sc)
    fmt.sbprintfln(&sb, "    %q,", iface.name)
    fmt.sbprintfln(&sb, "    %d,", iface.version)
    fmt.sbprintfln(&sb, "    %d,", len(iface.requests))
    fmt.sbprintfln(&sb, "    raw_data(%s_requests),", iname_sc)
    fmt.sbprintfln(&sb, "    %d,", len(iface.events))
    fmt.sbprintfln(&sb, "    raw_data(%s_events),", iname_sc)
    fmt.sbprintln(&sb, "}")

    iface_gen.var_str = strings.clone_from_bytes(sb.buf[:])
    strings.builder_reset(&sb)

    // Struct type definition

    iface_gen.struct_str = fmt.aprintfln("%s :: struct{{}}", iname_ac)

    // Enums

    iface_gen.enums = make([dynamic]string)

    for enum_ in iface.enums {
        ename_ac, ename_ac_err := strings.to_ada_case(enum_.name)
        fmt.ensuref(ename_ac_err == nil, "could not convert enum name to ada case: %s", enum_.name)

        if enum_.bitfield {
            fmt.sbprintfln(&sb, "%s_%s_Flag :: enum {{", iname_ac, ename_ac)
        } else {
            fmt.sbprintfln(&sb, "%s_%s :: enum {{", iname_ac, ename_ac)
        }

        for entry in enum_.entries {
            ename_ac, ename_ac_err := strings.to_ada_case(entry.name)
            fmt.ensuref(ename_ac_err == nil, "could not convert enum entry name to ada case: %s", entry.name)

            if (byte(entry.name[0]) < 65) {
                ename_ac = strings.concatenate({"_", ename_ac})
            }

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

    fmt.sbprintfln(&sb, "%s_Listener :: struct{{", iname_ac)
    for ev in iface.events {
        fmt.sbprintfln(&sb, "    %s: proc(", ev.name)
        fmt.sbprintln(&sb, "        data: rawptr,")
        fmt.sbprintfln(&sb, "        %s: ^%s,", iname_sc, iname_ac)
        for arg in ev.args {
            fmt.sbprintfln(&sb, "        %s: %s,", arg.name, arg_type_odin_types[arg.type])
        }
        fmt.sbprintln(&sb, "    ),")
    }
    fmt.sbprintln(&sb, "}")

    iface_gen.listener = strings.clone_from_bytes(sb.buf[:])
    strings.builder_reset(&sb)

    // Helper functions

    #unroll for tmpl_fn in TMPL_FNS {
        fmt.sbprintfln(&sb, tmpl_fn, iname_sc, iname_ac)
    }

    iface_gen.tmpl_fns = strings.clone_from_bytes(sb.buf[:])
    strings.builder_reset(&sb)

    // Requests/methods

    iface_gen.request_idxs = make([dynamic]string)
    iface_gen.request_fns = make([dynamic]string)

    for req, i in iface.requests {
        rname_ssc, rname_ssc_err := strings.to_screaming_snake_case(req.name)
        fmt.ensuref(rname_ssc_err == nil, "could not convert request name to screaming snake case: %s", req.name)

        fmt.sbprintfln(&sb, "%s_%s :: #force_inline proc(", iname_sc, req.name)
        fmt.sbprintfln(&sb, "    %s: ^%s,", iname_sc, iname_ac)

        r_arg: ^Arg
        r_ifc: string
        r_ifc_ac: string
        r_ifc_ok: bool
        for &arg in req.args {
            if arg.type == .New_Id {
                r_arg = &arg
                r_ifc, r_ifc_ok = r_arg.interface.(string)
                if r_ifc_ok {
                    r_ifc = strings.trim_prefix(r_ifc, "wl_")
                    ac, ac_err := strings.to_ada_case(r_ifc)
                    fmt.ensuref(ac_err == nil, "could not convert interface %s to ada case", r_ifc)
                    r_ifc_ac = ac
                }
                continue
            }

            if t, ok := arg.interface.(string); ok {
                ac, ac_err := strings.to_ada_case(strings.trim_prefix(t, "wl_"))
                fmt.ensuref(ac_err == nil, "could not convert interface %s to ada case", t)
                fmt.sbprintfln(&sb, "    %s: ^%s,", arg.name, ac)
            } else if t, ok := arg.enum_.(string); ok {
                t_iface, _, t_enum := strings.partition(t, ".")

                if t_iface == t {
                    for enum_ in iface.enums {
                        if enum_.name == t {
                            if enum_.bitfield {
                                v, err := strings.concatenate({iname_ac, "_", t, "_Flags"})
                                fmt.ensuref(err == nil, "could not concat bit_set %s_Flags", t)
                                t = v
                            } else {
                                v, err := strings.concatenate({iname_ac, "_", t})
                                fmt.ensuref(err == nil, "could not concat enum %s", t)
                                t = v
                            }

                            break
                        }
                    }
                } else {
                    t = strings.trim_prefix(t, "wl_")
                    t, _ = strings.replace(t, ".", "_", 1)

                    for _iface in ifaces {
                        if _iface.name == t_iface {
                            for _enum in _iface.enums {
                                if _enum.name == t_enum && _enum.bitfield {
                                    v, err := strings.concatenate({t, "_Flags"})
                                    fmt.ensuref(err == nil, "could not concat bit_set %s_Flags", t)
                                    t = v
                                    break
                                }
                            }
                        }
                    }
                }

                ac, ac_err := strings.to_ada_case(t)
                fmt.ensuref(ac_err == nil, "could not convert enum %s to ada case", t)
                fmt.sbprintfln(&sb, "    %s: %s,", arg.name, ac)
            } else {
                fmt.sbprintfln(&sb, "    %s: %s,", arg.name, arg_type_odin_types[arg.type])
            }
        }

        if r_arg == nil {
            fmt.sbprintln(&sb, ") {")
            fmt.sbprintln(&sb, "    proxy_marshal_flags(")
        } else {
            if r_ifc_ok {
                fmt.sbprintfln(&sb, ") -> ^%s {{", r_ifc_ac)
                fmt.sbprintfln(&sb, "    return cast(^%s)proxy_marshal_flags(", r_ifc_ac)
            } else {
                fmt.sbprintln(&sb, "    interface: ^Interface,")
                fmt.sbprintln(&sb, "    version: u32,")

                fmt.sbprintln(&sb, ") -> rawptr {")
                fmt.sbprintln(&sb, "    return cast(rawptr)proxy_marshal_flags(")
            }
        }

        fmt.sbprintfln(&sb, "        cast(^Proxy)%s,", iname_sc)
        fmt.sbprintfln(&sb, "        %s_%s,", iname_ssc, rname_ssc)

        if r_arg == nil {
            fmt.sbprintln(&sb, "        nil,")
        } else {
            fmt.sbprintfln(&sb, "        &%s_interface,", iname_sc)
        }

        if r_arg == nil {
            fmt.sbprintln(&sb, "        1, //Unused")
        } else {
            if r_ifc_ok {
                fmt.sbprintfln(&sb, "        proxy_get_version(cast(^Proxy)%s),", iname_sc)
            } else {
                fmt.sbprintln(&sb, "        version,")
            }
        }

        fmt.sbprintln(&sb, "        {},")

        for &arg in req.args {
            if arg.type == .New_Id {
                fmt.sbprintln(&sb, "        nil,")
            } else {
                fmt.sbprintfln(&sb, "        %s,", arg.name)
            }
        }

        if r_arg != nil && !r_ifc_ok {
            fmt.sbprintln(&sb, "    interface.name,")
            fmt.sbprintln(&sb, "    version,")
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

    doc, doc_err := xml.load_from_file(path)
    fmt.ensuref(doc_err == nil, "could not load def from %s", path)

    protocol: ^xml.Element
    for &elem in doc.elements {
        if elem.ident == "protocol" {
            protocol = &elem
            break
        }
    }
    fmt.ensuref(protocol != nil, "could not find protocol tag: %s", path)

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
    fmt.ensuref(pname != "", "could not find protocol name %s", path)

    fd_path, fd_path_err := strings.concatenate({"bindings/", pname, ".odin"})
    fmt.ensuref(fd_path_err == nil, "could not build write path %s", pname)

    fd, fd_err := os.open(
        fd_path,
        os.O_WRONLY|os.O_CREATE|os.O_TRUNC,
        os.S_IRUSR|os.S_IWUSR|os.S_IRGRP|os.S_IROTH
    )
    fmt.ensuref(fd_err == nil, "could not open %s", fd_path)
    defer fmt.ensuref(os.close(fd) == nil, "could not close %s", fd_path)

    fmt.fprintln(fd, "package wayland_client")
    fmt.fprintln(fd, "")

    for g_iface in g_ifaces {
        fmt.fprint(fd, g_iface.struct_str)
    }

    fmt.fprintln(fd, "")

    for g_iface in g_ifaces {
        fmt.fprintln(fd, g_iface.requests)
        fmt.fprintln(fd, g_iface.events)
        fmt.fprintln(fd, g_iface.var_str)
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
    fd, fd_err := os.open("defs")
    fmt.ensuref(fd_err == nil, "could not open defs directory")

    defs, defs_err := os.read_dir(fd, -1)
    fmt.ensuref(defs_err == nil, "could not read defs directory")

    for def in defs {
        gen_def(def.fullpath)
    }
}
