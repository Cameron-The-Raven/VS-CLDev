// Gives various spooky messages to people afraid of a specific thing.
// Doesn't have any real mechanical effect, and is more of an aid to remind someone "You're supposed to be afraid of the dark", and such.

/datum/modifier/trait/phobia
	var/current_fear = 0					// Counter for how 'afraid' the holder is.
	var/max_fear = 100						// Cap for current_fear.
	var/fear_decay_rate = 1					// How much is subtracted every Life() tick when not being spooked by something.

	var/list/zero_fear_up = list()		// Message displayed to holder when current_fear raises above 0.
	var/list/zero_fear_down = list()	// Message displayed when reaching 0.

	var/list/half_fear_up = list()		// Message displayed when current_fear passes half of max_fear.
	var/list/half_fear_down = list()	// Message displayed when current_fear goes below half of max_fear.

	var/list/full_fear_up = list()		// Similar to above, but for the cap.
	var/list/full_fear_down = list()	// Ditto.

/datum/modifier/trait/phobia/tick()
	if(holder.stat)
		return // You got bigger problems.
	var/new_fear = should_fear()
	if(new_fear)
		adjust_fear(new_fear)
	else
		adjust_fear(-fear_decay_rate)

/datum/modifier/trait/phobia/proc/adjust_fear(var/amount)
	var/last_fear = current_fear
	current_fear = between(0, current_fear + amount, max_fear)

	// Handle messages.  safepick() is used so that if no messages are defined, it just does nothing, verses runtiming.
	var/message = null
	if(amount > 0) // Increase in spooks.
		if(current_fear == max_fear && last_fear < max_fear)
			message = safepick(full_fear_up)
		else if(current_fear >= (max_fear / 2) && last_fear < (max_fear / 2))
			message = safepick(half_fear_up)
		else if(current_fear > 0 && last_fear == 0)
			message = safepick(zero_fear_up)
	else if(amount < 0) // Decrease in spooks.
		if(last_fear == max_fear && current_fear < max_fear)
			message = safepick(full_fear_down)
		else if(last_fear >= (max_fear / 2) && current_fear < (max_fear / 2))
			message = safepick(half_fear_down)
		else if(last_fear > 0 && current_fear == 0)
			message = safepick(zero_fear_down)

	if(message)
		to_chat(holder, message)

// Override for specific fears, e.g. seeing blood or spiders.
/datum/modifier/trait/phobia/proc/should_fear()
	return FALSE


// Actual phobia trait implementations below.

/datum/modifier/trait/phobia/haemophobia
	name = "haemophobia"
	desc = "Seeing a bunch of blood isn't really pleasant for most people, but for you, it is very distressing."
	fear_decay_rate = 4

	on_created_text = span_warning("You are terrified of seeing blood.")
	on_expired_text = span_notice("You feel that blood doesn't bother you, at least, as much as it used to.")

	zero_fear_up = list(
		span_warning(span_large("You see some blood nearby...")),
		span_warning(span_large("You try to avoid looking at the blood nearby."))
		)
	zero_fear_down = list(
		span_notice("You feel better now, with no blood in sight."),
		span_notice("At last, the blood is gone."),
		span_notice("Hopefully you won't see anymore blood today.")
		)

	half_fear_up = list(
		span_danger(span_large("You're still near the blood!")),
		span_danger(span_large("So much blood... You can't stand it."))
		)
	half_fear_down = list(
		span_warning("The blood is gone now, but you're still worked up."),
		span_warning("You can't see the blood now, but you're still anxious.")
		)

	full_fear_up = list(
		span_danger(span_huge("The blood is too much!")),
		span_danger(span_huge("There is so much blood here, you need to leave!")),
		span_danger(span_huge("You gotta get away from the blood!"))
		)
	full_fear_down = list(
		span_danger("The blood is gone, but you're still very anxious."),
		span_danger("No more blood... Please.")
		)

