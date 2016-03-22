const_value set 2
	const ELMSLAB_ELM
	const ELMSLAB_SCIENTIST
	const ELMSLAB_POKE_BALL1
	const ELMSLAB_POKE_BALL2
	const ELMSLAB_POKE_BALL3
	const ELMSLAB_OFFICER

ElmsLab_MapScriptHeader:
.MapTriggers:
	db 6

	; triggers
	maptrigger .Trigger0
	maptrigger .Trigger1
	maptrigger .Trigger2
	maptrigger .Trigger3
	maptrigger .Trigger4
	maptrigger .Trigger5

.MapCallbacks:
	db 1

	; callbacks

	dbw MAPCALLBACK_OBJECTS, .Callback_MoveElm

.Trigger0:
	priorityjump ElmsLab_AutowalkUpToElm
	end

.Trigger1:
	end

.Trigger2:
	end

.Trigger3:
	end

.Trigger4:
	end

.Trigger5:
	end

.Callback_MoveElm:
	checktriggers
	iftrue .Skip
	moveperson ELMSLAB_ELM, $3, $4
.Skip:
	return

ElmsLab_AutowalkUpToElm:
	applymovement PLAYER, ElmsLab_WalkUpToElmMovement
	showemote EMOTE_SHOCK, ELMSLAB_ELM, 15
	spriteface ELMSLAB_ELM, RIGHT
	opentext
	writetext ElmText_Intro
ElmsLab_RefuseLoop:
	yesorno
	iftrue ElmsLab_ElmGetsEmail
	writetext ElmText_Refused
	jump ElmsLab_RefuseLoop

ElmsLab_ElmGetsEmail:
	writetext ElmText_Accepted
	buttonsound
	writetext ElmText_ResearchAmbitions
	waitbutton
	closetext
	playsound SFX_GLASS_TING
	pause 30
	showemote EMOTE_SHOCK, ELMSLAB_ELM, 10
	spriteface ELMSLAB_ELM, DOWN
	opentext
	writetext ElmText_GotAnEmail
	waitbutton
	closetext
	opentext
	spriteface ELMSLAB_ELM, RIGHT
	writetext ElmText_MissionFromMrPokemon
	waitbutton
	closetext
	applymovement ELMSLAB_ELM, ElmsLab_ElmToDefaultPositionMovement1
	spriteface PLAYER, UP
	applymovement ELMSLAB_ELM, ElmsLab_ElmToDefaultPositionMovement2
	spriteface PLAYER, RIGHT
	opentext
	writetext ElmText_ChooseAPokemon
	waitbutton
	dotrigger $1
	closetext
	end

ProfElmScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_SS_TICKET_FROM_ELM
	iftrue ElmCheckMasterBall
	checkevent EVENT_BEAT_ELITE_FOUR
	iftrue ElmGiveTicketScript
ElmCheckMasterBall:
	checkevent EVENT_GOT_MASTER_BALL_FROM_ELM
	iftrue ElmCheckEverstone
	checkflag ENGINE_RISINGBADGE
	iftrue ElmGiveMasterBallScript
ElmCheckEverstone:
	checkevent EVENT_GOT_EVERSTONE_FROM_ELM
	iftrue ElmScript_CallYou
	checkevent EVENT_SHOWED_TOGEPI_TO_ELM
	iftrue ElmGiveEverstoneScript
	checkevent EVENT_TOLD_ELM_ABOUT_TOGEPI_OVER_THE_PHONE
	iffalse ElmCheckTogepiEgg
	writebyte TOGEPI
	special Special_FindThatSpeciesYourTrainerID
	iftrue ShowElmTogepiScript
	writebyte TOGETIC
	special Special_FindThatSpeciesYourTrainerID
	iftrue ShowElmTogepiScript
	writetext UnknownText_0x79a40
	waitbutton
	closetext
	end

ElmEggHatchedScript:
	writebyte TOGEPI
	special Special_FindThatSpeciesYourTrainerID
	iftrue ShowElmTogepiScript
	writebyte TOGETIC
	special Special_FindThatSpeciesYourTrainerID
	iftrue ShowElmTogepiScript
	jump ElmCheckGotEggAgain

ElmCheckTogepiEgg:
	checkevent EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE
	iffalse ElmCheckGotEggAgain
	checkevent EVENT_TOGEPI_HATCHED
	iftrue ElmEggHatchedScript
ElmCheckGotEggAgain:
	checkevent EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE ; why are we checking it again?
	iftrue ElmWaitingEggHatchScript
	checkflag ENGINE_ZEPHYRBADGE
	iftrue ElmAideHasEggScript
	checkevent EVENT_GAVE_MYSTERY_EGG_TO_ELM
	iftrue ElmStudyingEggScript
	checkevent EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON
	iftrue ElmAfterTheftScript
	checkevent EVENT_GOT_A_POKEMON_FROM_ELM
	iftrue ElmDescribesMrPokemonScript
	writetext ElmText_LetYourMonBattleIt
	waitbutton
	closetext
	end

