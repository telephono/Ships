@lazyglobal off.

runoncepath("0:/lib_core").

function mj_orbit_prograde {
    parameter vessel is ship.

    //print "......mechjeb orbit prograde".

    // get capsule part
    local p_cm is vessel:partsnamed("roc-mercurycmbdb")[0].

    rcs on.

    // orient capsule prograde
    p_cm:getmodule("mechjebcore"):doaction("orbit prograde", true).

    wait_until_prograde_orientation(vessel).

    p_cm:getmodule("mechjebcore"):doaction("deactivate smartacs", true).
    rcs off.
}

function mj_orbit_retrograde {
    parameter vessel is ship.

    //print "......mechjeb orbit retrograde".

    // get capsule part
    local p_cm is vessel:partsnamed("roc-mercurycmbdb")[0].

    rcs on.

    // orient capsule retrograde
    p_cm:getmodule("mechjebcore"):doaction("orbit retrograde", true).

    wait_until_retrograde_orientation(vessel).

    p_cm:getmodule("mechjebcore"):doaction("deactivate smartacs", true).
    rcs off.
}

function mj_orbit_killrotation {
    parameter vessel is ship.

    //print "......mechjeb orbit kill rotation".

    // get capsule part
    local p_cm is vessel:partsnamed("roc-mercurycmbdb")[0].

    rcs on.

    // kill rotation
    p_cm:getmodule("mechjebcore"):doaction("orbit kill rotation", true).
    
    wait_until_kill_rotation(vessel).

    p_cm:getmodule("mechjebcore"):doaction("deactivate smartacs", true).
    rcs off.
}

function launch_abort {
    parameter vessel is ship.

    hudtext("abort! abort! abort!", 600, 2, 20, red, true).

    // get les part
    local p_les is vessel:partsnamed("roc-mercurylesbdb")[0].

    // get stack decoupler part
    local p_decoupler is vessel:partsnamed("roc-mercurydecouplerbdb")[0].

    // get retropack part
    local p_retropack is vessel:partsnamed("roc-mercuryretropackbdb")[0].

    // activate les engine
    p_les:getmodule("moduleenginesrf"):doaction("activate engine", true).

    // decouple from stack
    p_decoupler:getmodule("moduledecouple"):doaction("decouple", true).

    // disconnect umbilical
    p_retropack:getmodule("moduleanimategeneric"):doaction("toggle umbilical", true).

    // decouple retropack
    p_retropack:getmodule("moduledecouple"):doaction("decouple", true).

    wait until p_les:getmodule("moduleenginesrf"):getfield("thrust") > 1.
    wait until p_les:getmodule("moduleenginesrf"):getfield("status") = "flame-out!".
    
    if vessel:bounds:bottomalt > 7000 {
        wait until eta:apoapsis < 30.
    }

    // decouple les
    p_les:getmodule("moduledecouple"):doaction("decouple", true).

    if vessel:bounds:bottomalt > 7000 {
        wait until vessel:verticalspeed < 0.
        // deploy fixme: reentry helper thing...
        brakes on.
    }
    
    reentry_and_landing(vessel).
    after_landing(vessel).
}

// launch escape system tower jettison
function jettison_les {
    parameter vessel is ship.

    print "...jettison les".

    // get part
    local p_les is vessel:partsnamed("roc-mercurylesbdb")[0].

    // activate engine
    p_les:getmodule("moduleenginesrf"):doaction("activate engine", true).

    // decouple
    p_les:getmodule("moduledecouple"):doaction("decouple", true).

}

function capsule_separation {
    parameter vessel is ship.

    print "...capsule separation".

    // get decoupler part
    local p_decoupler is vessel:partsnamed("roc-mercurydecouplerbdb")[0].

    // get kick motor parts
    local kickmotor_list is vessel:partsnamed("roc-mercuryposigradebdb").

    // decouple capsule
    p_decoupler:getmodule("moduledecouple"):doaction("decouple", true).

    // activate kick motors
    for p_kickmotor in kickmotor_list {
        p_kickmotor:getmodule("moduleenginesrf"):doaction("activate engine", true).
    }

    for p_kickmotor in kickmotor_list {
        wait until p_kickmotor:getmodule("moduleenginesrf"):getfield("thrust") > 1.
    }

    for p_kickmotor in kickmotor_list {
        wait until p_kickmotor:getmodule("moduleenginesrf"):getfield("status") = "flame-out!".
    }
}

