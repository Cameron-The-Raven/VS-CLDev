/datum/artifact_effect
	var/name = "unknown"
	var/effect = EFFECT_TOUCH //This is simply if the effect occurs on touch, in an aura, or a pulse AOE. Horribly named variable.
	var/effectrange = 4 //How far the effect will hit something.
	var/trigger = TRIGGER_TOUCH //This decides how the artifact is actually activated. Ex: Splashing water on it.
	var/datum/component/artifact_master/master //This code is handled in effect_master.dm
	var/activated = 0
	var/chargelevel = 1
	var/chargelevelmax = 10
	var/artifact_id = ""
	var/effect_type = 0 //This is what the artifact does. This is used to generating a description when inspected.

	var/req_type = /atom/movable

	var/image/active_effect
	var/effect_icon = 'icons/effects/effects.dmi'
	var/effect_state = "sparkles"
	var/effect_color = "#ffffff"

	// The last time the effect was toggled.
	var/last_activation = 0

/datum/artifact_effect/Destroy()
	if(master)
		master = null
	..()

/datum/artifact_effect/proc/get_master_holder()	// Return the effectmaster's holder, if it is set to an effectmaster. Otherwise, master is the target object.
	if(istype(master))
		return master.holder
	else
		return master

/datum/artifact_effect/New(var/datum/component/artifact_master/newmaster)
	..()

	master = newmaster
	effect = rand(0, MAX_EFFECT)
	trigger = rand(0, MAX_TRIGGER)

	if(effect_icon && effect_state)
		if(effect_state == "sparkles")
			effect_state = "sparkles_[rand(1,4)]"
		active_effect = image(effect_icon, effect_state)
		active_effect.color = effect_color

	//this will be replaced by the excavation code later, but it's here just in case
	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

	//random charge time and distance
	switch(pick(100;1, 50;2, 25;3))
		if(1)
			//short range, short charge time
			chargelevelmax = rand(3, 20)
			effectrange = rand(1, 3)
		if(2)
			//medium range, medium charge time
			chargelevelmax = rand(15, 40)
			effectrange = rand(5, 15)
		if(3)
			//large range, long charge time
			chargelevelmax = rand(20, 120)
			effectrange = rand(20, 100) //VOREStation Edit - Map size.

/datum/artifact_effect/proc/ToggleActivate(var/reveal_toggle = 1)
	//so that other stuff happens first
	set waitfor = FALSE

	var/atom/target = get_master_holder()

	if(world.time - last_activation > 1 SECOND)
		last_activation = world.time
		if(activated)
			activated = 0
		else
			activated = 1
		if(reveal_toggle && target)
			if(!isliving(target))
				target.update_icon()
			var/display_msg
			if(activated)
				display_msg = pick("momentarily glows brightly!","distorts slightly for a moment!","flickers slightly!","vibrates!","shimmers slightly for a moment!")
			else
				display_msg = pick("grows dull!","fades in intensity!","suddenly becomes very still!","suddenly becomes very quiet!")

			if(active_effect)
				if(activated)
					target.underlays.Add(active_effect)
				else
					target.underlays.Remove(active_effect)

			var/atom/toplevelholder = target
			while(!istype(toplevelholder.loc, /turf))
				toplevelholder = toplevelholder.loc
			toplevelholder.visible_message("<font color='red'>\icon[toplevelholder][bicon(toplevelholder)] [toplevelholder] [display_msg]</font>")

/datum/artifact_effect/proc/DoEffectTouch(var/mob/user)
/datum/artifact_effect/proc/DoEffectAura(var/atom/holder)
/datum/artifact_effect/proc/DoEffectPulse(var/atom/holder)
/datum/artifact_effect/proc/UpdateMove()

/datum/artifact_effect/process()
	if(chargelevel < chargelevelmax)
		chargelevel++

	if(activated)
		if(effect == EFFECT_AURA)
			DoEffectAura()
		else if(effect == EFFECT_PULSE && chargelevel >= chargelevelmax)
			chargelevel = 0
			DoEffectPulse()

