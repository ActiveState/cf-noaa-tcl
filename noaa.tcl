# -*- tcl -*-
##
# A Tcl binding to the protobuf (un)marshalling C code for
# metron/doppler/noaa messages.
#
# Note that this does not export any C APIs as stubs.
# It simply exposes the (un)marshalling functionality to Tcl scripts.
#
# Copyright (c) 2015 ActiveState, Andreas Kupries http://wiki.tcl.tk/andreas%20kupries

# # ## ### ##### ######## #############
## Requisites

package require critcl 3.1.13 ; # need critcl::emap,
                                # need argument-types "wideint"
                                # need argument-type "bytes"
                                # need opt-arg signaling via
                                #   "has_*" indicator arguments.
#critcl::config lines 0
critcl::buildrequirement {
    package require critcl::literals ;# Pool of field names.
    package require critcl::emap     ;# MessageType mapping.
}

# # ## ### ##### ######## #############

if {![critcl::compiling]} {
    error "Unable to build Log, no proper compiler found."
}

# # ## ### ##### ######## #############
## Administrivia

critcl::license \
    {Andreas Kupries} \
    {BSD licensed}

critcl::summary \
    {Tcl Binding to noaa (un)marshalling}

critcl::description {
    This package is a binding to the protobuf (un)marshalling
    C code for metron/doppler/noaa messages.
}

critcl::subject protobuf noaa
critcl::subject {writing noaa}     {scanning noaa}
critcl::subject {emitting noaa}    {parsing noaa}
critcl::subject {marshalling noaa} {unmarshalling noaa}
critcl::subject serialization      deserialization 
critcl::subject {data exchange format} {transfer format}

# # ## ### ##### ######## #############
## Implementation.

critcl::tcl 8.5

# # ## ### ##### ######## #############
## Access to the protobuf headers and sources
#
# Note: We are carrying a copy of the protobuf-c runtime library in
# this package and are building it as part of the binding.
#
# Note: Might have slow processing from critcl starkit, large (90K)
# file, and non-accelerated md5

critcl::cheaders  log.h
critcl::csources  log.c protobuf-c/protobuf-c.c

# # ## ### ##### ######## #############
## Define a few conveniences for use (ensemble cmd).

critcl::tsources policy.tcl

# # ## ### ##### ######## #############
## Main C section.

# # ## ### ##### ######## #############
## Commands and bindings for the (un)marshall code.

critcl::source common.tcl ; # shared definitions
critcl::source pack.tcl   ; # marshalling
critcl::source unpack.tcl ; # unmarshalling

# # ## ### ##### ######## #############
## Make the C pieces ready. Immediate build of the binaries, no deferal.

critcl::msg -nonewline { Building ...}
if {![critcl::load]} {
    error "Building and loading cf::noaa failed."
}

# # ## ### ##### ######## #############

package provide cf::noaa 0.1
return

# vim: set sts=4 sw=4 tw=80 et ft=tcl:
