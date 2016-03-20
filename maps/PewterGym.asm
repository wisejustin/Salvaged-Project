const_value set 2
	const PEWTERGYM_BROCK
	const PEWTERGYM_YOUNGSTER
	const PEWTERGYM_GYM_GUY

PewterGym_MapScriptHeader:
.MapTriggers:
	db 0

.MapCallbacks:
	db 0

BrockScript_0x1a2864:
	faceplayer
	opentext
	checkflag ENGINE_BOULDERBADGE
	iftrue .FightDone
	writetext UnknownText_0x1a28d0
	waitbutton
	closetext
	winlosstext UnknownText_0x1a29bb, 0
	loadtrainer BROCK, 1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_BROCK
	setevent EVENT_BEAT_CAMPER_JERRY
	opentext
	writetext UnknownText_0x1a2a3d
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_BOULDERBADGE
	writetext UnknownText_0x1a2a57
	buttonsound
	verbosegiveitem TM_SWAGGER
	playsound SFX_ITEM
	waitsfx
	closetext
	opentext
	writetext got_bide
	waitbutton
	closetext
	end

.FightDone
	writetext UnknownText_0x1a2ada
	waitbutton
	closetext
	end

TrainerCamperJerry:
	trainer EVENT_BEAT_CAMPER_JERRY, CAMPER, JERRY, CamperJerrySeenText, CamperJerryBeatenText, 0, CamperJerryScript

CamperJerryScript:
	end_if_just_battled
	opentext
	writetext UnknownText_0x1a2c0f
	waitbutton
	closetext
	end

PewterGymGuyScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_BROCK
	iftrue .PewterGymGuyWinScript
	writetext PewterGymGuyText
	waitbutton
	closetext
	end

.PewterGymGuyWinScript
	writetext PewterGymGuyWinText
	waitbutton
	closetext
	end

PewterGymStatue:
	checkflag ENGINE_BOULDERBADGE
	iftrue .Beaten
	jumpstd gymstatue1
.Beaten
	trainertotext BROCK, 1, $1
	jumpstd gymstatue2

UnknownText_0x1a28d0:
	text "I'm BROCK!"
	line "I'm PEWTER's GYM"
	cont "LEADER!"

	para "I believe in rock"
	line "hard defense and"
	cont "determination!"

	para "That's why my"
	line "#MON are all"
	cont "the rock-type!"

	para "Do you still want"
	line "to challenge me?"
	cont "Fine then! Show"
	cont "me your best!"
	done

UnknownText_0x1a29bb:
	text "There are all"
	line "kinds of trainers"
	cont "in the world!"

	para "You appear to be"
	line "very gifted as a"
	cont "#MON trainer!"

	para "Go to the GYM in"
	line "CERULEAN and test"
	cont "your abilities!"
	done

UnknownText_0x1a2a3d:
	text "<PLAYER> received"
	line "BOULDERBADGE."
	done

UnknownText_0x1a2a57:
	text "BROCK: <PLAY_G>,"
	line "thanks. I enjoyed"

	para "battling you, even"
	line "though I am a bit"
	cont "upset."

	para "That BOULDERBADGE"
	line "will make your"

	para "#MON even more"
	line "powerful."
	cont "I also want to"
	cont "give you this."
	done

UnknownText_0x1a2ada:
	text "BROCK: The world"
	line "is huge. There are"

	para "still many strong"
	line "trainers like you."

	para "Just wait and see."
	line "I'm going to be-"
	cont "come a lot strong-"
	cont "er too."
	done

CamperJerrySeenText:
	text "Stop right there,"
	line "kid!"

	para "You're still light"
	line "years from facing"
	cont "BROCK!"
	done

CamperJerryBeatenText:
	text "Darn!"

	para "Light years isn't"
	line "time! It measures"
	cont "distance!"
	prompt

UnknownText_0x1a2c0f:
	text "You're pretty hot,"
	line "but not as hot"
	cont "as BROCK!"
	done

PewterGymGuyText:
	text "Hiya! I can tell"
	line "you have what it"
	cont "takes to become a"
	cont "#MON champ!"

	para "I'm no trainer,"
	line "but I can tell"
	cont "you how to win!"

	para "Let me take you"
	line "to the top!"
	done

PewterGymGuyWinText:
	text "All right! Let's"
	line "get happening!"
	prompt
	
got_bide:
	text "A TM contains a"
	line "technique that"
	cont "can be taught to"
	cont "a #MON! A TM"
	cont "is good only once!"
	cont "so when you use"
	cont "one to teach a new"
	cont "technique,pick the"
	cont "#MON carefully!"
	cont "TM34 contains Bide"
	cont "Your #MON will"
	cont "absorb damage in"
	cont "in battle then pay"
	cont "it back double!"
	done
	
PewterGym_MapEventHeader:
	; filler
	db 0, 0

.Warps:
	db 2
	warp_def $d, $4, 2, PEWTER_CITY
	warp_def $d, $5, 2, PEWTER_CITY

.XYTriggers:
	db 0

.Signposts:
	db 2
	signpost 11, 2, SIGNPOST_READ, PewterGymStatue
	signpost 11, 7, SIGNPOST_READ, PewterGymStatue

.PersonEvents:
	db 3
	person_event SPRITE_BROCK, 1, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BROWN, PERSONTYPE_SCRIPT, 0, BrockScript_0x1a2864, -1
	person_event SPRITE_YOUNGSTER, 7, 3, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_TRAINER, 3, TrainerCamperJerry, -1
	person_event SPRITE_GYM_GUY, 11, 6, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 1, PewterGymGuyScript, -1
