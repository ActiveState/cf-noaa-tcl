# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level.
# Unmarshalling a log event.
# Result is a Tcl dictionary.

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

critcl::cproc cf::noaa::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);
    Events__LogMessage* e = events__log_message__unpack (NULL, length, data);
    Tcl_Obj* r;

    if (!e) {
	Tcl_AppendResult (interp, "pb unpack failed", 0);
	return 0;
    }

    /* Convert structure to dictionary
     * Note: DictObjPut can only fail if fed a non-dict Tcl_Obj.
     * Given that we start here with NewDictObj() that is not possible.
     */

    r = Tcl_NewDictObj();
    if (!r) {
	events__log_message__free_unpacked (e, NULL);
	Tcl_AppendResult (interp, "result memory allocation failure", 0);
	return 0;
    }

    /* Required fields */

    Tcl_DictObjPut (interp, r, log_field (interp, f_message),      Tcl_NewByteArrayObj     (e->message.data, e->message.len));
    Tcl_DictObjPut (interp, r, log_field (interp, f_message_type), log_message_type_decode (interp, e->message_type));
    Tcl_DictObjPut (interp, r, log_field (interp, f_timestamp ),   Tcl_NewWideIntObj       (e->timestamp));

    /* Optional fields. All strings. */

    if (e->app_id)          Tcl_DictObjPut (interp, r, log_field (interp, f_app_id),          Tcl_NewStringObj (e->app_id,          -1));
    if (e->source_type)     Tcl_DictObjPut (interp, r, log_field (interp, f_source_type),     Tcl_NewStringObj (e->source_type,     -1));
    if (e->source_instance) Tcl_DictObjPut (interp, r, log_field (interp, f_source_instance), Tcl_NewStringObj (e->source_instance, -1));


    /* Release helper structure */
    events__log_message__free_unpacked (e, NULL);

    /* Done, do not forget to bump the ref count */
    Tcl_IncrRefCount (r);
    return r;
}

# # ## ### ##### ######## #############
