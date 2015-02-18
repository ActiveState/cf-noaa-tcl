# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level.
# Common declarations, definition, and code.

# # ## ### ##### ######## #############

critcl::ccode {
    #include "log.h"
}
# void                events__log_message__init                  (Events__LogMessage *message);
# size_t              events__log_message__get_packed_size (const Events__LogMessage *message);
# size_t              events__log_message__pack            (const Events__LogMessage *message, uint8_t *out);
#
# Events__LogMessage* events__log_message__unpack          (ProtobufCAllocator* allocator, size_t len, const uint8_t* data);
# void                events__log_message__free_unpacked         (Events__LogMessage* message, ProtobufCAllocator* allocator);

# Fields
#     required bytes       message;          Bytes of the log message. (Note that it is not required to be a single line.)
#     required MessageType message_type;     Type of the message (OUT or ERR).
#     required int64       timestamp;        UNIX timestamp (in nanoseconds) when the log was written.
#     optional string      app_id;           Application that emitted the message (or to which the application is related).
#     optional string      source_type;      Source of the message. For Cloud Foundry, this can be "APP", "RTR", "DEA", "STG", etc.
#     optional string      source_instance;  Instance that emitted the message.

critcl::emap def log_message_type {
    out EVENTS__LOG_MESSAGE__MESSAGE_TYPE__OUT
    err EVENTS__LOG_MESSAGE__MESSAGE_TYPE__ERR
}

# int      log_message_type_encode (interp, Tcl_Obj* state, int* result)
# Tcl_Obj* log_message_type_decode (interp, int      state)
#
# argtype:    log_message_type
# resulttype: log_message_type

critcl::literals def log_field {
    f_message	       message
    f_message_type     message_type
    f_timestamp	       timestamp
    f_app_id	       app_id
    f_source_type      source_type
    f_source_instance  source_instance
}

# enum     log_field_names
# Tcl_Obj* log_field (interp, id)
