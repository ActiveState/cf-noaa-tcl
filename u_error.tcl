# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level -- Unpack -- ERROR - format/error.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/error.pb-c.h"

    Tcl_Obj*
    __cf_noaa_error_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__Error* e)
    {
	/* Required fields */
	Tcl_DictObjPut (interp, r, DSF (f_source),  Tcl_NewStringObj (e->source,  -1));
	Tcl_DictObjPut (interp, r, DSF (f_code),    Tcl_NewIntObj    (e->code));
	Tcl_DictObjPut (interp, r, DSF (f_message), Tcl_NewStringObj (e->message, -1));
	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_error (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("error",
				 (unpacker) events__error__unpack,
				 (release)  events__error__free_unpacked,
				 (convert)  __cf_noaa_error_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_error_m (Tcl_Interp* interp, Events__Error* e)
    {
	return __cf_noaa_unpack_m ("error",
				   (convert)  __cf_noaa_error_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::error::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP (__cf_noaa_unpack_error (interp, length, data));
}

# # ## ### ##### ######## #############
