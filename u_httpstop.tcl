# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
## cf::noaa C level -- Unpack -- HTTPSTOP - format/http.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/http.pb-c.h"

    Tcl_Obj*
    __cf_noaa_httpstop_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__HttpStop* e)
    {
	SUB (r, __cf_noaa_unpack_uuid_m, e->requestid, f_request_id);

	if (e->applicationid) {
	    SUB (r, __cf_noaa_unpack_uuid_m, e->applicationid, f_application_id);
	}

	Tcl_DictObjPut (interp, r, DSF (f_timestamp),      Tcl_NewWideIntObj (e->timestamp));
	Tcl_DictObjPut (interp, r, DSF (f_uri),            Tcl_NewStringObj (e->uri, -1));
	Tcl_DictObjPut (interp, r, DSF (f_peer_type),      http_peer_type_decode (interp, e->peertype));
	Tcl_DictObjPut (interp, r, DSF (f_status_code),    Tcl_NewIntObj (e->statuscode));
	Tcl_DictObjPut (interp, r, DSF (f_content_length), Tcl_NewWideIntObj (e->contentlength));

	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_httpstop (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("httpstop",
				 (unpacker) events__http_stop__unpack,
				 (release)  events__http_stop__free_unpacked,
				 (convert)  __cf_noaa_httpstop_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_httpstop_m (Tcl_Interp* interp, Events__HttpStop* e)
    {
	return __cf_noaa_unpack_m ("httpstop",
				   (convert)  __cf_noaa_httpstop_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::httpstop::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP(__cf_noaa_unpack_httpstop (interp, length, data));
}

# # ## ### ##### ######## #############