/datum/modifier/trait/phobia/haemophobia/check_if_valid()
	if(iscultist(holder)) // Nar-nar can't be having cultists afraid of blood.
		expire()
	else
		..()

/datum/modifier/trait/phobia/haemophobia/should_fear()
	if(holder.blinded)
		return 0 // Can't fear what cannot be seen.

	var/fear_amount = 0
	for(var/atom/thing in view(5, holder)) // It's 5 and not 7 so players have a chance to go away before getting the prompts, and for performance.
		// Blood stains are bad.
		if(istype(thing, /obj/effect/decal/cleanable/blood))
			var/obj/effect/decal/cleanable/blood/B = thing
			// Tracks are special, apparently.
			if(istype(thing, /obj/effect/decal/cleanable/blood/tracks))
				var/obj/effect/decal/cleanable/blood/tracks/T = B
				for(var/datum/fluidtrack/F in T.stack)
					if(F.basecolor != SYNTH_BLOOD_COLOUR)
						fear_amount++
						break
			else
				if(B.basecolor != SYNTH_BLOOD_COLOUR)
					fear_amount++

		// People covered in blood is also bad.
		// Feel free to trim down if its too expensive CPU wise.
		if(isliving(thing))
			var/mob/living/L = thing
			if(L.alpha <= FAKE_INVIS_ALPHA_THRESHOLD) // Can't fear something you can't (easily) see.
				continue

			if(ishuman(thing))
				var/mob/living/carbon/human/H = thing
				var/self_multiplier = H == holder ? 2 : 1
				var/human_blood_fear_amount = 0
				if(!H.gloves && H.bloody_hands && H.hand_blood_color != SYNTH_BLOOD_COLOUR)
					human_blood_fear_amount += 1
				if(!H.shoes && H.feet_blood_color && H.feet_blood_color != SYNTH_BLOOD_COLOUR)
					human_blood_fear_amount += 1

				// List of slots.  Some slots like pockets are omitted due to not being visible, if H isn't the holder.
				var/list/clothing_slots = list(H.back, H.wear_mask, H.l_hand, H.r_hand, H.wear_id, H.glasses, H.gloves, H.head, H.shoes, H.belt, H.wear_suit, H.w_uniform, H.s_store, H.l_ear, H.r_ear)
				if(H == holder)
					clothing_slots += list(H.l_store, H.r_store)

				for(var/obj/item/clothing/C in clothing_slots)
					if(C.forensic_data?.has_blooddna() && C.blood_color && C.blood_color != SYNTH_BLOOD_COLOUR)
						human_blood_fear_amount += 1

				// This is divided, since humans can wear so many items at once.
				human_blood_fear_amount = round( (human_blood_fear_amount * self_multiplier) / 3, 1)
				fear_amount += human_blood_fear_amount

		// Bloody objects are also bad.
		if(istype(thing, /obj))
			var/obj/O = thing
			if(O.forensic_data?.has_blooddna() && O.blood_color && O.blood_color != SYNTH_BLOOD_COLOUR)
				fear_amount++

	return fear_amount


/datum/modifier/trait/phobia/arachnophobe
	name = "arachnophobia"
	desc = "Spiders are quite creepy to most people, however for you, those chitters of pure evil inspire pure dread and fear."
	fear_decay_rate = 1

	on_created_text = span_warning("You are terrified of seeing spiders.")
	on_expired_text = span_notice("You feel that your fear of spiders has gone from 'crippling' to 'nope nope nope', which is still an improvement.")

	zero_fear_up = list(
		span_warning(span_large("You see a spider!")),
		span_warning(span_large("Spider!"))
		)
	zero_fear_down = list(
		span_notice("Those evil spiders are finally gone."),
		span_notice("At last, the chitters are gone."),
		span_notice("The spiders are gone, at last.")
		)

	half_fear_up = list(
		span_danger(span_large("The spiders are gonna eat you!")),
		span_danger(span_large("The spiders are still here!")),
		span_danger(span_large("The spiders will lay eggs inside you if you don't run!")),
		)
	half_fear_down = list(
		span_warning("The spiders are gone... right?"),
		span_warning("You can't see any spiders now, but you're still anxious.")
		)

	full_fear_up = list(
		span_danger(span_huge("The chittering is driving you mad!")),
		span_danger(span_huge("You're gonna be spider-food if you don't run!")),
		span_danger(span_huge("The spiders are gonna feast on your eyes!"))
		)
	full_fear_down = list(
		span_danger("The spiders must surely be hiding somewhere..."),
		span_danger("No more spiders... Please.")
		)