/datum/artifact_effect/proc/getDescription()
//This simply gives a fluff description. It has no bearing on what the artifact actually does.
//Sometimes it doesn't make much sense. Heat generating artifacts can be organic, bluespace, or synth.
//This is slated to be reworked and give actual, meaningful descriptions
//That way you know if the healing artifact is actually /just/ a healing artifact and can throw it in med or if it's a ticking time bomb with a a 100 tile range EMP.
//Maybe check the artifact_effect.name and give it a description based on that?
	. = "<b>"
	switch(effect_type)
		if(EFFECT_ENERGY)
			. += "Concentrated energy emissions"
		if(EFFECT_PSIONIC)
			. += "Intermittent psionic wavefront"
		if(EFFECT_ELECTRO)
			. += "Electromagnetic energy"
		if(EFFECT_PARTICLE)
			. += "High frequency particles"
		if(EFFECT_ORGANIC)
			. += "Organically reactive exotic particles"
		if(EFFECT_BLUESPACE)
			. += "Interdimensional/bluespace? phasing"
		if(EFFECT_SYNTH)
			. += "Atomic synthesis"
		else
			. += "Low level energy emissions"

	. += "</b> have been detected <b>"

	switch(effect)
		if(EFFECT_TOUCH)
			. += "interspersed throughout substructure and shell."
		if(EFFECT_AURA)
			. += "emitting in an ambient energy field."
		if(EFFECT_PULSE)
			. += "emitting in periodic bursts."
		else
			. += "emitting in an unknown way."

	. += "</b>"

	switch(trigger)
		if(TRIGGER_TOUCH) //This one should be self explanatory.
			. += " Activation index involves <b>physical interaction</b> or <b>chemical interaction<b> with artifact surface. Water, Acid, Phoron, and toxic substances are potential chemical triggers."
		if(TRIGGER_WATER, TRIGGER_ACID, TRIGGER_VOLATILE, TRIGGER_TOXIN) //No xenoarch would know how to activate these without code digging.
			. += " Activation index involves <b>chemical interaction<b> with artifact surface. Water, Acid, Phoron, and toxic substances are potential triggers."
		if(TRIGGER_FORCE, TRIGGER_ENERGY) //Did you know multitools can activate energy artifacts?
			. += " Activation index involves <b>forceful or energetic interaction</b> with artifact surface. Potential triggers are a multitool or a strong object."
		if(TRIGGER_HEAT, TRIGGER_COLD) //Heat is easy to activate. Smack it with a welder. Cold? Have to cool the area.
			. += " Activation index involves <b>precise temperature conditions</b>. Heating/Cooling the atmosphere or using a welder are potential triggers."
		if(TRIGGER_PHORON, TRIGGER_OXY, TRIGGER_CO2, TRIGGER_NITRO) //Due to atmos code, these are arguably the hardest to activate.
			. += " Activation index involves <b>precise local atmospheric conditions</b>. Phoron, Oxygen, Carbon Dioxide, and Nitrous Oxide are potential triggers."
		else
			. += " Unable to determine any data about activation trigger."

//returns 0..1, with 1 being no protection and 0 being fully protected
/proc/GetAnomalySusceptibility(var/mob/living/carbon/human/H)
	if(!istype(H))
		return 1
	var/area/A = get_area(H)
	if(A.forbid_events)
		return 0
	var/protected = 0

	//anomaly suits give best protection, but excavation suits are almost as good
	if(istype(H.back,/obj/item/weapon/rig/hazmat))
		var/obj/item/weapon/rig/hazmat/rig = H.back
		if(rig.suit_is_deployed() && !rig.offline)
			protected += 1

	if(istype(H.wear_suit,/obj/item/clothing/suit/bio_suit/anomaly))
		protected += 0.6
	else if(istype(H.wear_suit,/obj/item/clothing/suit/space/anomaly))
		protected += 0.5

	if(istype(H.head,/obj/item/clothing/head/bio_hood/anomaly))
		protected += 0.3
	else if(istype(H.head,/obj/item/clothing/head/helmet/space/anomaly))
		protected += 0.2

	//latex gloves and science goggles also give a bit of bonus protection
	if(istype(H.gloves,/obj/item/clothing/gloves/sterile))
		protected += 0.1

	if(istype(H.glasses,/obj/item/clothing/glasses/science))
		protected += 0.1

	return 1 - protected