LabTryToLeaveScript:
	spriteface ELMSLAB_ELM, DOWN
	opentext
	writetext LabWhereGoingText
	waitbutton
	closetext
	applymovement PLAYER, MovementData_0x78f70
	end

CYNDAQUILPokeBallScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_ELM
	iftrue LookAtElmPokeBallScript
	spriteface ELMSLAB_ELM, DOWN
	refreshscreen $0
	pokepic CHARMANDER
	cry CHARMANDER
	waitbutton
	closepokepic
	opentext
	writetext TakeCYNDAQUILText
	yesorno
	iffalse DidntChooseStarterScript
	disappear ELMSLAB_POKE_BALL1
	setevent EVENT_GOT_CYNDAQUIL_FROM_ELM
	writetext ChoseStarterText
	buttonsound
	waitsfx
	pokenamemem CHARMANDER, $0
	writetext ReceivedStarterText
	playsound SFX_CAUGHT_MON
	waitsfx
	buttonsound
	givepoke CHARMANDER, 5, BERRY
	closetext
	checkcode VAR_FACING
	if_equal RIGHT, ElmDirectionsScript
	applymovement PLAYER, AfterCYNDAQUILMovement
	jump ElmDirectionsScript

TOTODILEPokeBallScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_ELM
	iftrue LookAtElmPokeBallScript
	spriteface ELMSLAB_ELM, DOWN
	refreshscreen $0
	pokepic SQUIRTLE
	cry SQUIRTLE
	waitbutton
	closepokepic
	opentext
	writetext TakeTOTODILEText
	yesorno
	iffalse DidntChooseStarterScript
	disappear ELMSLAB_POKE_BALL2
	setevent EVENT_GOT_TOTODILE_FROM_ELM
	writetext ChoseStarterText
	buttonsound
	waitsfx
	pokenamemem SQUIRTLE, $0
	writetext ReceivedStarterText
	playsound SFX_CAUGHT_MON
	waitsfx
	buttonsound
	givepoke SQUIRTLE, 5, BERRY
	closetext
	applymovement PLAYER, AfterTOTODILEMovement
	jump ElmDirectionsScript

CHIKORITAPokeBallScript:
	checkevent EVENT_GOT_A_POKEMON_FROM_ELM
	iftrue LookAtElmPokeBallScript
	spriteface ELMSLAB_ELM, DOWN
	refreshscreen $0
	pokepic BULBASAUR
	cry BULBASAUR
	waitbutton
	closepokepic
	opentext
	writetext TakeCHIKORITAText
	yesorno
	iffalse DidntChooseStarterScript
	disappear ELMSLAB_POKE_BALL3
	setevent EVENT_GOT_CHIKORITA_FROM_ELM
	writetext ChoseStarterText
	buttonsound
	waitsfx
	pokenamemem BULBASAUR, $0
	writetext ReceivedStarterText
	playsound SFX_CAUGHT_MON
	waitsfx
	buttonsound
	givepoke BULBASAUR, 5, BERRY
	closetext
	applymovement PLAYER, AfterCHIKORITAMovement
	jump ElmDirectionsScript

DidntChooseStarterScript:
	writetext DidntChooseStarterText
	waitbutton
	closetext
	end

ElmDirectionsScript:
	spriteface PLAYER, UP
	opentext
	writetext ElmDirectionsText1
	waitbutton
	closetext
	addcellnum PHONE_ELM
	opentext
	writetext GotElmsNumberText
	playsound SFX_REGISTER_PHONE_NUMBER
	waitsfx
	waitbutton
	closetext
	spriteface ELMSLAB_ELM, LEFT
	opentext
	writetext ElmDirectionsText2
	waitbutton
	buttonsound
	waitsfx
	writetext Pokedex
	playsound SFX_ITEM
	waitsfx
	setflag ENGINE_POKEDEX
	closetext
	spriteface ELMSLAB_ELM, DOWN
	opentext
	writetext ElmDirectionsText3
	waitbutton
	closetext
	opentext
	writetext ElmsLabOfficerText1
	buttonsound
	special SpecialNameRival
	writetext ElmsLabOfficerText2
	waitbutton
	closetext
	setevent EVENT_GOT_A_POKEMON_FROM_ELM
	setevent EVENT_RIVAL_CHERRYGROVE_CITY
	dotrigger $5
	domaptrigger PALLET_TOWN, $1
	end

ElmDescribesMrPokemonScript:
	writetext ElmDescribesMrPokemonText
	waitbutton
	closetext
	end

