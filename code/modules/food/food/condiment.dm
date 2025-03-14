
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	flags = OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass_x = 16
	center_of_mass_y = 6
	volume = 50

/obj/item/reagent_containers/food/condiment/attackby(var/obj/item/W as obj, var/mob/user as mob)
	return

/obj/item/reagent_containers/food/condiment/attack_self(var/mob/user as mob)
	return

/obj/item/reagent_containers/food/condiment/attack(var/mob/M as mob, var/mob/user as mob, var/def_zone)
	if(standard_feed_mob(user, M))
		return

/obj/item/reagent_containers/food/condiment/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!user.Adjacent(target))
		return
	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return

	if(istype(target, /obj/item/reagent_containers/food/snacks)) // These are not opencontainers but we can transfer to them
		if(!reagents || !reagents.total_volume)
			to_chat(user, span_notice("There is no condiment left in \the [src]."))
			return

		if(!target.reagents.get_free_space())
			to_chat(user, span_notice("You can't add more condiment to \the [target]."))
			return

		var/trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
		to_chat(user, span_notice("You add [trans] units of the condiment to \the [target]."))
	else
		..()

/obj/item/reagent_containers/food/condiment/feed_sound(var/mob/user)
	playsound(src, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/condiment/self_feed_message(var/mob/user)
	to_chat(user, span_notice("You swallow some of contents of \the [src]."))

/obj/item/reagent_containers/food/condiment/on_reagent_change()
	if(reagents.reagent_list.len > 0)
		switch(reagents.get_master_reagent_id())
			if(REAGENT_ID_KETCHUP)
				name = REAGENT_KETCHUP
				desc = "You feel more American already."
				icon_state = "ketchup"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_MUSTARD)
				name = REAGENT_MUSTARD
				desc = "A somewhat bitter topping."
				icon_state = "mustard"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_CAPSAICIN)
				name = "Hotsauce"
				desc = "You can almost TASTE the stomach ulcers now!"
				icon_state = "hotsauce"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_ENZYME)
				name = REAGENT_ENZYME
				desc = "Used in cooking various dishes."
				icon_state = "enzyme"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_SOYSAUCE)
				name = REAGENT_SOYSAUCE
				desc = "A salty soy-based flavoring."
				icon_state = "soysauce"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_VINEGAR)
				name = REAGENT_VINEGAR
				desc = "An acetic acid used in various dishes."
				icon_state = "vinegar"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_FROSTOIL)
				name = "Coldsauce"
				desc = "Leaves the tongue numb in its passage."
				icon_state = "coldsauce"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_SODIUMCHLORIDE)
				name = "Salt Shaker"
				desc = "Salt. From space oceans, presumably."
				icon_state = "saltshaker"
				center_of_mass_x = 17
				center_of_mass_y = 11
			if(REAGENT_ID_BLACKPEPPER)
				name = "Pepper Mill"
				desc = "Often used to flavor food or make people sneeze."
				icon_state = "peppermillsmall"
				center_of_mass_x = 17
				center_of_mass_y = 11
			if(REAGENT_ID_COOKINGOIL)
				name = REAGENT_COOKINGOIL
				desc = "A delicious oil used in cooking. General purpose."
				icon_state = "oliveoil"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_SUGAR)
				name = REAGENT_SUGAR
				desc = "Tastey space sugar!"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_PEANUTBUTTER)
				name = REAGENT_PEANUTBUTTER
				desc = "A jar of smooth peanut butter."
				icon_state = "peanutbutter"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_MAYO)
				name = REAGENT_MAYO
				desc = "A jar of mayonnaise!"
				icon_state = "mayo"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_YEAST)
				name = REAGENT_YEAST
				desc = "This is what you use to make bread fluffy."
				icon_state = "yeast"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_SPACESPICE)
				name = "bottle of space spice"
				desc = "An exotic blend of spices for cooking. Definitely not worms."
				icon_state = "spacespicebottle"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_BARBECUE)
				name = "barbecue sauce"
				desc = "Barbecue sauce, it's labeled 'sweet and spicy'."
				icon_state = "barbecue"
				center_of_mass_x = 16
				center_of_mass_y = 6
			if(REAGENT_ID_SPRINKLES)
				name = REAGENT_ID_SPRINKLES
				desc = "Bottle of sprinkles, colourful!"
				icon_state= "sprinkles"
				center_of_mass_x = 16
				center_of_mass_y = 6
			else
				name = "Misc Condiment Bottle"
				if (reagents.reagent_list.len==1)
					desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
				else
					desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
				icon_state = "mixedcondiments"
				center_of_mass_x = 16
				center_of_mass_y = 6
	else
		icon_state = "emptycondiment"
		name = "Condiment Bottle"
		desc = "An empty condiment bottle."
		center_of_mass_x = 16
		center_of_mass_y = 6
		return