/datum/modifier/trait/phobia/arachnophobe/should_fear()
	if(holder.blinded)
		return 0 // Can't fear what cannot be seen.

	var/fear_amount = 0
	for(var/atom/thing in view(5, holder)) // See haemophobia for why this is 5.
		if(istype(thing, /obj/effect/decal/cleanable/spiderling_remains)) // Dead spiderlings are a bit spooky.
			fear_amount += 1

		if(istype(thing, /obj/effect/spider/spiderling)) // Live spiderlings are also spooky.
			fear_amount += 2

		if(istype(thing, /obj/item/toy/plushie/spider)) // Plushies are spooky so people can be assholes with them.
			fear_amount += 1

		if(istype(thing, /obj/structure/snowman/spider)) //Snow spiders are also spooky so people can be assholes with those too.
			fear_amount += 1

		if(isliving(thing))
			var/mob/living/L = thing
			if(L.alpha <= FAKE_INVIS_ALPHA_THRESHOLD) // Can't fear something you can't (easily) see.
				continue

			if(istype(L, /mob/living/simple_mob/animal/giant_spider)) // Actual giant spiders are the scariest of them all.
				var/mob/living/simple_mob/animal/giant_spider/S = L

				if(S.stat == DEAD) // Dead giant spiders are less scary than alive ones.
					fear_amount += 4
				else
					fear_amount += 8
	return fear_amount


/datum/modifier/trait/phobia/nyctophobe
	name = "nyctophobia"
	desc = "More commonly known as the fear of darkness.  The shadows can hide many dangers, which makes the prospect of going into the depths of Maintenance rather worrisome."
	fear_decay_rate = 5

	on_created_text = span_warning("You are terrified of the dark.")
	on_expired_text = span_notice("You feel that darkness isn't quite as scary anymore.")

	var/fear_threshold = 0.5 // Average lighting needs to be below this to start increasing fear.

	zero_fear_up = list(
		span_warning(span_large("It's so dark here!")),
		span_warning(span_large("It's too dark!"))
		)
	zero_fear_down = list(
		span_notice("You feel calmer, now that you're in the light."),
		span_notice("At last, no more darkness."),
		span_notice("The light makes you feel calmer.")
		)

	half_fear_up = list(
		span_danger(span_large("You need to escape this darkness!")),
		span_danger(span_large("Something might be lurking near you, but you can't see in this darkness.")),
		span_danger(span_large("You need to find a light!")),
		)
	half_fear_down = list(
		span_warning("The darkness is gone, for now..."),
		span_warning("You're not in the dark anymore, but you're still anxious.")
		)

	full_fear_up = list(
		span_danger(span_huge("What was that?")),
		span_danger(span_huge("Something is nearby..."))
		)
	full_fear_down = list(
		span_danger("Light, at last!"),
		span_danger("The darkness is finally gone!")
		)