LookAtElmPokeBallScript:
	opentext
	writetext ElmPokeBallText
	waitbutton
	closetext
	end

ElmsLabHealingMachine:
	opentext
	checkevent EVENT_GOT_A_POKEMON_FROM_ELM
	iftrue .CanHeal
	writetext ElmsLabHealingMachineText1
	waitbutton
	closetext
	end

.CanHeal
	writetext ElmsLabHealingMachineText2
	yesorno
	iftrue ElmsLabHealingMachine_HealParty
	closetext
	end

ElmsLabHealingMachine_HealParty:
	special Mobile_HealParty
	special HealParty
	playmusic MUSIC_NONE
	writebyte 1 ; Machine is in Elm's Lab
	special HealMachineAnim
	pause 30
	special RestartMapMusic
	closetext
	end

ElmAfterTheftDoneScript:
	waitbutton
	closetext
	end

ElmAfterTheftScript:
	writetext ElmAfterTheftText1
	checkitem MYSTERY_EGG
	iffalse ElmAfterTheftDoneScript
	buttonsound
	writetext ElmAfterTheftText2
	waitbutton
	takeitem MYSTERY_EGG
	scall ElmJumpBackScript1
	writetext ElmAfterTheftText3
	waitbutton
	scall ElmJumpBackScript2
	writetext ElmAfterTheftText4
	buttonsound
	writetext ElmAfterTheftText5
	buttonsound
	setevent EVENT_GAVE_MYSTERY_EGG_TO_ELM
	setflag ENGINE_BUG_CONTEST_ON
	domaptrigger ROUTE_29, $1
	clearevent EVENT_ROUTE_30_YOUNGSTER_JOEY
	setevent EVENT_ROUTE_30_BATTLE
	writetext ElmAfterTheftText6
	waitbutton
	closetext
	dotrigger $6
	end

ElmStudyingEggScript:
	writetext ElmStudyingEggText
	waitbutton
	closetext
	end

ElmAideHasEggScript:
	writetext ElmAideHasEggText
	waitbutton
	closetext
	end

ElmWaitingEggHatchScript:
	writetext ElmWaitingEggHatchText
	waitbutton
	closetext
	end

ShowElmTogepiScript:
	writetext ShowElmTogepiText1
	waitbutton
	closetext
	showemote EMOTE_SHOCK, ELMSLAB_ELM, 15
	setevent EVENT_SHOWED_TOGEPI_TO_ELM
	opentext
	writetext ShowElmTogepiText2
	buttonsound
	writetext ShowElmTogepiText3
	buttonsound
ElmGiveEverstoneScript:
	writetext ElmGiveEverstoneText1
	buttonsound
	verbosegiveitem EVERSTONE
	iffalse ElmScript_NoRoomForEverstone
	writetext ElmGiveEverstoneText2
	waitbutton
	closetext
	setevent EVENT_GOT_EVERSTONE_FROM_ELM
	end

ElmScript_CallYou:
	writetext ElmText_CallYou
	waitbutton
ElmScript_NoRoomForEverstone:
	closetext
	end

ElmGiveMasterBallScript:
	writetext ElmGiveMasterBallText1
	buttonsound
	verbosegiveitem MASTER_BALL
	iffalse .notdone
	setevent EVENT_GOT_MASTER_BALL_FROM_ELM
	writetext ElmGiveMasterBallText2
	waitbutton
.notdone
	closetext
	end

ElmGiveTicketScript:
	writetext ElmGiveTicketText1
	buttonsound
	verbosegiveitem PASS
	setevent EVENT_GOT_SS_TICKET_FROM_ELM
	writetext ElmGiveTicketText2
	waitbutton
	closetext
	end

ElmJumpBackScript1:
	closetext
	checkcode VAR_FACING
	if_equal DOWN, ElmJumpDownScript
	if_equal UP, ElmJumpUpScript
	if_equal LEFT, ElmJumpLeftScript
	if_equal RIGHT, ElmJumpRightScript
	end

ElmJumpBackScript2:
	closetext
	checkcode VAR_FACING
	if_equal DOWN, ElmJumpUpScript
	if_equal UP, ElmJumpDownScript
	if_equal LEFT, ElmJumpRightScript
	if_equal RIGHT, ElmJumpLeftScript
	end

ElmJumpUpScript:
	applymovement ELMSLAB_ELM, ElmJumpUpMovement
	opentext
	end

ElmJumpDownScript:
	applymovement ELMSLAB_ELM, ElmJumpDownMovement
	opentext
	end

ElmJumpLeftScript:
	applymovement ELMSLAB_ELM, ElmJumpLeftMovement
	opentext
	end

ElmJumpRightScript:
	applymovement ELMSLAB_ELM, ElmJumpRightMovement
	opentext
	end

