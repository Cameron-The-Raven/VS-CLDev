/*
CIRCUITS BELOW
*/

/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 2000)
	chemicals = list(REAGENT_ID_SACID = 20)
	time = 5

/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([item_name])"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([item_name])"
		else
			name = "Circuit design ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/circuit/jukebox
	name = "jukebox"
	id = "jukebox"
	req_tech = list(TECH_MAGNET = 2, TECH_DATA = 1)
	build_path = /obj/item/circuitboard/jukebox
	sort_string = "MAAAO"

/datum/design/circuit/clonecontrol
	name = "cloning control console"
	id = "clonecontrol"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/cloning
	sort_string = "FAGAC"

/datum/design/circuit/clonepod
	name = "clone pod"
	id = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonepod
	sort_string = "FAGAE"

/datum/design/circuit/clonescanner
	name = "cloning scanner"
	id = "clonescanner"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonescanner
	sort_string = "FAGAG"

/datum/design/circuit/chem_master
	name = "ChemMaster 3000"
	id = "chemmaster"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/chem_master
	sort_string = "FAGAH"

/datum/design/circuit/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/crew
	sort_string = "FAGAI"

/datum/design/circuit/pandemic
	name = "PanD.E.M.I.C 2200"
	id = "pandemic"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/pandemic
	sort_string = "FAGAJ"

/datum/design/circuit/teleconsole
	name = "teleporter control console"
	id = "teleconsole"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/teleporter
	sort_string = "HAAAA"

/datum/design/circuit/robocontrol
	name = "robotics control console"
	id = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/robotics
	sort_string = "HAAAB"

/datum/design/circuit/mechacontrol
	name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/mecha_control
	sort_string = "HAAAC"

/datum/design/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rdconsole
	sort_string = "HAAAE"

/datum/design/circuit/aifixer
	name = "AI integrity restorer"
	id = "aifixer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/aifixer
	sort_string = "HAAAF"

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_monitor
	sort_string = "HAACA"

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_server
	sort_string = "HAACB"

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/message_monitor
	sort_string = "HAACC"

/datum/design/circuit/aiupload
	name = "AI upload console"
	id = "aiupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/aiupload
	sort_string = "HAABA"

/datum/design/circuit/borgupload
	name = "cyborg upload console"
	id = "borgupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/borgupload
	sort_string = "HAABB"

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/destructive_analyzer
	sort_string = "HABAA"

/datum/design/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/protolathe
	sort_string = "HABAB"

/datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter
	sort_string = "HABAC"

/datum/design/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/autolathe
	sort_string = "HABAD"

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdservercontrol
	sort_string = "HABBA"

/datum/design/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdserver
	sort_string = "HABBB"

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/mechfab
	sort_string = "HABAE"

/datum/design/circuit/prosfab
	name = "prosthetics fabricator"
	id = "prosfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/prosthetics
	sort_string = "HABAF"

/datum/design/circuit/mech_recharger
	name = "mech recharger"
	id = "mech_recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/mech_recharger
	sort_string = "HACAA"

/datum/design/circuit/recharge_station
	name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/recharge_station
	sort_string = "HACAC"

/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/circuitboard/atmos_alert
	sort_string = "JAAAA"

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/circuitboard/air_management
	sort_string = "JAAAB"

/datum/design/circuit/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/circuitboard/rcon_console
	sort_string = "JAAAC"

/datum/design/circuit/dronecontrol
	name = "drone control console"
	id = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/drone_control
	sort_string = "JAAAD"

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/circuitboard/powermonitor
	sort_string = "JAAAE"

/datum/design/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/solar_control
	sort_string = "JAAAF"

/datum/design/circuit/shutoff_monitor
	name = "Automatic shutoff valve monitor"
	id = "shutoff_monitor"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shutoff_monitor
	sort_string = "JAAAG"

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/pacman
	sort_string = "JBAAA"

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/pacman/super
	sort_string = "JBAAB"

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/pacman/mrs
	sort_string = "JBAAC"

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/batteryrack
	sort_string = "JBABA"

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/smes
	sort_string = "JBABB"

/datum/design/circuit/grid_checker
	name = "power grid checker"
	desc = "Allows for the construction of circuit boards used to build a grid checker."
	id = "grid_checker"
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/grid_checker
	sort_string = "JBABC"

/datum/design/circuit/breakerbox
	name = "breaker box"
	desc = "Allows for the construction of circuit boards used to build a breaker box."
	id = "breakerbox"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/breakerbox
	sort_string = "JBABD"

/datum/design/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"

/datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure
	sort_string = "JDAAA"

/datum/design/circuit/ordercomp
	name = "supply ordering console"
	id = "ordercomp"
	build_path = /obj/item/circuitboard/supplycomp
	sort_string = "KAAAY"	// Duplicate string, really need to redo this whole thing

