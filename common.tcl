# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level.
# Common declarations, definition, and code.

# # ## ### ##### ######## #############

critcl::ccode {
    #include "coder/envelope.pb-c.h"
    /* Note: This indirectly includes all the other headers we need */
}

# # ## ### ##### ######## #############
## Enums

# __ATTENTION__
# The Tcl-level string of the enum (left side)
# match to the Tcl-level field names used by
# the envelope message dictionary.
#
# This makes it trivial to go from the envelope.event-type
# to the sub-dictionary holding the data. Its key is the
# event-type itself.

critcl::emap def envelope_event_type {
    heartbeat        EVENTS__ENVELOPE__EVENT_TYPE__Heartbeat
    http-start       EVENTS__ENVELOPE__EVENT_TYPE__HttpStart
    http-stop        EVENTS__ENVELOPE__EVENT_TYPE__HttpStop
    http-start-stop  EVENTS__ENVELOPE__EVENT_TYPE__HttpStartStop
    log-message      EVENTS__ENVELOPE__EVENT_TYPE__LogMessage
    value-metric     EVENTS__ENVELOPE__EVENT_TYPE__ValueMetric
    counter-event    EVENTS__ENVELOPE__EVENT_TYPE__CounterEvent
    error            EVENTS__ENVELOPE__EVENT_TYPE__Error
    container-metric EVENTS__ENVELOPE__EVENT_TYPE__ContainerMetric
}

# int      envelope_event_type_encode (interp, Tcl_Obj* state, int* result)
# Tcl_Obj* envelope_event_type_decode (interp, int      state)
#
# argtype:    envelope_event_type
# resulttype: envelope_event_type

# # ## ### ##### ######## #############

critcl::emap def http_peer_type {
  client EVENTS__PEER_TYPE__Client
  server EVENTS__PEER_TYPE__Server
}

# int      http_peer_type_encode (interp, Tcl_Obj* state, int* result)
# Tcl_Obj* http_peer_type_decode (interp, int      state)
#
# argtype:    http_peer_type
# resulttype: http_peer_type

# # ## ### ##### ######## #############

critcl::emap def http_method {
    get    EVENTS__METHOD__GET
    post   EVENTS__METHOD__POST
    put    EVENTS__METHOD__PUT
    delete EVENTS__METHOD__DELETE
    head   EVENTS__METHOD__HEAD
}

# int      http_method_encode (interp, Tcl_Obj* state, int* result)
# Tcl_Obj* http_method_decode (interp, int      state)
#
# argtype:    http_method
# resulttype: http_method

# # ## ### ##### ######## #############

critcl::emap def log_message_type {
    out EVENTS__LOG_MESSAGE__MESSAGE_TYPE__OUT
    err EVENTS__LOG_MESSAGE__MESSAGE_TYPE__ERR
}

# int      log_message_type_encode (interp, Tcl_Obj* state, int* result)
# Tcl_Obj* log_message_type_decode (interp, int      state)
#
# argtype:    log_message_type
# resulttype: log_message_type

# # ## ### ##### ######## #############
## Pool for the field names. Aggregated across all message structures.

critcl::literals def dropsonde_field {
    f_app_id                      app_id
    f_application_id              application-id
    f_code                        code
    f_container_metric            container-metric
    f_content_length              content-length  
    f_control_message_identifier  control-message-identifier
    f_counter_event               counter-event
    f_cpu_percentage              cpu-percentage
    f_delta                       delta
    f_disk_bytes                  disk-bytes
    f_error                       error
    f_error_count                 error-count
    f_event_type                  event-type
    f_heartbeat                   heartbeat
    f_http_start                  http-start
    f_http_start_stop             http-start-stop
    f_http_stop                   http-stop
    f_high                        high
    f_instance_id                 instance-id
    f_instance_index              instance-index
    f_log_message                 log-message
    f_low                         low
    f_memory_bytes                memory-bytes
    f_message                     message
    f_message_type                message_type
    f_method                      method
    f_name                        name
    f_origin                      origin
    f_parent_request_id           parent-request-id
    f_peer_type                   peer-type
    f_received_count              received-count
    f_remote_address              remote-address
    f_request_id                  request-id
    f_sent_count                  sent-count
    f_source                      source
    f_source_instance             source_instance
    f_source_type                 source_type
    f_start_timestamp             start-timestamp
    f_status_code                 status-code
    f_stop_timestamp              stop-timestamp
    f_timestamp                   timestamp
    f_total                       total
    f_unit                        unit
    f_uri                         uri
    f_user_agent                  user-agent
    f_value                       value
    f_value_metric                value-metric
}

# enum     dropsonde_field_names
# Tcl_Obj* dropsonde_field (interp, id)

critcl::ccode {
    #define DSF(code) dropsonde_field (interp, (code))
}

critcl::ccode {
    /* Generic unmarshall workhorse wrapper for the common ops.
     * Takes the data and free functions for unpacking, freeing
     * unpacked data, and the main converter.
     */

    typedef ProtobufCMessage* (*unpacker) (ProtobufCAllocator  *allocator,
					   size_t               len,
					   const uint8_t       *data);

    typedef void (*release) (ProtobufCMessage* message,
			     ProtobufCAllocator* allocator);

    typedef Tcl_Obj* (*convert) (Tcl_Interp* interp,
				 Tcl_Obj* r,
				 ProtobufCMessage* message);


    Tcl_Obj*
    __cf_noaa_unpack_m (char* label, convert c,
			Tcl_Interp* interp, ProtobufCMessage* e)
    {
	/* Convert structure to dictionary
	 * Note: DictObjPut can only fail if fed a non-dict Tcl_Obj.
	 * Given that we start here with NewDictObj() that is not possible.
	 */

	Tcl_Obj* res = Tcl_NewDictObj();

	if (res) {
	    /* Run the actual conversion -- res may come back as null! */
	    res = c (interp, res, e);
	} else {
	    Tcl_AppendResult (interp, label, 0);
	    Tcl_AppendResult (interp, ": result memory allocation failure", 0);
	}

	return res;
    }

    Tcl_Obj*
    __cf_noaa_unpack (char* label, unpacker u, release r, convert c,
		      Tcl_Interp* interp, int length, unsigned char* data)
    {
	Tcl_Obj* res;
	ProtobufCMessage* e = u (NULL, length, data);

	if (!e) {
	    Tcl_AppendResult (interp, label, 0);
	    Tcl_AppendResult (interp, ": decode failed", 0);
	    return 0;
	}

	res = __cf_noaa_unpack_m (label, c, interp, e);

	/* Release helper structure */
	r (e, NULL);

	return res;
    }

    #define BUMP(x) { Tcl_Obj* o = (x); Tcl_IncrRefCount (o); return o; }


#define SUB(res, converter, value, fieldcode) \
	{ \
	    Tcl_Obj* _temp = (converter) (interp, (value)); \
	    if (!_temp) { Tcl_DecrRefCount (res) ; return 0; } \
	    Tcl_DictObjPut (interp, (res), DSF (fieldcode), _temp); \
	}

}

# # ## ### ##### ######## #############
return