AideScript_WalkPotions1:
	applymovement ELMSLAB_SCIENTIST, AideWalksRight1
	spriteface PLAYER, DOWN
	scall AideScript_GivePotions
	applymovement ELMSLAB_SCIENTIST, AideWalksLeft1
	end

AideScript_WalkPotions2:
	applymovement ELMSLAB_SCIENTIST, AideWalksRight2
	spriteface PLAYER, DOWN
	scall AideScript_GivePotions
	applymovement ELMSLAB_SCIENTIST, AideWalksLeft2
	end

AideScript_GivePotions:
	opentext
	writetext AideText_GiveYouPotions
	verbosegiveitem POTION
	writetext AideText_AlwaysBusy
	waitbutton
	closetext
	dotrigger $2
	end

AideScript_WalkBalls1:
	applymovement ELMSLAB_SCIENTIST, AideWalksRight1
	spriteface PLAYER, DOWN
	scall AideScript_GiveYouBalls
	applymovement ELMSLAB_SCIENTIST, AideWalksLeft1
	end

AideScript_WalkBalls2:
	applymovement ELMSLAB_SCIENTIST, AideWalksRight2
	spriteface PLAYER, DOWN
	scall AideScript_GiveYouBalls
	applymovement ELMSLAB_SCIENTIST, AideWalksLeft2
	end

AideScript_GiveYouBalls:
	opentext
	writetext AideText_GiveYouBalls
	buttonsound
	itemtotext POKE_BALL, $1
	scall AideScript_ReceiveTheBalls
	giveitem POKE_BALL, 5
	writetext AideText_ExplainBalls
	buttonsound
	itemnotify
	closetext
	dotrigger $2
	end

AideScript_ReceiveTheBalls:
	jumpstd receiveitem
	end

ElmsAideScript:
	faceplayer
	opentext
	checkevent EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE
	iftrue AideScript_AfterTheft
	checkevent EVENT_GAVE_MYSTERY_EGG_TO_ELM
	iftrue AideScript_ExplainBalls
	checkevent EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON
	iftrue AideScript_TheftTestimony
	writetext AideText_AlwaysBusy
	waitbutton
	closetext
	end

AideScript_TheftTestimony:
	writetext AideText_TheftTestimony
	waitbutton
	closetext
	end

AideScript_ExplainBalls:
	writetext AideText_ExplainBalls
	waitbutton
	closetext
	end

AideScript_AfterTheft:
	writetext AideText_AfterTheft
	waitbutton
	closetext
	end

MeetCopScript2:
	applymovement PLAYER, MeetCopScript2_StepLeft

MeetCopScript:
	applymovement PLAYER, MeetCopScript_WalkUp
CopScript:
	spriteface ELMSLAB_OFFICER, LEFT
	opentext
	writetext ElmsLabOfficerText1
	buttonsound
	special SpecialNameRival
	writetext ElmsLabOfficerText2
	waitbutton
	closetext
	applymovement ELMSLAB_OFFICER, OfficerLeavesMovement
	disappear ELMSLAB_OFFICER
	dotrigger $2
	end

ElmsLabWindow:
	opentext
	checkflag ENGINE_FLYPOINT_VIOLET
	iftrue .Normal
	checkevent EVENT_ELM_CALLED_ABOUT_STOLEN_POKEMON
	iftrue .BreakIn
	jump .Normal

.BreakIn
	writetext ElmsLabWindowText2
	waitbutton
	closetext
	end

.Normal
	writetext ElmsLabWindowText1
	waitbutton
	closetext
	end

ElmsLabTravelTip1:
	jumptext ElmsLabTravelTip1Text

ElmsLabTravelTip2:
	jumptext ElmsLabTravelTip2Text

ElmsLabTravelTip3:
	jumptext ElmsLabTravelTip3Text

ElmsLabTravelTip4:
	jumptext ElmsLabTravelTip4Text

ElmsLabTrashcan:
	jumptext ElmsLabTrashcanText

ElmsLabPC:
	jumptext ElmsLabPCText

ElmsLabTrashcan2:
; unused
	jumpstd trashcan
	
ElmsLabBookshelf
	jumpstd difficultbookshelf

ElmsCustomBookshelf:
	jumptext ElmsCustomBookshelfText
	
ElmsCustomBookshelf1:
	jumptext ElmsCustomBookshelf1Text
	
ElmsCustomBookshelf2:
	jumptext ElmsCustomBookshelf2Text
	
ElmsCustomBookshelf3:
	jumptext ElmsCustomBookshelf3Text

ElmsLab_WalkUpToElmMovement:
	step_up
	step_up
	step_up
	step_up
	step_up
	step_up
	step_up
	turn_head_left
	step_end

MovementData_0x78f70:
	step_up
	step_end

MeetCopScript2_StepLeft:
	step_left
	step_end

