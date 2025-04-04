/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: not_incapacitated_state
 *
 * Checks that the user isn't incapacitated
 **/

GLOBAL_DATUM_INIT(tgui_not_incapacitated_state, /datum/tgui_state/not_incapacitated_state, new)

/**
 * tgui state: not_incapacitated_turf_state
 *
 * Checks that the user isn't incapacitated and that their loc is a turf
 **/

GLOBAL_DATUM_INIT(tgui_not_incapacitated_turf_state, /datum/tgui_state/not_incapacitated_state, new(no_turfs = TRUE))

/datum/tgui_state/not_incapacitated_state
	var/turf_check = FALSE

/datum/tgui_state/not_incapacitated_state/New(loc, no_turfs = FALSE)
	..()
	turf_check = no_turfs

/datum/tgui_state/not_incapacitated_state/can_use_topic(src_object, mob/user)
	if(user.stat)
		return STATUS_CLOSE
	if(user.incapacitated() || (turf_check && !isturf(user.loc)))
		return STATUS_DISABLED
	return STATUS_INTERACTIVE
