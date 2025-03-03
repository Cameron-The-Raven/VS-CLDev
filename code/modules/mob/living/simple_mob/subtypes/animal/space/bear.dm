/mob/living/simple_mob/animal/space/bear
	name = "space bear"
	desc = "A product of Space Russia?"
	tt_desc = "U Ursinae aetherius" //...bearspace? Maybe.
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"

	faction = FACTION_RUSSIAN

	maxHealth = 125
	health = 125

	movement_cooldown = -1

	melee_damage_lower = 15
	melee_damage_upper = 35
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE
	melee_attack_delay = 1 SECOND
	attacktext = list("mauled")

	meat_type = /obj/item/reagent_containers/food/snacks/bearmeat
	meat_amount = 8

	say_list_type = /datum/say_list/bear

	allow_mind_transfer = TRUE

/datum/say_list/bear
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_see = list("stares ferociously", "stomps")
	emote_hear = list("rawrs","grumbles","grawls", "growls", "roars")

// Is it time to be mad?
/mob/living/simple_mob/animal/space/bear/handle_special()
	if((get_AI_stance() in list(STANCE_APPROACH, STANCE_FIGHT)) && !is_AI_busy() && isturf(loc))
		if(health <= (maxHealth * 0.5)) // At half health, and fighting someone currently.
			berserk()

// So players can use it too.
/mob/living/simple_mob/animal/space/bear/verb/berserk()
	set name = "Berserk"
	set desc = "Enrage and become vastly stronger for a period of time, however you will be weaker afterwards."
	set category = "Abilities.Bear"

	add_modifier(/datum/modifier/berserk, 30 SECONDS)
