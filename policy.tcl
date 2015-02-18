# # ## ### ##### ######## #############
## Copyright (c) 2015 ActiveState, Andreas Kupries
#
# cf::noaa Tcl level.

# # ## ### ##### ######## #############
## Conveniences - Ensemble command.

namespace eval ::cf::noaa {
    namespace export pack unpack
    namespace ensemble create
}

namespace eval ::cf {
    namespace export noaa
    namespace ensemble create
}

# # ## ### ##### ######## #############