/obj/item/reagent_containers/food/condiment/enzyme
	name = REAGENT_ENZYME
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"

/obj/item/reagent_containers/food/condiment/enzyme/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_ENZYME, 50)

/obj/item/reagent_containers/food/condiment/sugar/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SUGAR, 50)

/obj/item/reagent_containers/food/condiment/ketchup/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_KETCHUP, 50)

/obj/item/reagent_containers/food/condiment/mustard/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MUSTARD, 50)

/obj/item/reagent_containers/food/condiment/hotsauce/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CAPSAICIN, 50)

/obj/item/reagent_containers/food/condiment/cookingoil
	name = REAGENT_COOKINGOIL

/obj/item/reagent_containers/food/condiment/cookingoil/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COOKINGOIL, 50)

/obj/item/reagent_containers/food/condiment/cornoil
	name = REAGENT_CORNOIL

/obj/item/reagent_containers/food/condiment/cornoil/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CORNOIL, 50)

/obj/item/reagent_containers/food/condiment/coldsauce/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_FROSTOIL, 50)

/obj/item/reagent_containers/food/condiment/soysauce/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SOYSAUCE, 50)

/obj/item/reagent_containers/food/condiment/vinegar/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_VINEGAR, 50)

/obj/item/reagent_containers/food/condiment/yeast
	name = REAGENT_YEAST

/obj/item/reagent_containers/food/condiment/yeast/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_YEAST, 50)

/obj/item/reagent_containers/food/condiment/sprinkles
	name = REAGENT_SPRINKLES

/obj/item/reagent_containers/food/condiment/sprinkles/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SPRINKLES, 50)

/obj/item/reagent_containers/food/condiment/small
	possible_transfer_amounts = list(1,20)
	amount_per_transfer_from_this = 1
	volume = 20
	center_of_mass_x = 0
	center_of_mass_y = 0

/obj/item/reagent_containers/food/condiment/small/on_reagent_change()
	return

/obj/item/reagent_containers/food/condiment/small/saltshaker	//Seperate from above since it's a small shaker rather then
	name = "salt shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	center_of_mass_x = 17
	center_of_mass_y = 11

/obj/item/reagent_containers/food/condiment/small/saltshaker/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SODIUMCHLORIDE, 20)

/obj/item/reagent_containers/food/condiment/small/peppermill //Keeping name here to save map based headaches
	name = "pepper shaker"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppershakersmall"
	center_of_mass_x = 17
	center_of_mass_y = 11

/obj/item/reagent_containers/food/condiment/small/peppermill/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_BLACKPEPPER, 20)

/obj/item/reagent_containers/food/condiment/small/peppergrinder
	name = "pepper mill"
	desc = "Fancy way to season a dish or make people sneeze."
	icon_state = "peppermill"
	center_of_mass_x = 17
	center_of_mass_y = 11

/obj/item/reagent_containers/food/condiment/small/peppermill/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_BLACKPEPPER, 30)

/obj/item/reagent_containers/food/condiment/small/sugar
	name = REAGENT_ID_SUGAR
	desc = "Sweetness in a bottle"
	icon_state = "sugarsmall"

/obj/item/reagent_containers/food/condiment/small/sugar/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SUGAR, 20)

//MRE condiments and drinks.

/obj/item/reagent_containers/food/condiment/small/packet
	icon_state = "packet_small"
	w_class = ITEMSIZE_TINY
	possible_transfer_amounts = "1;5;10"
	amount_per_transfer_from_this = 1
	volume = 5

/obj/item/reagent_containers/food/condiment/small/packet/salt
	name = "salt packet"
	desc = "Contains 5u of table salt."
	icon_state = "packet_small_white"

/obj/item/reagent_containers/food/condiment/small/packet/salt/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SODIUMCHLORIDE, 5)