/datum/modifier/trait/phobia/nyctophobe/should_fear()
	if(holder.blinded)
		return 5 // Unlike most other fears coded here, being blind when afraid of darkness is pretty bad, I imagine.

	if(holder.see_in_dark >= 5)
		return 0 // What darkness?

	var/fear_amount = 0
	var/total_lum = 0
	var/total_tiles = 0
	var/average_lum = null

	for(var/turf/simulated/T in view(5, get_turf(holder))) // See haemophobia for why this is 5.  This uses get_turf() since darkness makes tiles not visible to holder.
		total_lum += T.get_lumcount()
		total_tiles++

	if(total_tiles)
		average_lum = total_lum / total_tiles

	if(average_lum > fear_threshold)
		switch(average_lum)
			if(0.0 to 0.1)
				fear_amount += 5
			if(0.1 to 0.2)
				fear_amount += 4
			if(0.2 to 0.3)
				fear_amount += 3
			if(0.3 to 0.4)
				fear_amount += 2
			if(0.4 to 0.5)
				fear_amount += 1

	var/turf/T = get_turf(holder)
	if(T.get_lumcount() <= LIGHTING_SOFT_THRESHOLD) // Standing in complete darkness.
		fear_amount += 5

	return fear_amount

/datum/modifier/trait/phobia/claustrophobe
	name = "claustrophobia"
	desc = "Small spaces and tight quarters makes you feel distressed.  Unfortunately both are rather common when living in space."
	fear_decay_rate = 2

	var/open_tiles_needed = 15 // Tends to be just right, as maint triggers this but hallways don't.

	on_created_text = span_warning("You are terrified of tight spaces.  Why did you come to space?")
	on_expired_text = span_notice("Small rooms aren't so bad now.")

	zero_fear_up = list(
		span_warning(span_large("This room is too small...")),
		span_warning(span_large("The walls are too close together..."))
		)
	zero_fear_down = list(
		span_notice("You feel calmer, now that you're in a larger room."),
		span_notice("At last, the walls are far apart."),
		span_notice("The relatively open area makes you feel calmer.")
		)

	half_fear_up = list(
		span_danger(span_large("Your surroundings look like they are closing in.")),
		span_danger(span_large("Is the room getting smaller?")),
		span_danger(span_large("You need to get out of here!")),
		)
	half_fear_down = list(
		span_warning("Your surroundings seem to have stopped closing in."),
		span_warning("You're not in a tight space anymore, but you're still anxious.")
		)

	full_fear_up = list(
		span_danger(span_huge("You need to escape!")),
		span_danger(span_huge("There's barely any room to move around!"))
		)
	full_fear_down = list(
		span_danger("The surroundings stop shrinking."),
		span_danger("The walls seem to have stopped.")
		)

/datum/modifier/trait/phobia/claustrophobe/should_fear()
	if(holder.blinded)
		return 0 // No idea if this is accurate.

	if(holder.loc && !isturf(holder.loc)) // Hiding in a locker or inside an exosuit is spooky.
		return 5

	var/fear_amount = 0
	var/open_tiles = 0
	var/radius = 5 // See haemophobia for why this is 5.
	var/max_open_tiles = radius * radius // Potential maximum tiles.  In practice it will be rare for someone to be inside a 5x5 plane.
	for(var/turf/T in view(radius, holder))
		var/open = TRUE
		if(T.density)
			continue
		for(var/atom/movable/AM in T)
			if(AM.density)
				open = FALSE
				break
		if(open)
			open_tiles++

	if(open_tiles < open_tiles_needed)
		var/fear_reduction = abs( (open_tiles / max_open_tiles) - 1) // The smaller the space, the smaller this number is, and fear will build up faster.
		fear_amount = 5 * fear_reduction

	return fear_amount

