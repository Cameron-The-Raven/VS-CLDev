/obj/item/fuel
	name = "Magnetic Storage Cell"
	desc = "Contains highly energized protons or anti-protons in a magnetic field."
	icon = 'icons/obj/machines/antimatter.dmi'
	icon_state = "jar"
	density = FALSE
	anchored = FALSE
	var/fuel = 0
	var/is_antimatter = FALSE

/obj/item/fuel/H
	name = "Hydrogen storage Cell"
	desc = "Contains highly energized hydrogen in a magnetic field."
	fuel = 1e-12		//pico-kilogram

/obj/item/fuel/antiH
	name = "Anti-Hydrogen storage Cell"
	desc = "Contains highly energized anti-hydrogen in a magnetic field."
	fuel = 1e-12		//pico-kilogram
	is_antimatter = TRUE

/obj/item/fuel/attackby(obj/item/fuel/F, mob/user)
	if(!istype(F, /obj/item/fuel))
		return ..()
	if(F.fuel == 0)
		to_chat(user, span_notice("\The [F] is empty."))
		return
	// SAFETY MODE - COMMENT OUT TO ENABLE EXPLOSION AND SABOTAGE
	//if(is_antimatter != F.is_antimatter)
	//	to_chat(user, span_danger("That doesn't seem like a good idea!"))
	//	return
	// SAFETY MODE END
	if(is_antimatter != F.is_antimatter) // Cis-Boom-Baa! and take the whole barnyard with you!
		if(fuel > 0) // what if we are empty?
			F.annihilation(F.fuel + fuel,user)
			qdel(src)
			return
	if(fuel + F.fuel >= 1)
		to_chat(user, span_warning("\The [src] refuses to take in more fuel!"))
		return
	// Transfer fuel
	fuel += F.fuel
	F.fuel = 0
	// If we got this far, the jar didn't explode, so we must of transfer into an empty one, or was the same matter type anyway
	// Yes this is intentional antag gameplay. Transfer fuel out of a matter cell, and load it with antimatter so engineering gets a mean surprise...
	is_antimatter = F.is_antimatter
	F.is_antimatter = FALSE // empty jars can't be antimatter, can they?
	to_chat(user, span_notice("You have add more fuel to \the [src], it now contains [fuel]kg of [is_antimatter ? "anti-" : ""]hydrogen"))
	if(is_antimatter != initial(is_antimatter))
		log_and_message_admins("[src] was sabotaged with [is_antimatter ? "anti-matter" : "matter"].",user)

/obj/item/fuel/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "It's meter reads: [fuel]kg."

/obj/item/fuel/proc/annihilation(var/mass,var/mob/user)
	var/strength = convert2energy(mass)
	if(strength < 773.0)
		var/turf/T = get_turf(src)
		if(strength > (450+T0C))
			explosion(T, 0, 1, 2, 4)
		else
			if(strength > (300+T0C))
				explosion(T, 0, 0, 2, 3)
		qdel(src)
		return
	var/turf/ground_zero = get_turf(loc)
	var/ground_zero_range = round(strength / 387)

	var/sabotaged = (is_antimatter != initial(is_antimatter))
	log_and_message_admins("[src] was detonated. [sabotaged ? "It was sabotaged! Check logs." : ""]",user)

	if(strength > convert2energy(8e-12)) // May god have mercy on your soul
		visible_message(span_huge(span_bolddanger("BANG")),span_huge(span_bolddanger("BANG")), runemessage = "bang")
		var/turf/T = get_turf(src)
		qdel(src)
		explosion(ground_zero, ground_zero_range, ground_zero_range*2, ground_zero_range*3, ground_zero_range*4)
		if(T)
			SSradiation.radiate(T, strength)
			new /obj/effect/bhole(T)
	else
		qdel(src)
		explosion(ground_zero, ground_zero_range, ground_zero_range*2, ground_zero_range*3, ground_zero_range*4)