/obj/item/reagent_containers/food/condiment/small/packet/pepper
	name = "pepper packet"
	desc = "Contains 5u of black pepper."
	icon_state = "packet_small_black"

/obj/item/reagent_containers/food/condiment/small/packet/pepper/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_BLACKPEPPER, 5)

/obj/item/reagent_containers/food/condiment/small/packet/sugar
	name = "sugar packet"
	desc = "Contains 5u of refined sugar."
	icon_state = "packet_small_white"

/obj/item/reagent_containers/food/condiment/small/packet/sugar/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SUGAR, 5)

/obj/item/reagent_containers/food/condiment/small/packet/jelly
	name = "jelly packet"
	desc = "Contains 10u of cherry jelly. Best used for spreading on crackers."
	icon_state = "packet_medium"
	volume = 10

/obj/item/reagent_containers/food/condiment/small/packet/jelly/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CHERRYJELLY, 10)

/obj/item/reagent_containers/food/condiment/small/packet/honey
	name = "honey packet"
	desc = "Contains 10u of honey."
	icon_state = "packet_medium"
	volume = 10

/obj/item/reagent_containers/food/condiment/small/packet/honey/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_HONEY, 10)

/obj/item/reagent_containers/food/condiment/small/packet/capsaicin
	name = "hot sauce packet"
	desc = "Contains 5u of hot sauce. Enjoy in moderation."
	icon_state = "packet_small_red"

/obj/item/reagent_containers/food/condiment/small/packet/capsaicin/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CAPSAICIN, 5)

/obj/item/reagent_containers/food/condiment/small/packet/ketchup
	name = "ketchup packet"
	desc = "Contains 5u of ketchup."
	icon_state = "packet_small_red"

/obj/item/reagent_containers/food/condiment/small/packet/ketchup/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_KETCHUP, 5)

/obj/item/reagent_containers/food/condiment/small/packet/mayo
	name = "mayonnaise packet"
	desc = "Contains 5u of mayonnaise."
	icon_state = "packet_small_white"

/obj/item/reagent_containers/food/condiment/small/packet/mayo/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_MAYO, 5)

/obj/item/reagent_containers/food/condiment/small/packet/soy
	name = "soy sauce packet"
	desc = "Contains 5u of soy sauce."
	icon_state = "packet_small_black"

/obj/item/reagent_containers/food/condiment/small/packet/soy/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SOYSAUCE, 5)

/obj/item/reagent_containers/food/condiment/small/packet/coffee
	name = "coffee powder packet"
	desc = "Contains 5u of coffee powder. Mix with 25u of water and heat."

/obj/item/reagent_containers/food/condiment/small/packet/coffee/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COFFEEPOWDER, 5)

/obj/item/reagent_containers/food/condiment/small/packet/tea
	name = "tea powder packet"
	desc = "Contains 5u of black tea powder. Mix with 25u of water and heat."

/obj/item/reagent_containers/food/condiment/small/packet/tea/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_TEA, 5)

/obj/item/reagent_containers/food/condiment/small/packet/cocoa
	name = "cocoa powder packet"
	desc = "Contains 5u of cocoa powder. Mix with 25u of water and heat."

/obj/item/reagent_containers/food/condiment/small/packet/cocoa/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COCO, 5)

/obj/item/reagent_containers/food/condiment/small/packet/grape
	name = "grape juice powder packet"
	desc = "Contains 5u of powdered grape juice. Mix with 15u of water."

/obj/item/reagent_containers/food/condiment/small/packet/grape/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_INSTANTGRAPE, 5)

/obj/item/reagent_containers/food/condiment/small/packet/orange
	name = "orange juice powder packet"
	desc = "Contains 5u of powdered orange juice. Mix with 15u of water."

/obj/item/reagent_containers/food/condiment/small/packet/orange/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_INSTANTORANGE, 5)

/obj/item/reagent_containers/food/condiment/small/packet/watermelon
	name = "watermelon juice powder packet"
	desc = "Contains 5u of powdered watermelon juice. Mix with 15u of water."

/obj/item/reagent_containers/food/condiment/small/packet/watermelon/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_INSTANTWATERMELON, 5)

/obj/item/reagent_containers/food/condiment/small/packet/apple
	name = "apple juice powder packet"
	desc = "Contains 5u of powdered apple juice. Mix with 15u of water."

