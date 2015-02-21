# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level -- Unpack -- COUNTEREVENT - format/metric.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/metric.pb-c.h"

    Tcl_Obj*
    __cf_noaa_counterevent_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__CounterEvent* e)
    {
	/* Required fields */
	Tcl_DictObjPut (interp, r, DSF (f_name),  Tcl_NewStringObj  (e->name, -1));
	Tcl_DictObjPut (interp, r, DSF (f_delta), Tcl_NewWideIntObj (e->delta));
	Tcl_DictObjPut (interp, r, DSF (f_total), Tcl_NewWideIntObj (e->total));
	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_counterevent (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("counterevent",
				 (unpacker) events__counter_event__unpack,
				 (release)  events__counter_event__free_unpacked,
				 (convert)  __cf_noaa_counterevent_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_counterevent_m (Tcl_Interp* interp, Events__CounterEvent* e)
    {
	return __cf_noaa_unpack_m ("counterevent",
				   (convert)  __cf_noaa_counterevent_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::counterevent::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP (__cf_noaa_unpack_counterevent (interp, length, data));
}

# # ## ### ##### ######## #############
