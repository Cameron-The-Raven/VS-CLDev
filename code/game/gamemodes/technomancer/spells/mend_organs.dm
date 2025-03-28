/datum/technomancer/spell/mend_organs
	name = "Mend Internals"
	desc = "Greatly heals the target's wounds, both external and internal.  Restores internal organs to functioning states, even if \
	robotic, reforms bones, patches internal bleeding, and restores missing blood."
	spell_power_desc = "Healing amount increased."
	cost = 100
	obj_path = /obj/item/spell/mend_organs
	ability_icon_state = "tech_mendwounds"
	category = SUPPORT_SPELLS

/obj/item/spell/mend_organs
	name = "great mend wounds"
	desc = "A walking medbay is now you!"
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_BIOMED
	light_color = "#FF5C5C"

/obj/item/spell/mend_organs/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		var/heal_power = calculate_spell_power(40)
		L.adjustBruteLoss(-heal_power)
		L.adjustFireLoss(-heal_power)
		user.adjust_instability(5)
		L.adjust_instability(5)

		if(ishuman(hit_atom))
			var/mob/living/carbon/human/H = hit_atom

			user.adjust_instability(5)
			L.adjust_instability(5)

			for(var/obj/item/organ/O in H.internal_organs)
				if(O.damage > 0) // Fix internal damage
					O.damage = max(O.damage - (heal_power / 2), 0)
				if(O.damage <= 5 && O.organ_tag == O_EYES) // Fix eyes
					H.sdisabilities &= ~BLIND

			for(var/obj/item/organ/external/O in H.organs) // Fix limbs
				if(!O.robotic < ORGAN_ROBOT) // No robot parts for this.
					continue
				O.heal_damage(0, heal_power / 4, internal = 1, robo_repair = 0)

			for(var/obj/item/organ/E in H.bad_external_organs) // Fix bones
				var/obj/item/organ/external/affected = E
				if((affected.damage < affected.min_broken_damage * CONFIG_GET(number/organ_health_multiplier)) && (affected.status & ORGAN_BROKEN))
					affected.status &= ~ORGAN_BROKEN

				for(var/datum/wound/W in affected.wounds) // Fix IB
					if(istype(W, /datum/wound/internal_bleeding))
						affected.wounds -= W
						affected.update_damages()

			H.restore_blood() // Fix bloodloss
		qdel(src)
