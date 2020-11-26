@lazyglobal off.

function open_terminal {
    parameter vessel is ship.

    // get kos processor part
    //local p_root is vessel:rootpart.

    // open the terminal
    //p_root:getmodule("kosprocessor"):doaction("open terminal", true).
    core:doaction("open terminal", true).

    set terminal:visualbeep to true.
    
    clearscreen.
    print "/// " + vessel:name:toupper + " \\\".
}

function close_terminal {
    parameter vessel is ship.

    // get kos processor part
    local p_root is vessel:rootpart.

    // close the terminal
    p_root:getmodule("kosprocessor"):doaction("close terminal", true).
}

function wait_for_launch_approval {
    parameter vessel is ship.
    local gui is gui(200).

    local label is gui:addlabel(vessel:name).
    set label:style:align to "center".
    set label:style:hstretch to true.

    local ok is gui:addbutton("launch":toupper).

    gui:show().

    local isdone is false.

    function launchapproval_given {
        set isdone to true.
    }

    set ok:onclick to launchapproval_given@.

    wait until isdone.
    gui:hide().
}

function wait_until_kill_rotation {
    parameter vessel is ship.
    parameter factor is 0.075.

    local interval is time:seconds.
    until (time:seconds - interval) > 5 {
        local vector is vessel:facing:vector.
        //print round(vectorangle(vector, vessel:facing:vector), 3).
        if vectorangle(vector, vessel:facing:vector) > factor {
            set interval to time:seconds.
        }
        wait 1.
    }

}

function wait_until_prograde_orientation {
    parameter vessel is ship.
    parameter factor is 0.75.

    local interval is time:seconds.
    until (time:seconds - interval) > 5 {
        if vectorangle(vessel:facing:forevector, vessel:prograde:vector) > factor {
            set interval to time:seconds.
        }
        wait 0.
    }
}

function wait_until_retrograde_orientation {
    parameter vessel is ship.
    parameter factor is 0.75.
    
    local interval is time:seconds.
    until (time:seconds - interval) > 5 {
        if vectorangle(vessel:facing:forevector, vessel:retrograde:vector) > factor {
            set interval to time:seconds.
        }
        wait 0.
    }
}

function print_angles {
    parameter vessel is ship.

    clearscreen.
    
    print "ship".
    print "x angle (pitch): " + round(vessel:facing:pitch).
    print "y angle (roll):  " + round(vessel:facing:roll).
    print "z angle (yaw):   " + round(vessel:facing:yaw).
    print "".
    print "prograde".
    print "x angle (pitch): " + round(vessel:prograde:pitch).
    print "y angle (roll):  " + round(vessel:prograde:roll).
    print "z angle (yaw):   " + round(vessel:prograde:yaw).
    print "".
    print "retrograde".
    print "x angle (pitch): " + round(vessel:retrograde:pitch).
    print "y angle (roll):  " + round(vessel:retrograde:roll).
    print "z angle (yaw):   " + round(vessel:retrograde:yaw).
}
