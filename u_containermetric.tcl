# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa C level -- Unpack -- CONTAINERMETRIC - format/metric.proto

# # ## ### ##### ######## #############
## message   = ByteArray holding the wire data of the message
## result    = Dict

# Core/workhorse function.
critcl::ccode {
    #include "coder/metric.pb-c.h"

    Tcl_Obj*
    __cf_noaa_containermetric_convert (Tcl_Interp* interp, Tcl_Obj* r, Events__ContainerMetric* e)
    {
	/* Required fields */
	Tcl_DictObjPut (interp, r, DSF (f_application_id), Tcl_NewStringObj  (e->applicationid, -1));
	Tcl_DictObjPut (interp, r, DSF (f_instance_index), Tcl_NewIntObj     (e->instanceindex));
	Tcl_DictObjPut (interp, r, DSF (f_cpu_percentage), Tcl_NewDoubleObj  (e->cpupercentage));
	Tcl_DictObjPut (interp, r, DSF (f_memory_bytes),   Tcl_NewWideIntObj (e->memorybytes));
	Tcl_DictObjPut (interp, r, DSF (f_disk_bytes),     Tcl_NewWideIntObj (e->diskbytes));
	return r;
    }

    Tcl_Obj*
    __cf_noaa_unpack_containermetric (Tcl_Interp* interp, int length, unsigned char* data)
    {
	return __cf_noaa_unpack ("containermetric",
				 (unpacker) events__container_metric__unpack,
				 (release)  events__container_metric__free_unpacked,
				 (convert)  __cf_noaa_containermetric_convert,
				 interp, length, data);
    }

    Tcl_Obj*
    __cf_noaa_unpack_containermetric_m (Tcl_Interp* interp, Events__ContainerMetric* e)
    {
	return __cf_noaa_unpack_m ("containermetric",
				   (convert)  __cf_noaa_containermetric_convert,
				   interp, (ProtobufCMessage*) e);
    }
}

critcl::cproc cf::noaa::containermetric::unpack {
    Tcl_Interp* interp
    Tcl_Obj*    message
} Tcl_Obj* {
    int              length;
    unsigned char*   data = Tcl_GetByteArrayFromObj (message, &length);

    BUMP (__cf_noaa_unpack_containermetric (interp, length, data));
}

# # ## ### ##### ######## #############
