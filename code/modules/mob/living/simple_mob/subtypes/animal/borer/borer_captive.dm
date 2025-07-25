// Straight move from the old location, with the paths corrected.

/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"
	universal_understand = 1

/mob/living/captive_brain/say(var/message, var/datum/language/speaking = null, var/whispering = 0)

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, span_red("You cannot speak in IC (muted)."))
			return

	if(istype(src.loc, /mob/living/simple_mob/animal/borer))

		message = sanitize(message)
		if (!message)
			return
		log_say(message,src)
		if (stat == 2)
			return say_dead(message)

		var/mob/living/simple_mob/animal/borer/B = src.loc
		to_chat(src, "You whisper silently, \"[message]\"")
		to_chat(B.host, "The captive mind of [src] whispers, \"[message]\"")

		for (var/mob/M in GLOB.player_list)
			if (isnewplayer(M))
				continue
			else if(M.stat == DEAD && M.client?.prefs?.read_preference(/datum/preference/toggle/ghost_ears))
				to_chat(M, "The captive mind of [src] whispers, \"[message]\"")

/mob/living/captive_brain/me_verb(message as text)
	to_chat(src, span_danger("You cannot emote as a captive mind."))
	return

/mob/living/captive_brain/emote(var/message)
	to_chat(src, span_danger("You cannot emote as a captive mind."))
	return

/mob/living/captive_brain/process_resist()
	//Resisting control by an alien mind.
	if(istype(src.loc, /mob/living/simple_mob/animal/borer))
		var/mob/living/simple_mob/animal/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		to_chat(H, span_danger("You begin doggedly resisting the parasite's control (this will take approximately sixty seconds)."))
		to_chat(B.host, span_danger("You feel the captive mind of [src] begin to resist your control."))

		spawn(rand(200,250)+B.host.brainloss)
			if(!B || !B.controlling) return

			B.host.adjustBrainLoss(rand(0.1,0.5))
			to_chat(H, span_danger("With an immense exertion of will, you regain control of your body!"))
			to_chat(B.host, span_danger("You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you."))
			B.detatch()
		remove_verb(src, /mob/living/carbon/proc/release_control)
		remove_verb(src, /mob/living/carbon/proc/punish_host)
		remove_verb(src, /mob/living/carbon/proc/spawn_larvae)

		return

	..()