MeetCopScript_WalkUp:
	step_up
	step_up
	turn_head_right
	step_end

OfficerLeavesMovement:
	step_down
	step_down
	step_down
	step_down
	step_down
	step_end

AideWalksRight1:
	step_right
	step_right
	turn_head_up
	step_end

AideWalksRight2:
	step_right
	step_right
	step_right
	turn_head_up
	step_end

AideWalksLeft1:
	step_left
	step_left
	turn_head_down
	step_end

AideWalksLeft2:
	step_left
	step_left
	step_left
	turn_head_down
	step_end

ElmJumpUpMovement:
	fix_facing
	big_step_up
	remove_fixed_facing
	step_end

ElmJumpDownMovement:
	fix_facing
	big_step_down
	remove_fixed_facing
	step_end

ElmJumpLeftMovement:
	fix_facing
	big_step_left
	remove_fixed_facing
	step_end

ElmJumpRightMovement:
	fix_facing
	big_step_right
	remove_fixed_facing
	step_end

ElmsLab_ElmToDefaultPositionMovement1:
	step_up
	step_end

ElmsLab_ElmToDefaultPositionMovement2:
	step_right
	step_right
	step_up
	turn_head_down
	step_end

AfterCYNDAQUILMovement:
	step_left
	step_up
	turn_head_up
	step_end

AfterTOTODILEMovement:
	step_left
	step_left
	step_up
	turn_head_up
	step_end

AfterCHIKORITAMovement:
	step_left
	step_left
	step_left
	step_up
	turn_head_up
	step_end

ElmText_Intro:
	text "OAK: <PLAY_G>!"
	line "There you are!"

	para "I needed to ask"
	line "you a favor."

	para "I'm conducting new"
	line "#MON research"

	para "right now. I was"
	line "wondering if you"

	para "could help me with"
	line "it, <PLAY_G>."

	para "You see…"

	para "I'm writing a"
	line "paper that I want"

	para "to present at a"
	line "conference."

	para "But there are some"
	line "things I don't"

	para "quite understand"
	line "yet."

	para "So!"

	para "I'd like you to"
	line "raise a #MON"

	para "that I recently"
	line "caught."
	done

ElmText_Accepted:
	text "Thanks, <PLAY_G>!"

	para "You're a great"
	line "help!"
	done

ElmText_Refused:
	text "But… Please, I"
	line "need your help"
	cont "to complete the"
	cont "#DEX"
	done

ElmText_ResearchAmbitions:
	text "When I announce my"
	line "findings, I'm sure"

	para "we'll delve a bit"
	line "deeper into the"

	para "many mysteries of"
	line "#MON."

	para "You can count on"
	line "it!"
	done

ElmText_GotAnEmail:
	text "Oh, hey! I got an"
	line "e-mail!"

	para $56, $56, $56
	line "Hm… Uh-huh…"

	para "Okay…"
	done

ElmText_MissionFromMrPokemon:
	text "Hey, listen."

	para "I have an task"
	line "for you.The"
	cont "#MON Leauge"

	para "needs more enemy's"
	line "to face and they"

	para "asked if I could"
	line "help start off"

	para "more Trainers with"
	line "#MON,They are"

	para "quite nice people"
	line "but are always"

	para "looking for a new"
	line "challenger! but"

	para "You're the only"
	line "Kid in town now."

	para "Wait!"

	para "I know!"

	para "<PLAY_G>, will you"
	line "go challenge them?"
	done

ElmText_ChooseAPokemon:
	text "I want you to"
	line "raise one of the"

	para "#MON contained"
	line "in these BALLS."

	para "You'll be that"
	line "#MON's first"
	cont "partner, <PLAY_G>!"

	para "Go on. Pick one!"
	done

ElmText_LetYourMonBattleIt:
	text "If a wild #MON"
	line "appears, let your"
	cont "#MON battle it!"
	done

LabWhereGoingText:
	text "OAK: Wait! Where"
	line "are you going?"
	done

TakeCYNDAQUILText:
	text "OAK: You'll take"
	line "CHARMANDER, the"
	cont "fire #MON?"
	done

TakeTOTODILEText:
	text "OAK: Do you want"
	line "SQUIRTLE, the"
	cont "water #MON?"
	done

TakeCHIKORITAText:
	text "OAK: So, you like"
	line "BULBASAUR, the"
	cont "grass #MON?"
	done

DidntChooseStarterText:
	text "OAK: Think it over"
	line "carefully."

	para "Your partner is"
	line "important."
	done

ChoseStarterText:
	text "OAK: I think"
	line "that's a great"
	cont "#MON too!"
	done

ReceivedStarterText:
	text "<PLAYER> received"
	line "@"
	text_from_ram StringBuffer3
	text "!"
	done

