# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa Tcl level.

# # ## ### ##### ######## #############
## Conveniences - Ensemble command.

::apply {{} {
    foreach m {
	envelope error heartbeat
	httpstart httpstop httpstartstop
	logmessage valuemetric counterevent
	containermetric uuid
    } {
	namespace eval $m {
	    namespace export pack unpack
	    namespace ensemble create
	}
	namespace export $m
    }
    namespace ensemble create
} ::cf::noaa}

namespace eval ::cf {
    namespace export noaa
    namespace ensemble create
}

# # ## ### ##### ######## #############
