@lazyglobal off.

runoncepath("0:/lib_mercury").
runoncepath("0:/lib_mercury_littlejoe").

open_terminal(ship).

on abort {
    launch_abort(ship).
}

wait_for_launch_approval(ship).
launch(ship).

wait until ship:altitude > 40000.
jettison_les(ship).

wait until ship:altitude > 70000.
capsule_separation(ship).

wait 3.
begin_orbit_operations(ship).


wait until ship:verticalspeed < 0.
end_orbit_operations(ship).

jettison_retropack(ship).

wait 3.
reentry_and_landing(ship).

after_landing(ship).

close_terminal(ship).

wait until false.
shutdown.