ElmDirectionsText1:
	text "<PLAYER>, im"
	line "counting on you"

	para "to try to complete"
	line "the #DEX."

	para "It's a hard task"
	line "to ask of a kid"

	para "but my grandson"
	line "is to naive to"

	para "achieve my goal,"
	line "so I want you to"

	para "Call me if"
	line "anything comes up!"
	done

ElmDirectionsText2:
	text "I almost forgot,"
	line "what kind of"

	para "#MON Trainer"
	line "would you be"

	para "without this!"
	done

ElmDirectionsText3:
	text "I updated the"
	line "#DEX, I hope"
	cont "you like it!"
	done

GotElmsNumberText:
	text "<PLAYER> got OAK's"
	line "phone number."
	done

ElmDescribesMrPokemonText:
	text "I have updated the"
	line "#dex since the"
	cont "last time anyone"

	para "has used it! it"
	line "has updated"
	cont "descriptions of"
	cont "all the #MON"
	cont "in Kanto and Johto"
	done

ElmPokeBallText:
	text "It contains a"
	line "#MON caught by"
	cont "PROF.OAK."
	done

ElmsLabHealingMachineText1:
	text "I wonder what this"
	line "does?"
	done

ElmsLabHealingMachineText2:
	text "Would you like to"
	line "heal your #MON?"
	done

ElmAfterTheftText1:
	text "OAK: <PLAY_G>, this"
	line "is terrible…"

	para "Oh, yes, what was"
	line "MR.#MON's big"
	cont "discovery?"
	done

ElmAfterTheftText2:
	text "<PLAYER> handed"
	line "the MYSTERY EGG to"
	cont "PROF.OAK."
	done

ElmAfterTheftText3:
	text "OAK: This?"
	done

ElmAfterTheftText4:
	text "But… Is it a"
	line "#MON EGG?"

	para "If it is, it is a"
	line "great discovery!"
	done

ElmAfterTheftText5:
	text "OAK: What?!?"

	para "PROF.ELM gave you"
	line "a #DEX?"

	para "<PLAY_G>, is that"
	line "true? Th-that's"
	cont "incredible!"

	para "He is superb at"
	line "seeing the poten-"
	cont "tial of people as"
	cont "trainers."

	para "Wow, <PLAY_G>. You"
	line "may have what it"

	para "takes to become"
	line "the CHAMPION."

	para "You seem to be"
	line "getting on great"
	cont "with #MON too."

	para "You should take"
	line "the #MON GYM"
	cont "challenge."

	para "The closest GYM"
	line "would be the one"
	cont "in VIRIDIAN CITY."
	done

ElmAfterTheftText6:
	text "…<PLAY_G>. The"
	line "road to the"

	para "championship will"
	line "be a long one."

	para "Before you leave,"
	line "make sure that you"
	cont "talk to your mom."
	done

ElmStudyingEggText:
	text "OAK: Don't give"
	line "up! I'll call if"

	para "I learn anything"
	line "about that EGG!"
	done

ElmAideHasEggText:
	text "OAK: <PLAY_G>?"
	line "Didn't you meet my"
	cont "assistant?"

	para "He should have met"
	line "you with the EGG"

	para "at VIOLET CITY's"
	line "#MON CENTER."

	para "You must have just"
	line "missed him. Try to"
	cont "catch him there."
	done

ElmWaitingEggHatchText:
	text "OAK: Hey, has that"
	line "EGG changed any?"
	done

UnknownText_0x79a40:
	text "<PLAY_G>? I thought"
	line "the EGG hatched."

	para "Where is the"
	line "#MON?"
	done

ShowElmTogepiText1:
	text "OAK: <PLAY_G>, you"
	line "look great!"
	done

ShowElmTogepiText2:
	text "What?"
	line "That #MON!?!"
	done

ShowElmTogepiText3:
	text "The EGG hatched!"
	line "So, #MON are"
	cont "born from EGGS…"

	para "No, perhaps not"
	line "all #MON are."

	para "Wow, there's still"
	line "a lot of research"
	cont "to be done."
	done

ElmGiveEverstoneText1:
	text "Thanks, <PLAY_G>!"
	line "You're helping"

	para "unravel #MON"
	line "mysteries for us!"

	para "I want you to have"
	line "this as a token of"
	cont "our appreciation."
	done

ElmGiveEverstoneText2:
	text "That's an"
	line "EVERSTONE."

	para "Some species of"
	line "#MON evolve"

	para "when they grow to"
	line "certain levels."

	para "A #MON holding"
	line "the EVERSTONE"
	cont "won't evolve."

	para "Give it to a #-"
	line "MON you don't want"
	cont "to evolve."
	done

ElmText_CallYou:
	text "OAK: <PLAY_G>, I'll"
	line "call you if any-"
	cont "thing comes up."
	done

