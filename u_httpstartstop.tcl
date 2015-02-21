# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
## cf::noaa C level -- Unpack -- HTTPSTARTSTOP - format/http.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/http.pb-c.h"

    Tcl_Obj*
    __cf_noaa_httpstartstop_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__HttpStartStop* e)
    {
	SUB (r, __cf_noaa_unpack_uuid_m, e->requestid, f_request_id);

	if (e->parentrequestid) {
	    SUB (r, __cf_noaa_unpack_uuid_m, e->parentrequestid, f_parent_request_id);
	}

	if (e->applicationid) {
	    SUB (r, __cf_noaa_unpack_uuid_m, e->applicationid, f_application_id);
	}

	Tcl_DictObjPut (interp, r, DSF (f_start_timestamp), Tcl_NewWideIntObj (e->starttimestamp));
	Tcl_DictObjPut (interp, r, DSF (f_stop_timestamp),  Tcl_NewWideIntObj (e->stoptimestamp));
	Tcl_DictObjPut (interp, r, DSF (f_peer_type),       http_peer_type_decode (interp, e->peertype));
	Tcl_DictObjPut (interp, r, DSF (f_method),          http_method_decode    (interp, e->method));
	Tcl_DictObjPut (interp, r, DSF (f_uri),             Tcl_NewStringObj (e->uri,           -1));
	Tcl_DictObjPut (interp, r, DSF (f_remote_address),  Tcl_NewStringObj (e->remoteaddress, -1));
	Tcl_DictObjPut (interp, r, DSF (f_user_agent),      Tcl_NewStringObj (e->useragent,     -1));
	Tcl_DictObjPut (interp, r, DSF (f_status_code),     Tcl_NewIntObj (e->statuscode));
	Tcl_DictObjPut (interp, r, DSF (f_content_length),  Tcl_NewWideIntObj (e->contentlength));

	if (e->has_instanceindex) {
	    Tcl_DictObjPut (interp, r, DSF (f_instance_index), Tcl_NewIntObj (e->instanceindex));
	}

	if (e->instanceid) {
	    Tcl_DictObjPut (interp, r, DSF (f_instance_id), Tcl_NewStringObj (e->instanceid, -1));
	}

	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_httpstartstop (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("httpstartstop",
				 (unpacker) events__http_start_stop__unpack,
				 (release)  events__http_start_stop__free_unpacked,
				 (convert)  __cf_noaa_httpstartstop_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_httpstartstop_m (Tcl_Interp* interp, Events__HttpStartStop* e)
    {
	return __cf_noaa_unpack_m ("httpstartstop",
				   (convert)  __cf_noaa_httpstartstop_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::httpstartstop::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP(__cf_noaa_unpack_httpstartstop (interp, length, data));
}

# # ## ### ##### ######## #############
