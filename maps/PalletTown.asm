const_value set 2
    const PALLETTOWN_TEACHER
    const PALLETTOWN_FISHER
    const PALLETTOWN_OAK
 
PalletTown_MapScriptHeader:
.MapTriggers:
    db 2
 
    ; triggers
    maptrigger .Trigger0
    maptrigger .Trigger1
 
.MapCallbacks:
    db 1
 
    ; callbacks
    dbw MAPCALLBACK_NEWMAP, .FlyPoint
 
.Trigger0
    end
 
.Trigger1
    end
 
.FlyPoint
    setflag ENGINE_FLYPOINT_PALLET
    return
 
PalletTown_OakStopsYou1: ; left side of the path
    playmusic MUSIC_PROF_OAK
    opentext
    writetext Oak_HeyWait
    waitbutton
    closetext
    spriteface PLAYER, DOWN
    showemote EMOTE_SHOCK, PLAYER, 15
	appear PALLETTOWN_OAK
    applymovement PALLETTOWN_OAK, Movement_OakWalksUp_Pallet1
    opentext
    writetext Oak_NotSafe
    waitbutton
    closetext
    follow PALLETTOWN_OAK, PLAYER
    applymovement PALLETTOWN_OAK, Movement_OakWalksDown_Pallet1
    stopfollow
    applymovement PLAYER, Movement_WalkOntoDoor_Pallet
    dotrigger $1
    warpcheck
	disappear PALLETTOWN_OAK
    end
 
PalletTown_OakStopsYou2: ; right side of the path
    playmusic MUSIC_PROF_OAK
    opentext
    writetext Oak_HeyWait
    waitbutton
    closetext
    spriteface PLAYER, DOWN
    showemote EMOTE_SHOCK, PLAYER, 15
	appear PALLETTOWN_OAK
    applymovement PALLETTOWN_OAK, Movement_OakWalksUp_Pallet2
    opentext
    writetext Oak_NotSafe
    waitbutton
    closetext
    follow PALLETTOWN_OAK, PLAYER
    applymovement PALLETTOWN_OAK, Movement_OakWalksDown_Pallet2
    stopfollow
    applymovement PLAYER, Movement_WalkOntoDoor_Pallet
    dotrigger $1
    warpcheck
	disappear PALLETTOWN_OAK
    end
 
TeacherScript_0x1ac6d5:
    jumptextfaceplayer UnknownText_0x1ac6e7
 
FisherScript_0x1ac6d8:
    jumptextfaceplayer UnknownText_0x1ac720
 
PalletTownSign:
    jumptext PalletTownSignText
 
RedsHouseSign:
    jumptext RedsHouseSignText
 
OaksLabSign:
    jumptext OaksLabSignText
 
BluesHouseSign:
    jumptext BluesHouseSignText
 
UnknownText_0x1ac6e7:
    text "I'm raising #-"
    line "MON too."
 
    para "When they get"
    line "strong, they can"
    cont "protect me!"
    done
 
UnknownText_0x1ac720:
    text "Technology is"
    line "incredible!"
 
    para "You can now trade"
    line "#MON across"
    cont "time like e-mail."
    done
 
PalletTownSignText:
    text "PALLET TOWN"
 
    para "Shades of your"
    line "journey await!"
    done
 
RedsHouseSignText:
    text "<PLAYER>'S HOUSE"
    done
 
OaksLabSignText:
    text "OAK #MON"
    line "RESEARCH LAB"
    done
 
BluesHouseSignText:
    text "<RIVAL>'S HOUSE"
    done
 
Oak_HeyWait:
    text "Hey! Wait!"
    line "Don't go out!"
    done
   
Oak_NotSafe:
    text "It's unsafe!"
    line "Wild #MON live"
    cont "in tall grass!"
   
    para "You need your own"
    line "#MON for your"
    cont "protection."
   
    para "I know!"
   
    para "Here, come with"
    line "me!"
    done
 
Movement_OakWalksUp_Pallet1: ; walk up to left side of path
    step_right
    step_right
    step_up
    step_up
    step_up
    step_end
 
Movement_OakWalksUp_Pallet2: ; walk up to right side of path
    step_right
    step_right
    step_right
    step_up
    step_up
    step_up
    step_end
 
Movement_OakWalksDown_Pallet1: ; walk to lab from left side
    step_down
    step_down
    step_down
    step_down
    step_down
    step_left
    step_down
    step_down
    step_down
    step_down
    step_down
    step_right
    step_right
    step_right
    step_right
    step_end
 
Movement_OakWalksDown_Pallet2: ; walk to lab from right side
    step_down
    step_down
    step_down
    step_down
    step_down
    step_left
    step_left
    step_down
    step_down
    step_down
    step_down
    step_down
    step_right
    step_right
    step_right
    step_right
    step_end
 
Movement_WalkOntoDoor_Pallet: ; walk the player onto the door after Oak goes inside
    step_up
    step_end
 
PalletTown_MapEventHeader:
    ; filler
    db 0, 0
 
.Warps:
    db 3
    warp_def $5, $5, 1, KRISS_HOUSE_1F
    warp_def $5, $d, 1, BLUES_HOUSE
    warp_def $b, $c, 1, ELMS_LAB
 
.XYTriggers:
    db 2
    xy_trigger 0, 1, 10, 0, PalletTown_OakStopsYou1, 0, 0
    xy_trigger 0, 1, 11, 0, PalletTown_OakStopsYou2, 0, 0
 
.Signposts:
    db 4
    signpost 9, 7, SIGNPOST_READ, PalletTownSign
    signpost 5, 3, SIGNPOST_READ, RedsHouseSign
    signpost 13, 13, SIGNPOST_READ, OaksLabSign
    signpost 5, 11, SIGNPOST_READ, BluesHouseSign
 
.PersonEvents:
    db 3
    person_event SPRITE_TEACHER, 8, 3, SPRITEMOVEDATA_WANDER, 2, 2, -1, -1, 0, PERSONTYPE_SCRIPT, 0, TeacherScript_0x1ac6d5, -1
    person_event SPRITE_FISHER, 14, 12, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 2, -1, -1, (1 << 3) | PAL_OW_GREEN, PERSONTYPE_SCRIPT, 0, FisherScript_0x1ac6d8, -1
    person_event SPRITE_TEACHER, 5, 8, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, 0, PERSONTYPE_SCRIPT, 0, ObjectEvent, EVENT_INITIALIZED_EVENTS ; he should be hidden and only show up during the script