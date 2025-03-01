package main

import "core:fmt"
import "core:os"
import "core:mem"
import "core:strings"
import "core:strconv"
import "core:encoding/xml"

Description :: struct {
    summary: string,
    description: string
}

Arg :: struct {
    name: string,
    type: string,
    interface: string,
    interface_type: string,
    summary: string
}

Request :: struct {
    name: string,
    description: Description,
    return_arg: Maybe(Arg),
    args: [dynamic]Arg
}

Event :: struct {
    name: string,
    description: Description,
    args: [dynamic]Arg
}

Entry :: struct {
    name: string,
    value: string,
    summary: string
}

Enum :: struct {
    name: string,
    description: Description,
    entries: [dynamic]Entry
}

Interface :: struct {
    name: string,
    type_name: string,
    version: string,

    description: Description,

    requests: [dynamic]Request,
    events: [dynamic]Event,
    enums: [dynamic]Enum
}

parse_description :: proc(elem: xml.Element) -> (desc: Description) {
    for attr in elem.attribs {
        if attr.key == "summary" {
            desc.summary = attr.val
            break
        }
    }
    
    if len(elem.value) > 0 {
        desc.description = elem.value[0].(string)
    } else {
        desc.summary = ""
        desc.description = ""
    }

    return
}

parse_arg :: proc(elem: xml.Element) -> (arg: Arg, err: mem.Allocator_Error) {
    for attr in elem.attribs {
        switch attr.key {
        case "name":
            arg.name = attr.val
        case "type":
            switch attr.val {
            case "fixed":
                arg.type = "Fixed"
            case "string":
                arg.type = "cstring"
            case "object":
                arg.type = "Object"
            case "new_id":
                arg.type = "Interface"
            case "array":
                arg.type = "Array"
            case "fd":
                arg.type = "i32"
            case:
                arg.type = attr.val
            }
        case "interface":
            arg.interface = strings.trim_prefix(attr.val, "wl_")
            arg.interface_type = strings.to_ada_case(arg.interface) or_return
        case "summary":
            arg.summary = attr.val
        }
    }

    return
}

parse_request :: proc(elems: []xml.Element, elem: xml.Element, iface_name: string) -> (req: Request, err: mem.Allocator_Error) {
    req.args = make([dynamic]Arg)

    for attr in elem.attribs {
        if attr.key == "name" {
            req.name = strings.concatenate({iface_name, "_", attr.val}) or_return
            break
        }
    }

    for child in elem.value {
        elem_id := child.(xml.Element_ID) or_continue
        child_elem := elems[elem_id]

        if child_elem.kind == .Comment do continue

        switch child_elem.ident {
        case "description":
            req.description = parse_description(child_elem)
        case "arg":
            arg := parse_arg(child_elem) or_return
            if arg.type == "Interface" {
                req.return_arg = arg
            }

            append(&req.args, arg)
        }
    }

    return
}

parse_event :: proc(elems: []xml.Element, elem: xml.Element) -> (ev: Event, err: mem.Allocator_Error) {
    for attr in elem.attribs {
        if attr.key == "name" {
            ev.name = attr.val
            break
        }
    }

    for child in elem.value {
        elem_id := child.(xml.Element_ID) or_continue
        child_elem := elems[elem_id]

        if child_elem.kind == .Comment do continue

        switch child_elem.ident {
        case "description":
            ev.description = parse_description(child_elem)
        case "arg":
            append(&ev.args, parse_arg(child_elem) or_return)
        }
    }

    return
}

parse_entry :: proc(elem: xml.Element) -> (entry: Entry, err: mem.Allocator_Error) {
    for attr in elem.attribs {
        switch attr.key {
        case "name":
            if byte(attr.val[0]) < 65 {
                entry.name = strings.concatenate({"_", strings.to_ada_case(attr.val) or_return}) or_return
            } else {
                entry.name = strings.to_ada_case(attr.val) or_return
            }
        case "value":
            entry.value = attr.val
        case "summary":
            entry.summary = attr.val
        }
    }

    return
}

parse_enum :: proc(elems: []xml.Element, elem: xml.Element, iface_type_name: string) -> (en: Enum, err: mem.Allocator_Error) {
    for attr in elem.attribs {
        if attr.key == "name" {
            en.name = strings.concatenate({iface_type_name, "_", strings.to_ada_case(attr.val)}) or_return
            break
        }
    }

    for child in elem.value {
        elem_id := child.(xml.Element_ID) or_continue
        child_elem := elems[elem_id]

        if child_elem.kind == .Comment do continue

        switch child_elem.ident {
        case "description":
            en.description = parse_description(child_elem)
        case "entry":
            append(&en.entries, parse_entry(child_elem) or_return)
        }
    }

    return
}

