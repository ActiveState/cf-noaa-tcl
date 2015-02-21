# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level -- Unpack -- HEARTBEAT - format/heartbeat.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/heartbeat.pb-c.h"

    Tcl_Obj*
    __cf_noaa_heartbeat_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__Heartbeat* e)
    {
	if (e->controlmessageidentifier) {
	    SUB (r, __cf_noaa_unpack_uuid_m,
		 e->controlmessageidentifier,
		 f_control_message_identifier);
	}

	Tcl_DictObjPut (interp, r, DSF (f_sent_count),     Tcl_NewWideIntObj (e->sentcount));
	Tcl_DictObjPut (interp, r, DSF (f_received_count), Tcl_NewWideIntObj (e->receivedcount));
	Tcl_DictObjPut (interp, r, DSF (f_error_count),    Tcl_NewWideIntObj (e->errorcount));

	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_heartbeat (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("heartbeat",
				 (unpacker) events__heartbeat__unpack,
				 (release)  events__heartbeat__free_unpacked,
				 (convert)  __cf_noaa_heartbeat_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_heartbeat_m (Tcl_Interp* interp, Events__Heartbeat* e)
    {
	return __cf_noaa_unpack_m ("heartbeat",
				   (convert)  __cf_noaa_heartbeat_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::heartbeat::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP(__cf_noaa_unpack_heartbeat (interp, length, data));
}

# # ## ### ##### ######## #############