AideText_AfterTheft:
	text "…sigh… That"
	line "stolen #MON."

	para "I wonder how it's"
	line "doing."

	para "They say a #MON"
	line "raised by a bad"

	para "person turns bad"
	line "itself."
	done

ElmGiveMasterBallText1:
	text "OAK: Hi, <PLAY_G>!"
	line "Thanks to you, my"

	para "research is going"
	line "great!"

	para "Take this as a"
	line "token of my"
	cont "appreciation."
	done

ElmGiveMasterBallText2:
	text "The MASTER BALL is"
	line "the best!"

	para "It's the ultimate"
	line "BALL! It'll catch"

	para "any #MON with-"
	line "out fail."

	para "It's given only to"
	line "recognized #MON"
	cont "researchers."

	para "I think you can"
	line "make much better"

	para "use of it than I"
	line "can, <PLAY_G>!"
	done

ElmGiveTicketText1:
	text "OAK: <PLAY_G>!"
	line "There you are!"

	para "I called because I"
	line "have something for"
	cont "you."

	para "See? It's a"
	line "Train Ticket."

	para "Now you can catch"
	line "#MON in JOHTO."
	done

ElmGiveTicketText2:
	text "The train departs"
	line "from SAFFRON CITY."

	para "But you knew that"
	line "already, <PLAY_G>."

	para "After all, you've"
	line "traveled all over"
	cont "with your #MON."

	para "Give my regards to"
	line "PROF.ELM in JOHTO!"
	done

ElmsLabSignpostText_Egg:
	text "It's the #MON"
	line "EGG being studied"
	cont "by PROF.OAK."
	done

AideText_GiveYouPotions:
	text "<PLAY_G>,I want"
	line "you to have "
	cont "these for your"
	cont "errand!"
	done

AideText_AlwaysBusy:
	text "There are only two"
	line "of us, so we're"
	cont "always busy."
	done

AideText_TheftTestimony:
	text "There was a loud"
	line "noise outside…"

	para "When we went to"
	line "look, someone"
	cont "stole a #MON."

	para "It's unbelievable"
	line "that anyone would"
	cont "do that!"

	para "…sigh… That"
	line "stolen #MON."

	para "I wonder how it's"
	line "doing."

	para "They say a #MON"
	line "raised by a bad"

	para "person turns bad"
	line "itself."
	done

AideText_GiveYouBalls:
	text "<PLAY_G>!"

	para "Use these on your"
	line "#DEX quest!"
	done

AideText_ExplainBalls:
	text "To add to your"
	line "#DEX, you have"
	cont "to catch #MON."

	para "Throw # BALLS"
	line "at wild #MON"
	cont "to get them."
	done

ElmsLabOfficerText1:
	text "Oh yea <PLAYER>"
	line "one last thing."
	cont "I have been in"
	cont "a coma for a while"
	cont "can you tell me my"
	cont "Sons name?"
	done

ElmsLabOfficerText2:
	text "OK! So <RIVAL>"
	line "was his name."

	para "Thanks for helping"
	line "me.Tell him I said"
	cont "hey next time you"
	cont "see him!"
	done

ElmsLabWindowText1:
	text "The window's open."

	para "A pleasant breeze"
	line "is blowing in."
	done

ElmsLabWindowText2:
	text "He broke in"
	line "through here!"
	done

ElmsLabTravelTip1Text:
	text "<PLAYER> opened a"
	line "book."

	para "Pokedex Creation"

	para "Professor Rowan"
	line "Came from the"
	cont "Sinnoh region to"
	cont "help calibrate"
	cont "the older model"
	cont "of the pokedex."
	cont "It has newer"
	cont "descriptions of"
	cont "Known #MON!"
	done

ElmsLabTravelTip2Text:
	text "<PLAYER> opened a"
	line "book."

	para "Diary Entry 2:"

	para "My first pokemon"
	line "was my Charmander."
	cont "I held it in a"
	cont "prototype version"
	cont "of the newer"
	cont "pokeballs."
	done

ElmsLabTravelTip3Text:
	text "<PLAYER> opened a"
	line "book."

	para "Diary Entry 3:"

	para "Kanto Region Champ"
	line "1996-1999"
	done

ElmsLabTravelTip4Text:
	text "<PLAYER> opened a"
	line "book."

	para "Diary Entry 4:"

	para "Prof. of the year"
	line "1996. Samuel Oak,"

	para "First person to "
	line "record all 151."
	cont "pokemon."
	done

ElmsLabTrashcanText:
	text "The wrapper from"
	line "the snack PROF.OAK"
	cont "ate is in there…"
	done