parse_interface :: proc(elems: []xml.Element, elem: xml.Element) -> (iface: Interface, err: mem.Allocator_Error) {
    for attr in elem.attribs {
        switch attr.key {
        case "name":
            iface.name = strings.trim_prefix(attr.val, "wl_")
            iface.type_name = strings.to_ada_case(iface.name) or_return
        case "version":
            iface.version = attr.val
        }
    }

    iface.requests = make([dynamic]Request)
    iface.events = make([dynamic]Event)
    iface.enums = make([dynamic]Enum)

    for child in elem.value {
        elem_id := child.(xml.Element_ID) or_continue
        child_elem := elems[elem_id]

        if child_elem.kind == .Comment do continue

        switch child_elem.ident {
        case "description":
            iface.description = parse_description(child_elem)
        case "request":
            append(&iface.requests, parse_request(elems, child_elem, iface.name) or_return)
        case "event":
            append(&iface.events, parse_event(elems, child_elem) or_return)
        case "enum":
            append(&iface.enums, parse_enum(elems, child_elem, iface.type_name) or_return)
        }
    }

    return
}

gen_description :: proc(desc: Description, level: int = 0) -> (s: string, err: mem.Allocator_Error) {
    b := strings.builder_make() or_return

    fmt.sbprintf(&b, "%s// %s \n", strings.repeat(" ", 4 * level) or_return, desc.summary)

    lines := strings.split_lines(desc.description) or_return

    for line in lines {
        fmt.sbprintf(&b, "%s// %s \n", strings.repeat(" ", 4 * level) or_return, strings.trim_space(line))
    }

    s = strings.to_string(b)

    return
}

gen_enum :: proc(enm: Enum) -> (s: string, err: mem.Allocator_Error) {
    b := strings.builder_make() or_return

    strings.write_string(&b, gen_description(enm.description) or_return)

    fmt.sbprintf(&b, "%s :: enum {{\n", enm.name)

    for entry in enm.entries {
        fmt.sbprintf(&b, "    // %s \n", entry.summary)
        fmt.sbprintf(&b, "    %s = %s,\n", entry.name, entry.value)
    }

    fmt.sbprint(&b, "}\n")

    s = strings.to_string(b)

    return
}

gen_event :: proc(ev: Event, iface_name: string, iface_type: string) -> (s: string, err: mem.Allocator_Error) {
    b := strings.builder_make() or_return

    fmt.sbprint(&b, gen_description(ev.description, 1) or_return)

    fmt.sbprintf(&b, "    %s: proc(\n", ev.name)

    fmt.sbprint(&b, "        data: rawptr,\n")
    fmt.sbprintf(&b, "        %s: ^%s,\n", iface_name, iface_type)

    for arg in ev.args {
        fmt.sbprintf(&b, "        // %s \n", arg.summary)
        fmt.sbprintf(&b, "        %s: %s,\n", arg.name, arg.type)
    }

    fmt.sbprint(&b, "    ),\n")

    s = strings.to_string(b)

    return
}

gen_request :: proc(req: Request, index: int, iface_name: string, iface_type_name: string) -> (s: string, err: mem.Allocator_Error) {
    b := strings.builder_make() or_return

    fmt.sbprint(&b, gen_description(req.description) or_return)
    fmt.sbprintf(&b, "%s :: proc(\n", req.name)

    fmt.sbprintf(&b, "    %s: ^%s,\n", iface_name, iface_type_name)

    r_arg, r_ok := req.return_arg.(Arg)
    r_empty_iface: bool
    itype: string

    if r_ok {
        if r_empty_iface = r_arg.interface == ""; r_empty_iface {
            itype = "rawptr"
        } else {
            itype = strings.concatenate({"^", r_arg.interface_type}) or_return
        }
    }

    for arg in req.args {
        if arg.type == "Interface" {
            if r_empty_iface {
                fmt.sbprint(&b, "    interface: ^Interface,\n")
                fmt.sbprint(&b, "    version: uint,\n")
            }
        } else {
            fmt.sbprintf(&b, "    // %s \n", arg.summary)

            if arg.type == "Object" && !r_empty_iface {
                fmt.sbprintf(&b, "    %s: ^%s,\n", arg.name, arg.interface_type)
            } else {
                fmt.sbprintf(&b, "    %s: %s,\n", arg.name, arg.type)
            }
        }
    }

    fmt.sbprint(&b, ")")

    if r_ok {
        fmt.sbprintf(&b, " -> (%s: /* %s */ %s) ", r_arg.name, r_arg.summary, itype)
    }

    fmt.sbprint(&b, "{\n")

    if r_ok {
        fmt.sbprintf(&b, "    %s = cast(%s)", r_arg.name, itype)
    } else {
        fmt.sbprint(&b, "    ")
    }

    fmt.sbprint(&b, "proxy_marshal_flags(\n")
    fmt.sbprintf(&b, "        cast(^Proxy)%s,\n", iface_name)
    fmt.sbprintf(&b, "        %d,\n", index)

    if r_ok {
        if r_empty_iface {
            fmt.sbprint(&b, "        interface,\n")
        } else {
            fmt.sbprintf(&b, "        &%s_interface,\n", r_arg.interface)
        }
    } else {
        fmt.sbprint(&b, "        nil,\n")
    }

    if r_ok && r_empty_iface {
        fmt.sbprint(&b, "        u32(version),\n")
    } else {
        fmt.sbprintf(&b, "        proxy_get_version(cast(^Proxy)%s),\n", iface_name)
    }

    fmt.sbprint(&b, "        {},\n")

    for arg in req.args {
        if arg.type == "Interface" {
            if r_empty_iface {
                fmt.sbprint(&b, "        interface.name,\n")
                fmt.sbprint(&b, "        version,\n")
            }
            fmt.sbprint(&b, "        nil,\n")
        } else {
            fmt.sbprintf(&b, "        %s,\n", arg.name)
        }
    }

    fmt.sbprint(&b, "    )\n")

    fmt.sbprint(&b, "    return\n}\n")

    s = strings.to_string(b)

    return
}

