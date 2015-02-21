# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level -- Unpack -- ENVELOPE - format/envelope.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/envelope.pb-c.h"

    Tcl_Obj*
    __cf_noaa_envelope_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__Envelope* e)
    {
	/* Required fields */
	Tcl_DictObjPut (interp, r, DSF (f_origin),     Tcl_NewStringObj (e->origin, -1));
	Tcl_DictObjPut (interp, r, DSF (f_event_type), envelope_event_type_decode (interp, e->eventtype));

	if (e->has_timestamp) {
	    Tcl_DictObjPut (interp, r, DSF (f_timestamp), Tcl_NewWideIntObj (e->timestamp));
	}

	if (e->heartbeat)       SUB (r, __cf_noaa_unpack_heartbeat_m,       e->heartbeat,       f_heartbeat);
	if (e->httpstart)       SUB (r, __cf_noaa_unpack_httpstart_m,       e->httpstart,       f_http_start);
	if (e->httpstop)        SUB (r, __cf_noaa_unpack_httpstop_m,        e->httpstop,        f_http_stop);
	if (e->httpstartstop)   SUB (r, __cf_noaa_unpack_httpstartstop_m,   e->httpstartstop,   f_http_start_stop);
	if (e->logmessage)      SUB (r, __cf_noaa_unpack_logmessage_m,      e->logmessage,      f_log_message);
	if (e->valuemetric)     SUB (r, __cf_noaa_unpack_valuemetric_m,     e->valuemetric,     f_value_metric);
	if (e->counterevent)    SUB (r, __cf_noaa_unpack_counterevent_m,    e->counterevent,    f_counter_event);
	if (e->error)           SUB (r, __cf_noaa_unpack_error_m,           e->error,           f_error);
	if (e->containermetric) SUB (r, __cf_noaa_unpack_containermetric_m, e->containermetric, f_container_metric);

	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_envelope (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("envelope",
				 (unpacker) events__envelope__unpack,
				 (release)  events__envelope__free_unpacked,
				 (convert)  __cf_noaa_envelope_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_envelope_m (Tcl_Interp* interp, Events__Envelope* e)
    {
	return __cf_noaa_unpack_m ("envelope",
				   (convert)  __cf_noaa_envelope_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc ::cf::noaa::envelope::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP (__cf_noaa_unpack_envelope (interp, length, data));
}

# # ## ### ##### ######## #############
