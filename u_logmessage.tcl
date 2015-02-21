# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level -- Unpack -- LogMessage

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    Tcl_Obj*
    __cf_noaa_logmessage_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__LogMessage* e)
    {
	/* Required fields */
	Tcl_DictObjPut (interp, r, DSF (f_message),      Tcl_NewByteArrayObj     (e->message.data, e->message.len));
	Tcl_DictObjPut (interp, r, DSF (f_message_type), log_message_type_decode (interp, e->message_type));
	Tcl_DictObjPut (interp, r, DSF (f_timestamp),    Tcl_NewWideIntObj       (e->timestamp));

	/* Optional fields. All strings. */
	if (e->app_id)          Tcl_DictObjPut (interp, r, DSF (f_app_id),          Tcl_NewStringObj (e->app_id,          -1));
	if (e->source_type)     Tcl_DictObjPut (interp, r, DSF (f_source_type),     Tcl_NewStringObj (e->source_type,     -1));
	if (e->source_instance) Tcl_DictObjPut (interp, r, DSF (f_source_instance), Tcl_NewStringObj (e->source_instance, -1));

	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_logmessage (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("logmessage",
				 (unpacker) events__log_message__unpack,
				 (release)  events__log_message__free_unpacked,
				 (convert)  __cf_noaa_logmessage_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_logmessage_m (Tcl_Interp* interp, Events__LogMessage* e)
    {
	return __cf_noaa_unpack_m ("logmessage",
				   (convert)  __cf_noaa_logmessage_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::logmessage::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP(__cf_noaa_unpack_logmessage (interp, length, data));
}

# # ## ### ##### ######## #############