PROXY_ADD_LISTENER_FMT :: `
%[0]s_add_listener :: proc(%[0]s: ^%[1]s, implementation: ^%[1]s_Listener, data: rawptr) -> i32 {{
    return proxy_add_listener(
        cast(^Proxy)%[0]s,
        implementation,
        data
    )
}}
`

gen_interface :: proc(iface: Interface) -> (s: string, err: mem.Allocator_Error) {
    b := strings.builder_make() or_return

    if (iface.name != "display") {
        fmt.sbprintf(&b, "%s :: struct{{}} \n\n", iface.type_name)
    }

    for enm in iface.enums {
        fmt.sbprint(&b, gen_enum(enm) or_return)
        fmt.sbprint(&b, "\n")
    }

    fmt.sbprintf(&b, "%s_Listener :: struct {{\n", iface.type_name)

    for event in iface.events {
        fmt.sbprint(&b, gen_event(event, iface.name, iface.type_name) or_return)
    }

    fmt.sbprint(&b, "}\n\n")

    fmt.sbprintf(&b, PROXY_ADD_LISTENER_FMT, iface.name, iface.type_name)
    fmt.sbprint(&b, "\n")

    for req, i in iface.requests {
        fmt.sbprint(&b, gen_request(req, i, iface.name, iface.type_name) or_return)
        fmt.sbprint(&b, "\n")
    }

    s = strings.to_string(b)

    return
}

gen :: proc(xml_path: string) {
    doc, doc_err := xml.load_from_file(xml_path)
    if doc_err != nil {
        fmt.eprintf("Error while parsing wayland.xml: %v\n", doc_err)
        return
    }

    b, b_err := strings.builder_make()
    if b_err != nil {
        fmt.eprintf("Error while creating builder: %v\n", b_err)
        return
    }

    fmt.sbprint(&b, "package wayland_client\n\n")

    fmt.sbprint(&b, "foreign import wl \"system:wayland-client\"\n\n")

    interface_links := strings.builder_make()
    fmt.sbprint(&interface_links, "@(default_calling_convention=\"c\", link_prefix=\"wl_\")\n")
    fmt.sbprint(&interface_links, "foreign wl {\n")

    for interface in doc.elements[0].value[1:] {
        iface, iface_err := parse_interface(
            doc.elements[:],
            doc.elements[interface.(xml.Element_ID)]
        )
        if iface_err != nil {
            fmt.eprintf("Could not parse interface: %#v\n", iface_err)
            return
        }

        iface_desc, iface_desc_err := gen_description(iface.description, 1)
        if iface_desc_err != nil {
            fmt.eprintf("Could not parse interface desc: %#v\n", iface_desc_err)
            return
        }

        fmt.sbprint(&interface_links, iface_desc)
        fmt.sbprintf(&interface_links, "    %s_interface: Interface\n\n", iface.name)

        gened_iface, gened_iface_err := gen_interface(iface)
        if gened_iface_err != nil {
            fmt.eprintf("Could not gen interface: %#v\n", gened_iface_err)
            return
        }

        fmt.sbprint(&b, gened_iface)
        fmt.sbprint(&b, "\n")
    }

    fmt.sbprint(&interface_links, "}\n")
    fmt.sbprint(&b, strings.to_string(interface_links))

    name: string
    for attr in doc.elements[0].attribs {
        if attr.key == "name" {
            name = attr.val
            break
        }
    }

    path, path_err := strings.concatenate({"bindings/", name, ".odin"})
    if path_err != nil {
        fmt.eprintf("Could not built path: %#v\n", path_err)
        return
    }

    ok := os.write_entire_file(path, transmute([]u8)strings.to_string(b))
    if !ok {
        fmt.eprintf("Error while writing file\n")
        return
    }
}

main :: proc() {
    fd, fd_err := os.open("defs/")
    if fd_err != nil {
        fmt.eprintf("Error while reading defs dir: %v\n", fd_err)
        return
    }

    fis, fis_err := os.read_dir(fd, -1)
    if fis_err != nil {
        fmt.eprintf("Error while reading defs dir: %v\n", fis_err)
        return
    }

    for fi in fis {
        gen(fi.fullpath)
    }
}
