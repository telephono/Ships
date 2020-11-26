function launch {
    parameter vessel is ship.

    print "...launch".

    // get launch pad part
    local p_launchpad is vessel:partsnamed("am.mlp.redstonelaunchstand")[0].

    // get booster  parts
    local booster_list is vessel:partsnamed("tinytim").

    // get srb parts
    local castor_list is vessel:partsnamed("roe-castor1").

    rcs off.
    sas off.

    for p_booster in booster_list {
        p_booster:getmodule("moduleenginesrf"):doaction("activate engine", true).
    }

    for p_booster in booster_list {
        wait until p_booster:getmodule("moduleenginesrf"):getfield("thrust") > 1.
    }

    // release clamp
    p_launchpad:getmodule("launchclamp"):doaction("release clamp", true).

    // wait for flame-out
    //for pbooster in boosterlist {
    //    wait until pbooster:getmodule("moduleenginesrf"):getfield("status") = "flame-out!".
    //}
    wait 0.5.

    // start srbs
    for p_castor in castor_list {
        p_castor:getmodule("moduleenginesrf"):doaction("activate engine", true).
    }

    for p_castor in castor_list {
        wait until p_castor:getmodule("moduleenginesrf"):getfield("thrust") > 1.
    }
}