/obj/item/reagent_containers/food/condiment/small/packet/apple/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_INSTANTAPPLE, 5)

/obj/item/reagent_containers/food/condiment/small/packet/protein
	name = "protein powder packet"
	desc = "Contains 10u of powdered protein. Mix with 20u of water."
	icon_state = "packet_medium"
	volume = 10

/obj/item/reagent_containers/food/condiment/small/packet/protein/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEIN, 10)

/obj/item/reagent_containers/food/condiment/small/packet/crayon
	name = "crayon powder packet"
	desc = "Contains 10u of powdered crayon. Mix with 30u of water."
	volume = 10
/obj/item/reagent_containers/food/condiment/small/packet/crayon/generic/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUST, 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/red/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUSTRED, 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/orange/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUSTORANGE, 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/yellow/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUSTYELLOW, 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/green/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUSTGREEN, 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/blue/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUSTBLUE, 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/purple/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUSTPURPLE, 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/grey/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUSTGREY, 10)
/obj/item/reagent_containers/food/condiment/small/packet/crayon/brown/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CRAYONDUSTBROWN, 10)

//End of MRE stuff.

/obj/item/reagent_containers/food/condiment/carton/flour
	name = "flour carton"
	desc = "A big carton of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"
	volume = 220
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/condiment/carton/flour/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/food/condiment/carton/flour/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_FLOUR, 200)
	randpixel_xy()

/obj/item/reagent_containers/food/condiment/carton/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/food.dmi', src, "[icon_state]10")

		filling.icon_state = "[icon_state]-[clamp(round(100 * reagents.total_volume / volume, 25), 0, 100)]"

		overlays += filling

/obj/item/reagent_containers/food/condiment/carton/flour/rustic
	name = "flour sack"
	desc = "An artisanal sack of flour. Classy!"
	icon_state = "flour_bag"

/obj/item/reagent_containers/food/condiment/carton/sugar
	name = "sugar carton"
	desc = "A big carton of sugar. Sweet!"
	icon_state = REAGENT_ID_SUGAR
	volume = 120
	center_of_mass_x = 16
	center_of_mass_y = 8

/obj/item/reagent_containers/food/condiment/carton/sugar/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/food/condiment/carton/sugar/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SUGAR, 100)

/obj/item/reagent_containers/food/condiment/carton/sugar/rustic
	name = "sugar sack"
	desc = "An artisanal sack of sugar. Classy!"
	icon_state = "sugar_bag"

/obj/item/reagent_containers/food/condiment/spacespice
	name = "space spices"
	desc = "An exotic blend of spices for cooking. Definitely not worms."
	icon_state = "spacespicebottle"
	possible_transfer_amounts = list(1,40) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 40

/obj/item/reagent_containers/food/condiment/spacespice/on_reagent_change()
	return

/obj/item/reagent_containers/food/condiment/spacespice/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SPACESPICE, 40)

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder
	name = "protein powder packet"
	desc = "Contains 5u of regular protein powder. Mix with 25u of water and enjoy."
	icon_state = "protein_powder1"

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_PROTEINPOWDER, 5)

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/vanilla
	name = "vanilla protein powder packet"
	desc = "Contains 5u of vanilla flavored protein powder. Mix with 25u of water and enjoy."
	icon_state = "protein_powder2"

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/vanilla/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_VANILLAPROTEINPOWDER, 5)

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/banana
	name = "banana protein powder packet"
	desc = "Contains 5u of banana flavored protein powder. Mix with 25u of water and enjoy."
	icon_state = "protein_powder3"

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/banana/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_BANANAPROTEINPOWDER, 5)

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/chocolate
	name = "chocolate protein powder packet"
	desc = "Contains 5u of chocolate flavored protein powder. Mix with 25u of water and enjoy."
	icon_state = "protein_powder4"

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/chocolate/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CHOCOLATEPROTEINPOWDER, 5)

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/strawberry
	name = "strawberry protein powder packet"
	desc = "Contains 5u of strawberry flavored protein powder. Mix with 25u of water and enjoy."
	icon_state = "protein_powder5"

/obj/item/reagent_containers/food/condiment/small/packet/protein_powder/strawberry/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_STRAWBERRYPROTEINPOWDER, 5)