/datum/design/circuit/supplycomp
	name = "supply control console"
	id = "supplycomp"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/supplycomp/control
	sort_string = "KAAAZ"	// Duplicate string, really need to redo this whole thing

/datum/design/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/biogenerator
	sort_string = "KBAAA"

/datum/design/circuit/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrill
	sort_string = "KCAAA"

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrillbrace
	sort_string = "KCAAB"

/datum/design/circuit/comconsole
	name = "communications console"
	id = "comconsole"
	build_path = /obj/item/circuitboard/communications
	sort_string = "LAAAA"

/datum/design/circuit/idcardconsole
	name = "ID card modification console"
	id = "idcardconsole"
	build_path = /obj/item/circuitboard/card
	sort_string = "LAAAB"

/datum/design/circuit/emp_data
	name = "employment records console"
	id = "emp_data"
	build_path = /obj/item/circuitboard/skills
	sort_string = "LAAAC"

/datum/design/circuit/arf_generator
	name = "atmospheric field generator"
	id = "arf_generator"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/arf_generator
	sort_string = "LAAAD"

/datum/design/circuit/protean_reconstitutor
	name = "protean reconstitutor"
	id = "protean_recon"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	build_path = /obj/item/circuitboard/protean_reconstitutor
	sort_string = "LAAAE"

/datum/design/circuit/mecha
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/mecha/AssembleDesignName()
	name = "Exosuit module circuit design ([name])"
/datum/design/circuit/mecha/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

/datum/design/circuit/mecha/ripley_main
	name = "APLU 'Ripley' central control"
	id = "ripley_main"
	build_path = /obj/item/circuitboard/mecha/ripley/main
	sort_string = "NAAAA"

/datum/design/circuit/mecha/ripley_peri
	name = "APLU 'Ripley' peripherals control"
	id = "ripley_peri"
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals
	sort_string = "NAAAB"

/datum/design/circuit/mecha/odysseus_main
	name = "'Odysseus' central control"
	id = "odysseus_main"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/main
	sort_string = "NAABA"

/datum/design/circuit/mecha/odysseus_peri
	name = "'Odysseus' peripherals control"
	id = "odysseus_peri"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals
	sort_string = "NAABB"

/datum/design/circuit/mecha/gygax_main
	name = "'Gygax' central control"
	id = "gygax_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main
	sort_string = "NAACA"

/datum/design/circuit/mecha/gygax_peri
	name = "'Gygax' peripherals control"
	id = "gygax_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals
	sort_string = "NAACB"

/datum/design/circuit/mecha/gygax_targ
	name = "'Gygax' weapon control and targeting"
	id = "gygax_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting
	sort_string = "NAACC"

/datum/design/circuit/mecha/gygax_medical
	name = "'Serenity' medical control"
	id = "gygax_medical"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/medical
	sort_string = "NAACD"

/datum/design/circuit/mecha/durand_main
	name = "'Durand' central control"
	id = "durand_main"
	req_tech = list(TECH_DATA = 4)
	materials = list(MAT_GLASS = 2000, MAT_GRAPHITE = 1250)
	chemicals = list(REAGENT_ID_SACID = 20)
	build_path = /obj/item/circuitboard/mecha/durand/main
	sort_string = "NAADA"

/datum/design/circuit/mecha/durand_peri
	name = "'Durand' peripherals control"
	id = "durand_peri"
	req_tech = list(TECH_DATA = 4)
	materials = list(MAT_GLASS = 2000, MAT_GRAPHITE = 1250)
	chemicals = list(REAGENT_ID_SACID = 20)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals
	sort_string = "NAADB"

/datum/design/circuit/mecha/durand_targ
	name = "'Durand' weapon control and targeting"
	id = "durand_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	materials = list(MAT_GLASS = 2000, MAT_GRAPHITE = 1250)
	chemicals = list(REAGENT_ID_SACID = 20)
	build_path = /obj/item/circuitboard/mecha/durand/targeting
	sort_string = "NAADC"

/datum/design/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/circuitboard/telecomms/server
	sort_string = "PAAAA"

/datum/design/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/circuitboard/telecomms/processor
	sort_string = "PAAAB"

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/circuitboard/telecomms/bus
	sort_string = "PAAAC"

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/circuitboard/telecomms/hub
	sort_string = "PAAAD"

/datum/design/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/circuitboard/telecomms/relay
	sort_string = "PAAAE"

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/broadcaster
	sort_string = "PAAAF"

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/receiver
	sort_string = "PAAAG"

/datum/design/circuit/tcom/exonet_node
	name = "exonet node"
	id = "tcom-exonet_node"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_BLUESPACE = 4)
	build_path = /obj/item/circuitboard/telecomms/exonet_node
	sort_string = "PAAAH"

/datum/design/circuit/shield
	req_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	materials = list(MAT_GLASS = 2000, MAT_GOLD = 1000)

/datum/design/circuit/shield/AssembleDesignName()
	name = "Shield generator circuit design ([name])"