ElmsLabPCText:
	text "There's an e-mail"
	line "message here!"
	cont "..."
	cont "Calling all"
	cont "#MON trainers!"
	cont "The elite trainers"
	cont "of #MON LEAUGE"
	cont "are ready to take"
	cont "on all comers!"
	cont "Bring your best"
	cont "#MON and see"
	cont "how you rate as a"
	cont "trainer!"
	cont "#MON LEAUGE HQ"
	cont "INDIGO PLATEU"
	cont "PS: PROF.OAK,"
	cont "please visit us!"
	cont "..."
	done
	
ElmsCustomBookshelfText:
    text "These books are"
	line "from another"
	cont "region. Looks"
	cont "like they're"
	cont "from the Kanto."
	cont "region!"
	done
	
ElmsCustomBookshelf1Text:
	text "These books are"
	line "from another"
	cont "region. Looks"
	cont "like they're"
	cont "from the Johto"
	cont "region!"
	done
	
ElmsCustomBookshelf2Text
	text "These books are"
	line "from another"
	cont "region. Looks"
	cont "like they're"
	cont "from the Hoenn"
	cont "region!"
	done
	
ElmsCustomBookshelf3Text
	text "These books are"
	line "from another"
	cont "region. Looks"
	cont "like they're"
	cont "from the Sinnoh"
	cont "region!"
	done
	
Pokedex
	text "<PLAYER> received"
	line "#DEX!"
	done
	
refuse_potions
	text "thats okay,I just"
	line "wanted to help."
	done

ElmsLab_MapEventHeader:
	; filler
	db 0, 0

.Warps:
	db 2
	warp_def $b, $4, 3, PALLET_TOWN
	warp_def $b, $5, 3, PALLET_TOWN

.XYTriggers:
	db 8
	xy_trigger 1, $6, $4, $0, LabTryToLeaveScript, $0, $0
	xy_trigger 1, $6, $5, $0, LabTryToLeaveScript, $0, $0
	xy_trigger 3, $5, $4, $0, MeetCopScript, $0, $0
	xy_trigger 3, $5, $5, $0, MeetCopScript2, $0, $0
	xy_trigger 5, $8, $4, $0, AideScript_WalkPotions1, $0, $0
	xy_trigger 5, $8, $5, $0, AideScript_WalkPotions2, $0, $0
	xy_trigger 6, $8, $4, $0, AideScript_WalkBalls1, $0, $0
	xy_trigger 6, $8, $5, $0, AideScript_WalkBalls2, $0, $0

.Signposts:
	db 16
	signpost 1, 2, SIGNPOST_READ, ElmsLabHealingMachine
	signpost 1, 6, SIGNPOST_READ, ElmsLabBookshelf
	signpost 1, 7, SIGNPOST_READ, ElmsLabBookshelf
	signpost 1, 8, SIGNPOST_READ, ElmsLabBookshelf
	signpost 1, 9, SIGNPOST_READ, ElmsLabBookshelf
	signpost 7, 0, SIGNPOST_READ, ElmsLabTravelTip1
	signpost 7, 1, SIGNPOST_READ, ElmsLabTravelTip2
	signpost 7, 2, SIGNPOST_READ, ElmsLabTravelTip3
	signpost 7, 3, SIGNPOST_READ, ElmsLabTravelTip4
	signpost 7, 6, SIGNPOST_READ, ElmsCustomBookshelf
	signpost 7, 7, SIGNPOST_READ, ElmsCustomBookshelf1
	signpost 7, 8, SIGNPOST_READ, ElmsCustomBookshelf2
	signpost 7, 9, SIGNPOST_READ, ElmsCustomBookshelf3
	signpost 3, 9, SIGNPOST_READ, ElmsLabTrashcan
	signpost 0, 5, SIGNPOST_READ, ElmsLabWindow
	signpost 5, 3, SIGNPOST_DOWN, ElmsLabPC

.PersonEvents:
	db 6
	person_event SPRITE_OAK, 2, 5, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, ProfElmScript, -1
	person_event SPRITE_SCIENTIST, 9, 2, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, ElmsAideScript, EVENT_ELMS_AIDE_IN_LAB
	person_event SPRITE_POKE_BALL, 3, 6, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, CYNDAQUILPokeBallScript, EVENT_CYNDAQUIL_POKEBALL_IN_ELMS_LAB
	person_event SPRITE_POKE_BALL, 3, 7, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, TOTODILEPokeBallScript, EVENT_TOTODILE_POKEBALL_IN_ELMS_LAB
	person_event SPRITE_POKE_BALL, 3, 8, SPRITEMOVEDATA_ITEM_TREE, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, CHIKORITAPokeBallScript, EVENT_CHIKORITA_POKEBALL_IN_ELMS_LAB
	person_event SPRITE_OFFICER, 3, 5, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, (1 << 3) | PAL_OW_BLUE, PERSONTYPE_SCRIPT, 0, CopScript, EVENT_COP_IN_ELMS_LAB