/datum/modifier/trait/phobia/blennophobe
	name = "blennophobia"
	desc = "Slimes are quite dangerous, but just the aspect of something being slimey is uncomfortable."
	fear_decay_rate = 1

	on_created_text = span_warning("You are disgusted and horrified by slime.")
	on_expired_text = span_notice("You feel more... okay with slime.")

	zero_fear_up = list(
		span_warning(span_large("That's some slime!")),
		span_warning(span_large("There's slime right there!"))
		)
	zero_fear_down = list(
		span_notice("The slime is out of sight and out of mind."),
		span_notice("Clean. No more slime.")
		)

	half_fear_up = list(
		span_danger(span_large("The slimes might strike at any point!")),
		span_danger(span_large("The slime is still there!"))
		)
	half_fear_down = list(
		span_warning("The slime is gone... right?"),
		span_warning("You can't see any slime right now, but you're still anxious.")
		)

	full_fear_up = list(
		span_danger(span_huge("The slime is everywhere!")),
		span_danger(span_huge("You're gonna get absorbed if you don't get out!"))
		)
	full_fear_down = list(
		span_danger("There must be more of that slime somewhere..."),
		span_danger("No more of this slime, please....")
		)

/datum/modifier/trait/phobia/blennophobe/should_fear()
	if(holder.blinded)
		return 0 // Can't fear what cannot be seen.

	var/fear_amount = 0
	for(var/atom/thing in view(5, holder)) // See haemophobia for why this is 5.
		if(istype(thing, /obj/structure/blob)) // blobs are uncomfortable things
			fear_amount += 3

		if(istype(thing, /obj/structure/alien)) // Pretty much anything made by xenos are slimey in some way.
			fear_amount += 1

		if(istype(thing, /obj/effect/alien/weeds)) // Disgusting slimey carpet.
			fear_amount += 1

		if(istype(thing, /obj/item/weed_extract))
			fear_amount += 1

		if(istype(thing, /obj/effect/decal/cleanable/mucus)) // Blennophobia apparently includes mucus, so!
			fear_amount += 2

		if(istype(thing, /obj/item/slime_extract)) // Gooey.
			fear_amount += 1

		if(istype(thing, /obj/item/slime_cube)) // Also gooey, alongside harbinger of bad news.
			fear_amount += 2

		if(istype(thing, /obj/item/organ/internal/brain/slime))
			fear_amount += 2

		if(istype(thing, /obj/item/clothing/head/collectable/slime)) // Some hats are spooky so people can be assholes with them.
			fear_amount += 1

		if(isliving(thing))
			var/mob/living/L = thing
			if(L.alpha <= FAKE_INVIS_ALPHA_THRESHOLD) // Can't fear something you can't (easily) see.
				continue
			if(istype(L, /mob/living/simple_mob/slime)) // An actual predatory specimen!
				var/mob/living/simple_mob/slime/S = L
				if(S.stat == DEAD) // Dead slimes are somewhat less spook.
					fear_amount += 4
				if(istype(S, /mob/living/simple_mob/slime/xenobio))
					var/mob/living/simple_mob/slime/xenobio/X = S
					if(X.is_adult == TRUE) //big boy
						fear_amount += 8
					else
						fear_amount += 6
				else
					fear_amount += 10 // It's huge and feral.

			if(ishuman(L))
				var/mob/living/carbon/human/S = L
				if(istype(S.species, /datum/species/skrell)) //Skrell ARE slimey.
					fear_amount += 1
				if(istype(S.species, /datum/species/shapeshifter/promethean))
					fear_amount += 4

	return fear_amount

/datum/modifier/trait/phobia/trypanophobe
	name = "trypanophobia"
	desc = "Syringes and needles make you very distressed. You really don't want to get sick..."
	fear_decay_rate = 100

	on_created_text = span_warning("You are terrified by needles.")
	on_expired_text = span_notice("You feel better about being near needles..")


	zero_fear_up = list(
		span_warning(span_large("That's a needle!")),
		span_warning(span_large("There's a needle right there!"))
		)
	zero_fear_down = list(
		span_notice("The needle is gone, no need to worry."),
		span_notice("No more needle.")
		)

	half_fear_up = list(
		span_danger(span_large("The needle could get you at any time!")),
		span_danger(span_large("The needle is still there!"))
		)
	half_fear_down = list(
		span_warning("There are no more needles... right?"),
		span_warning("You don't see any more needles... But you can never be sure.")
		)

	full_fear_up = list(
		span_danger(span_huge("The needles are going to pierce you!")),
		span_danger(span_huge("They could get you any second!"))
		)
	full_fear_down = list(
		span_danger("There are more needles around, you can feel it..."),
		span_danger("No more needles, please...")
		)

