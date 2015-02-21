# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level -- Unpack -- VALUEMETRIC - format/metric.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/metric.pb-c.h"

    Tcl_Obj*
    __cf_noaa_valuemetric_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__ValueMetric* e)
    {
	/* Required fields */
	Tcl_DictObjPut (interp, r, DSF (f_name),  Tcl_NewStringObj (e->name, -1));
	Tcl_DictObjPut (interp, r, DSF (f_value), Tcl_NewDoubleObj (e->value));
	Tcl_DictObjPut (interp, r, DSF (f_unit),  Tcl_NewStringObj (e->unit, -1));
	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_valuemetric (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("valuemetric",
				 (unpacker) events__value_metric__unpack,
				 (release)  events__value_metric__free_unpacked,
				 (convert)  __cf_noaa_valuemetric_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_valuemetric_m (Tcl_Interp* interp, Events__ValueMetric* e)
    {
	return __cf_noaa_unpack_m ("valuemetric",
				   (convert)  __cf_noaa_valuemetric_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::valuemetric::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP (__cf_noaa_unpack_valuemetric (interp, length, data));
}

# # ## ### ##### ######## #############
