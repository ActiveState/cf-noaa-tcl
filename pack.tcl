# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level.
# Marshalling a log event.
# Result is a Tcl byte array containing the protobuf-encoded data.

# # ## ### ##### ######## #############
## result = ByteArray 

critcl::cproc cf::noaa::pack {
    Tcl_Interp*      interp
    bytes            message
    log_message_type message_type
    wideint          timestamp
    char*            {app_id          {""}}
    char*            {source_type     {""}}
    char*            {source_instance {""}}
} Tcl_Obj* {
    int                n;
    Tcl_Obj*           r;
    Events__LogMessage e;

    events__log_message__init (&e);
    e.message.data = message.s;
    e.message.len  = message.len;
    e.message_type = message_type;
    e.timestamp    = timestamp;

    if (has_app_id)          e.app_id          = app_id;
    if (has_source_type)     e.source_type     = source_type;
    if (has_source_instance) e.source_instance = source_instance;

    if (!protobuf_c_message_check ((ProtobufCMessage*) &e)) {
	return 0;
    }

    r = Tcl_NewByteArrayObj (0,0);
    events__log_message__pack (&e,
       Tcl_SetByteArrayLength (r,
	   events__log_message__get_packed_size (&e)));

    /* Done, do not forget to bump the ref count */
    Tcl_IncrRefCount (r);
    return r;
}

# # ## ### ##### ######## #############