/datum/modifier/trait/phobia/trypanophobe/should_fear()
	if(holder.blinded)
		return 0 //Cannot feareth what cannot beest seen

	var/fear_amount = 0

	for(var/atom/thing in view(5, holder)) // See haemophobia for why this is 5.

		if(istype(thing, /obj/item/reagent_containers/syringe))
			fear_amount += 4

		if(istype(thing, /obj/machinery/iv_drip))
			var/obj/machinery/iv_drip/I = thing
			if(I.beaker)
				fear_amount += 8
			else
				fear_amount += 6

		if(istype(thing, /obj/item/reagent_containers/hypospray))
			fear_amount += 2 //Needle doesn't look as intimidating.

		if(istype(thing, /obj/item/reagent_containers/hypospray/autoinjector)) //Don't know if I need to define autoinjectors too. Meh.
			fear_amount += 3

		if(istype(thing, /obj/item/rig_module/chem_dispenser))
			fear_amount += 5

		if(istype(thing, /obj/item/storage/box/syringes))
			fear_amount += 2

		if(istype(thing, /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun))
			fear_amount += 8 //Syringe gun for a big ass mech.

		if(istype(thing, /obj/machinery/sleep_console)) //Sleepers got them needles in them.
			fear_amount += 4

		if(istype(thing, /obj/item/implanter))
			fear_amount += 8 //Very big needle.

		if(istype(thing, /obj/item/gun/launcher/syringe))
			fear_amount += 6

		if(isliving(thing))
			var/mob/living/L = thing
			if(L.alpha <= FAKE_INVIS_ALPHA_THRESHOLD) // Can't fear something you can't (easily) see.
				continue
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.l_hand && istype(H.l_hand, /obj/item/reagent_containers/syringe) || H.r_hand && istype(H.r_hand, /obj/item/reagent_containers/syringe))
					fear_amount += 10

				if(H.l_ear && istype(H.l_ear, /obj/item/reagent_containers/syringe) || H.r_ear && istype(H.r_ear, /obj/item/reagent_containers/syringe))
					fear_amount +=10


	return fear_amount


// Note for the below 'phobias' are of the xeno-phobic variety, and are less centered on pure fear as above, and more on a mix of distrust, fear, and disdainfulness.
// As such, they are mechanically different than the fear-based phobias, in that instead of a buildup of fearful messages, it does intermittent messages specific to what holder sees.

// This is the catch-all 'everyone but [my species] is up to no good' trait, as opposed to the other specialized variants.
/datum/modifier/trait/phobia/xenophobia
	name = "xenophobia"
	desc = "The mind of the Alien is unknowable, and as such, their intentions cannot be known.  You always watch the xenos closely, as they most certainly are watching you \
	closely, waiting to strike."

	on_created_text = span_warning("You remain vigilant against the Alien.")
	on_expired_text = span_notice("Aliens aren't so bad after all.")

	var/last_message = null	// world.time we last did a message.
	var/message_cooldown = 1 MINUTE

/datum/modifier/trait/phobia/xenophobia/tick()
	if(holder.stat)
		return // You got bigger problems.
	if(last_message + message_cooldown <= world.time)
		if(intermittent_message())
			last_message = world.time

/datum/modifier/trait/phobia/xenophobia/proc/intermittent_message()
	var/list/xenos = get_xenos()

	if(xenos.len)
		var/chosen_xeno = pick(xenos)
		to_chat(holder, span_warning(span_large("[make_message(chosen_xeno)]")))
		return TRUE
	else
		return FALSE // No xenos in sight, so don't apply the cooldown.

/datum/modifier/trait/phobia/xenophobia/proc/get_xenos()
	return list()