function begin_orbit_operations {
    parameter vessel is ship.

    print "...begin orbit operations".

    // get capsule part
    local p_cm is vessel:partsnamed("roc-mercurycmbdb")[0].

    mj_orbit_killrotation(vessel).

    // extend periscope
    p_cm:getmodule("moduleanimategeneric"):doaction("toggle periscope", true).

    // deploy experiment
    for module in vessel:modulesnamed("moduleanimategeneric") {
        if module:hasaction("toggle cover") {
            module:doaction("toggle cover", true).
        }
    } 
    wait 3.
}

function end_orbit_operations {
    parameter vessel is ship.

    print "...end orbit operations".

    // get capsule part
    local p_cm is vessel:partsnamed("roc-mercurycmbdb")[0].

    // retract periscope
    p_cm:getmodule("moduleanimategeneric"):doaction("toggle periscope", true).

    // retrieve experiment
    for module in vessel:modulesnamed("moduleanimategeneric") {
        if module:hasaction("toggle cover") {
            module:doaction("toggle cover", true).
        }
    }
    wait 3.
}

function fire_retropack {
    parameter vessel is ship.

    print "...fire retropack".

    // get retropack engine parts
    local retropackmotor_list is vessel:partsnamed("roc-mercuryretrobdb").

    mj_orbit_retrograde(vessel).

    // jettison shrouds
    for p_retro in retropackmotor_list {
        p_retro:getmodule("modulejettison"):doaction("jettison shroud", true).
    }
    wait 3.

    for p_retromotor in retropackmotor_list {
        p_retromotor:getmodule("moduleenginesrf"):doaction("activate engine", true).
        wait 1.
    }

    for p_retromotor in retropackmotor_list {
        wait until p_retromotor:getmodule("moduleenginesrf"):getfield("thrust") > 1.
    }

    for p_retromotor in retropackmotor_list {
        wait until p_retromotor:getmodule("moduleenginesrf"):getfield("status") = "flame-out!".
    }
}

function jettison_retropack {
    parameter vessel is ship.

    print "...jettison retropack".

    // get retropack part
    local p_retropack is vessel:partsnamed("roc-mercuryretropackbdb")[0].

    mj_orbit_retrograde(vessel).

    // disconnect umbilical
    p_retropack:getmodule("moduleanimategeneric"):doaction("toggle umbilical", true).
    wait 5.

    // decouple
    p_retropack:getmodule("moduledecouple"):doaction("decouple", true).
    wait 3.
}

function reentry_and_landing {
    parameter vessel is ship.

    print "...reentry and landing".

    // get destabilizing flap part
    local p_flap is vessel:partsnamed("roc-mercuryairbrakebdb")[0].

    // get drag chute part
    local p_dragchute is vessel:partsnamed("roc-mercurynosecapbdb")[0].
    // todo: get deployment altitude

    // get landing module part
    local p_mainchute is vessel:partsnamed("roc-mercuryrcsbdb")[0].
    // todo: get deployment altitude

    // get heatshield part
    local p_heatshield is vessel:partsnamed("roc-mercuryhs")[0].

    // deploy destabilizing flap
    p_flap:getmodule("moduleaerosurface"):doaction("extend", true).

    // arm drag chute
    wait until ship:bounds:bottomalt < 30000.
    p_dragchute:getmodule("realchutemodule"):doaction("arm parachute", true).

    // decouple drag chute
    wait until vessel:bounds:bottomalt < 3000.
    p_mainchute:getmodule("moduledecouple"):doaction("decouple", true).

    // arm main parachute
    p_mainchute:getmodule("realchutemodule"):doaction("arm parachute", true).

    // deploy landing bags
    wait until vessel:bounds:bottomaltradar < 500.
    p_heatshield:getmodule("moduleanimategeneric"):doaction("toggle landing bag", true).

    // todo: deploy landing aids
    wait until vessel:status = "splashed" or vessel:status = "landed".
}

function after_landing {
    parameter vessel is ship.

    print "...after landing".

    // deploy experiment
    for module in vessel:modulesnamed("moduleanimategeneric") {
    if module:hasaction("toggle recovery aids") {
            module:doaction("toggle recovery aids", true).
        }
    }
}