/datum/design/circuit/shield/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [name] shield generator."

/datum/design/circuit/shield/bubble
	name = "bubble (OBSOLETE)" //VOREStation Edit
	id = "shield_gen"
	build_path = /obj/item/circuitboard/shield_gen
	sort_string = "VAAAZ"	// Duplicate string, really need to redo this whole thing

/datum/design/circuit/shield/hull
	name = "hull (OBSOLETE)" //VOREStation Edit
	id = "shield_gen_ex"
	build_path = /obj/item/circuitboard/shield_gen_ex
	sort_string = "VAAAB"

/datum/design/circuit/shield/capacitor
	name = "capacitor (OBSOLETE)" //VOREStation Edit"
	desc = "Allows for the construction of a shield capacitor circuit board."
	id = "shield_cap"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/shield_cap
	sort_string = "VAAAC"

/datum/design/circuit/ntnet_relay
	name = "NTNet Quantum Relay"
	id = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/ntnet_relay
	sort_string = "WAAAA"

/datum/design/circuit/aicore
	name = "AI core"
	id = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/aicore
	sort_string = "XAAAA"
// Cooking Appliances
/datum/design/circuit/microwave
	name = "microwave board"
	id = "microwave_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/microwave
	sort_string = "HACAM"

/datum/design/circuit/oven
	name = "oven board"
	id = "oven_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/oven
	sort_string = "HACAN"

/datum/design/circuit/fryer
	name = "deep fryer board"
	id = "fryer_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/fryer
	sort_string = "HACAO"

/datum/design/circuit/cerealmaker
	name = "cereal maker board"
	id = "cerealmaker_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/cerealmaker
	sort_string = "HACAP"

/datum/design/circuit/candymaker
	name = "candy machine board"
	id = "candymachine_board"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/candymachine
	sort_string = "HACAQ"

/datum/design/circuit/microwave/advanced
	name = "deluxe microwave"
	id = "deluxe microwave"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_BLUESPACE = 4)
	build_path = /obj/item/circuitboard/microwave/advanced
	sort_string = "HACAA"


/datum/design/circuit/shield_generator
	name = "shield generator"
	id = "shield_generator"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4, TECH_BLUESPACE = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shield_generator
	sort_string = "OAAAA"

/datum/design/circuit/shield_diffuser
	name = "shield diffuser"
	id = "shield_diffuser"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 2, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/shield_diffuser
	sort_string = "OAAAB"

/datum/design/circuit/pointdefense
	name = "point defense battery"
	id = "pointdefense"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_COMBAT = 4)
	build_path = /obj/item/circuitboard/pointdefense
	sort_string = "OAABA"

/datum/design/circuit/pointdefense_control
	name = "point defense control"
	id = "pointdefense_control"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/pointdefense_control
	sort_string = "OAABB"

/datum/design/circuit/recycler_crusher
	name = "recycler - crusher"
	id = "recycler_crusher"
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_crusher
	sort_string = "OAABC"

/datum/design/circuit/recycler_sorter
	name = "recycler - sorter"
	id = "recycler_sorter"
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_sorter
	sort_string = "OAABD"

/datum/design/circuit/recycler_stamper
	name = "recycler - stamper"
	id = "recycler_stamper"
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/circuitboard/recycler_stamper
	sort_string = "OAABE"

///Fighters///

//Pinnace//

/datum/design/circuit/mecha/fighter/pinnace_main
	name = "Pinnace central control board"
	id = "pinnace_main"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/main
	sort_string = "NAAGA"

/datum/design/circuit/mecha/fighter/pinnace_flight
	name = "Pinnace flight control board"
	id = "pinnace_flight"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/flight
	sort_string = "NAAGB"

/datum/design/circuit/mecha/fighter/pinnace_targeting
	name = "Pinnace weapon control and targeting board"
	id = "pinnace_targeting"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/targeting
	sort_string = "NAAGC"

/datum/design/circuit/mecha/fighter/pinnace_cockpit_control
	name = "Pinnace manual flight control instruments"
	id = "pinnace_cockpit_control"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/cockpitboard
	sort_string = "NAAGD"

//Baron//

/datum/design/circuit/mecha/fighter/baron_main
	name = "Baron central control board"
	id = "baron_main"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/main
	sort_string = "NAAHA"

/datum/design/circuit/mecha/fighter/baron_flight
	name = "Baron flight control board"
	id = "baron_flight"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/flight
	sort_string = "NAAHB"

/datum/design/circuit/mecha/fighter/baron_targeting
	name = "Baron weapon control and targeting board"
	id = "baron_targeting"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/targeting
	sort_string = "NAAHC"

/datum/design/circuit/mecha/fighter/baron_cockpit_control
	name = "Baron manual flight control instruments"
	id = "baron_cockpit_control"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/cockpitboard
	sort_string = "NAAHD"