/datum/modifier/trait/phobia/xenophobia/proc/make_message(var/mob/living/L)
	return "Someone forgot to override this output message."


// This is the catch-all 'everyone but [my species] is up to no good' trait, as opposed to the other specialized variants.
/datum/modifier/trait/phobia/xenophobia/generic
	name = "xenophobia"
	desc = "The mind of the Alien is unknowable, and as such, their intentions cannot be known.  You always watch the xenos closely, as they most certainly are watching you \
	closely, waiting to strike."

	on_created_text = span_warning("You remain vigilant against the Alien.")
	on_expired_text = span_notice("Aliens aren't so bad afterall.")

/datum/modifier/trait/phobia/xenophobia/generic/get_xenos()
	var/list/xenos = list()
	if(!ishuman(holder))
		return
	var/mob/living/carbon/human/us = holder
	for(var/mob/living/carbon/human/H in view(5, holder)) // See haemophobia for why this is 5.
		if(!(istype(us.species, H.species) )) // Are they a different species?
			xenos += H
	return xenos

/datum/modifier/trait/phobia/xenophobia/generic/make_message(var/mob/living/carbon/human/H)
	// Do special responses first if possible.
//	if(H.stat == DEAD)
//		return pick( list("Unsurprising to see a weak and inferior [H.species.name] fail to survive.", "If that [H.species.name] were a [holder.species.name], this wouldn't've have happened.") )

	// Generic responses if none of the above apply.
	var/list/generic_responses = list(
		"That [H.species.name] is likely trying to spy on you.",
		"[H.species.name_plural] tend to be ugly, but this one near you is even worse!",
		"[H.species.name] scum.",
		"The [H.species.name] nearby is certainly a spy for Them.",
		"That [H.species.name] smells awful.",
		"Can't trust [H.species.name_plural]."
		)
	return pick(generic_responses)


// *********
// * Human *
// *********

/datum/modifier/trait/phobia/xenophobia/human
	name = "anti-human sentiment"
	desc = "Humans are bound to get us all killed with their reckless use of technology..."

	on_created_text = span_warning("You unfortunately are likely to have to deal with humans today.")
	on_expired_text = span_notice("Humans aren't so bad after all.")

/datum/modifier/trait/phobia/xenophobia/human/get_xenos()
	var/list/humans = list()
	for(var/mob/living/carbon/human/H in view(5, holder)) // See haemophobia for why this is 5.
		if(H == holder)
			continue // No self loathing here.
		if(istype(H.species, /datum/species/human) ) // Are they a human.
			humans += H
	return humans

/datum/modifier/trait/phobia/xenophobia/human/make_message(var/mob/living/carbon/human/H)
	// Do special responses first if possible.

	// Generic responses if none of the above apply.
	var/list/generic_responses = list(
		"Why did you travel to human space?  It's full of them."
		)
	return pick(generic_responses)

// **********
// * Skrell *
// **********

/datum/modifier/trait/phobia/xenophobia/skrell
	name = "anti-skrell sentiment"
	desc = "The Skrell pretend that they are Humanity's enlightened allies, but you can see past that."

	on_created_text = span_warning("Hopefully no Skrell show up today.")
	on_expired_text = span_notice("Skrell aren't so bad after all.")

/datum/modifier/trait/phobia/xenophobia/skrell/get_xenos()
	var/list/skrell = list()
	for(var/mob/living/carbon/human/H in view(5, holder)) // See haemophobia for why this is 5.
		if(H == holder)
			continue // No self loathing here.
		if(istype(H.species, /datum/species/skrell) ) // Are they a squid now?
			skrell += H
	return skrell

/datum/modifier/trait/phobia/xenophobia/skrell/make_message(var/mob/living/carbon/human/H)
	// Do special responses first if possible.

	// Generic responses if none of the above apply.
	var/list/generic_responses = list(
		"WetSkrell was a mistake."
		)
	return pick(generic_responses)
