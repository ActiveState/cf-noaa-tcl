# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level -- Unpack -- UUID - format/uuid.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/uuid.pb-c.h"

    Tcl_Obj*
    __cf_noaa_uuid_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__UUID* e)
    {
	/* Required fields */
	Tcl_DictObjPut (interp, r, DSF (f_low),  Tcl_NewWideIntObj (e->low));
	Tcl_DictObjPut (interp, r, DSF (f_high), Tcl_NewWideIntObj (e->high));
	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_uuid (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("uuid",
				 (unpacker) events__uuid__unpack,
				 (release)  events__uuid__free_unpacked,
				 (convert)  __cf_noaa_uuid_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_uuid_m (Tcl_Interp* interp, Events__UUID* e)
    {
	return __cf_noaa_unpack_m ("uuid",
				   (convert)  __cf_noaa_uuid_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::uuid::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP(__cf_noaa_unpack_uuid (interp, length, data));
}

# # ## ### ##### ######## #############
