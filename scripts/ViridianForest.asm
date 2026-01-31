ViridianForest_Script:
	call EnableAutoTextBoxDrawing
	; Check if this is the first entry to trigger the "!" animation
	call ViridianForestFirstEntryCheck
	; Check if we need to play the Rocket Leader defeat cinematic
	call ViridianForestRocketCinematicCheck
	; Hide Rockets after leader is beaten (for re-entry)
	call ViridianForestHideRocketsCheck
	ld hl, ViridianForestTrainerHeaders
	ld de, ViridianForest_ScriptPointers
	ld a, [wViridianForestCurScript]
	call ExecuteCurMapScriptInTable
	ld [wViridianForestCurScript], a
	ret

ViridianForestFirstEntryCheck:
	CheckEvent EVENT_ENTERED_VIRIDIAN_FOREST
	ret nz ; already entered before
	; First time entering - show "!" above player
	SetEvent EVENT_ENTERED_VIRIDIAN_FOREST
	xor a
	ld [wEmotionBubbleSpriteIndex], a ; player's sprite (0)
	ld [wWhichEmotionBubble], a ; EXCLAMATION_BUBBLE
	predef EmotionBubble
	; Show intro text
	ld a, TEXT_VIRIDIANFOREST_FIRST_ENTRY
	ldh [hTextID], a
	call DisplayTextID
	ret

ViridianForestFirstEntryText:
	text_far _ViridianForestFirstEntryText
	text_end

ViridianForestRocketCinematicCheck:
	; Check if leader is beaten
	CheckEvent EVENT_BEAT_VIRIDIAN_FOREST_ROCKET_LEADER
	ret z ; not beaten yet
	; Check if cinematic already played
	CheckEvent EVENT_VIRIDIAN_FOREST_ROCKET_CINEMATIC_DONE
	ret nz ; already played
	; Play the cinematic now!
	; Show after-battle dialogue using DisplayTextID (initializes textbox properly)
	ld a, TEXT_VIRIDIANFOREST_ROCKET_CINEMATIC
	ldh [hTextID], a
	call DisplayTextID
	; Fade to black
	call GBFadeOutToBlack
	; Hide all Rocket-related NPCs
	ld a, TOGGLE_VIRIDIAN_FOREST_ROCKET_LEADER
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_1
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_3
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_4
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_5
	ld [wToggleableObjectIndex], a
	predef HideObject
	; Update sprites and fade back in
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	; Mark cinematic as done
	SetEvent EVENT_VIRIDIAN_FOREST_ROCKET_CINEMATIC_DONE
	ret

ViridianForestRocketLeaderCinematicText:
	text_far _ViridianForestRocketLeaderAfterBattleText
	text_end

ViridianForestHideRocketsCheck:
	CheckEvent EVENT_BEAT_VIRIDIAN_FOREST_ROCKET_LEADER
	ret z ; leader not beaten yet, keep everyone visible
	; Hide Rocket Leader and all Beauties after leader is beaten
	ld a, TOGGLE_VIRIDIAN_FOREST_ROCKET_LEADER
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_1
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_2
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_3
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_4
	ld [wToggleableObjectIndex], a
	predef HideObject
	ld a, TOGGLE_VIRIDIAN_FOREST_BEAUTY_5
	ld [wToggleableObjectIndex], a
	predef_jump HideObject

ViridianForest_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_VIRIDIANFOREST_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_VIRIDIANFOREST_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_VIRIDIANFOREST_END_BATTLE

ViridianForest_TextPointers:
	def_text_pointers
	; Object events (1-10) - must come first
	dw_const ViridianForestYoungster1Text,      TEXT_VIRIDIANFOREST_YOUNGSTER1
	dw_const ViridianForestYoungster2Text,      TEXT_VIRIDIANFOREST_YOUNGSTER2
	dw_const ViridianForestYoungster3Text,      TEXT_VIRIDIANFOREST_YOUNGSTER3
	dw_const ViridianForestYoungster4Text,      TEXT_VIRIDIANFOREST_YOUNGSTER4
	dw_const PickUpItemText,                    TEXT_VIRIDIANFOREST_ANTIDOTE
	dw_const PickUpItemText,                    TEXT_VIRIDIANFOREST_POTION
	dw_const PickUpItemText,                    TEXT_VIRIDIANFOREST_POKE_BALL
	dw_const ViridianForestYoungster5Text,      TEXT_VIRIDIANFOREST_YOUNGSTER5
	dw_const ViridianForestRocketLeaderText,    TEXT_VIRIDIANFOREST_ROCKET_LEADER
	dw_const ViridianForestBeauty1Text,     	TEXT_VIRIDIANFOREST_BEAUTY_1
	dw_const ViridianForestBeauty2Text,     	TEXT_VIRIDIANFOREST_BEAUTY_2
	dw_const ViridianForestBeauty3Text,     	TEXT_VIRIDIANFOREST_BEAUTY_3
	dw_const ViridianForestBeauty4Text,     	TEXT_VIRIDIANFOREST_BEAUTY_4
	dw_const ViridianForestBeauty5Text,     	TEXT_VIRIDIANFOREST_BEAUTY_5
	; Background events (11+)
	dw_const ViridianForestTrainerTips1Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS1
	dw_const ViridianForestUseAntidoteSignText, TEXT_VIRIDIANFOREST_USE_ANTIDOTE_SIGN
	dw_const ViridianForestTrainerTips2Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS2
	dw_const ViridianForestTrainerTips3Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS3
	dw_const ViridianForestTrainerTips4Text,    TEXT_VIRIDIANFOREST_TRAINER_TIPS4
	dw_const ViridianForestLeavingSignText,     TEXT_VIRIDIANFOREST_LEAVING_SIGN
	; Script-triggered texts
	dw_const ViridianForestFirstEntryText,      TEXT_VIRIDIANFOREST_FIRST_ENTRY
	dw_const ViridianForestRocketLeaderCinematicText, TEXT_VIRIDIANFOREST_ROCKET_CINEMATIC

ViridianForestTrainerHeaders:
	def_trainers 2
ViridianForestTrainerHeader0:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_0, 4, ViridianForestYoungster2BattleText, ViridianForestYoungster2EndBattleText, ViridianForestYoungster2AfterBattleText
ViridianForestTrainerHeader1:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_1, 4, ViridianForestYoungster3BattleText, ViridianForestYoungster3EndBattleText, ViridianForestYoungster3AfterBattleText
ViridianForestTrainerHeader2:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_2, 1, ViridianForestYoungster4BattleText, ViridianForestYoungster4EndBattleText, ViridianForestYoungster4AfterBattleText
ViridianForestBeautyHeader0:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_BEAUTY_0, 1, ViridianForestBeauty1BattleText, ViridianForestBeauty1EndBattleText, ViridianForestBeauty1AfterBattleText
ViridianForestBeautyHeader1:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_BEAUTY_1, 1, ViridianForestBeauty2BattleText, ViridianForestBeauty2EndBattleText, ViridianForestBeauty2AfterBattleText
ViridianForestRocketLeaderHeader:
	trainer EVENT_BEAT_VIRIDIAN_FOREST_ROCKET_LEADER, 3, ViridianForestRocketLeaderBattleText, ViridianForestRocketLeaderEndBattleText, ViridianForestRocketLeaderAfterBattleText
	db -1 ; end

; Youngster1 - Example of dialogue changing based on quest progress
ViridianForestYoungster1Text:
	text_asm
	CheckEvent EVENT_BEAT_VIRIDIAN_FOREST_ROCKET_LEADER
	jr nz, .rockets_gone
	; Rockets still around
	ld hl, .RocketsAroundText
	jr .print
.rockets_gone
	ld hl, .RocketsGoneText
.print
	call PrintText
	jp TextScriptEnd
 
.RocketsAroundText:
	text_far _ViridianForestYoungster1RocketsText
	text_end
 
.RocketsGoneText:
	text_far _ViridianForestYoungster1Text
	text_end

ViridianForestYoungster2Text:
	text_asm
	ld hl, ViridianForestTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestYoungster3Text:
	text_asm
	ld hl, ViridianForestTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestYoungster4Text:
	text_asm
	ld hl, ViridianForestTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestYoungster2BattleText:
	text_far _ViridianForestYoungster2BattleText
	text_end

ViridianForestYoungster2EndBattleText:
	text_far _ViridianForestYoungster2EndBattleText
	text_end

ViridianForestYoungster2AfterBattleText:
	text_far _ViridianForestYoungster2AfterBattleText
	text_end

ViridianForestYoungster3BattleText:
	text_far _ViridianForestYoungster3BattleText
	text_end

ViridianForestYoungster3EndBattleText:
	text_far _ViridianForestYoungster3EndBattleText
	text_end

ViridianForestYoungster3AfterBattleText:
	text_far _ViridianForestYoungster3AfterBattleText
	text_end

ViridianForestYoungster4BattleText:
	text_far _ViridianForestYoungster4BattleText
	text_end

ViridianForestYoungster4EndBattleText:
	text_far _ViridianForestYoungster4EndBattleText
	text_end

ViridianForestYoungster4AfterBattleText:
	text_far _ViridianForestYoungster4AfterBattleText
	text_end

ViridianForestYoungster5Text:
	text_far _ViridianForestYoungster5Text
	text_end

ViridianForestTrainerTips1Text:
	text_far _ViridianForestTrainerTips1Text
	text_end

ViridianForestUseAntidoteSignText:
	text_far _ViridianForestUseAntidoteSignText
	text_end

ViridianForestTrainerTips2Text:
	text_far _ViridianForestTrainerTips2Text
	text_end

ViridianForestTrainerTips3Text:
	text_far _ViridianForestTrainerTips3Text
	text_end

ViridianForestTrainerTips4Text:
	text_far _ViridianForestTrainerTips4Text
	text_end

ViridianForestLeavingSignText:
	text_far _ViridianForestLeavingSignText
	text_end

; Rocket Leader - battling trainer (boss)
ViridianForestRocketLeaderText:
	text_asm
	ld hl, ViridianForestRocketLeaderHeader
	call TalkToTrainer
	jp TextScriptEnd
 
ViridianForestRocketLeaderBattleText:
	text_far _ViridianForestRocketLeaderBattleText
	text_end
 
ViridianForestRocketLeaderEndBattleText:
	text_far _ViridianForestRocketLeaderEndBattleText
	text_end
 
; After battle text (shown when re-talking, but NPC disappears so won't be seen)
ViridianForestRocketLeaderAfterBattleText:
	text_far _ViridianForestRocketLeaderAfterBattleText
	text_end
 
ViridianForestBeauty1Text:
	text_asm
	ld hl, ViridianForestBeautyHeader0
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestBeauty1BattleText:
	text_far _ViridianForestBeauty1BattleText
	text_end

ViridianForestBeauty1EndBattleText:
	text_far _ViridianForestBeauty1EndBattleText
	text_end

ViridianForestBeauty1AfterBattleText:
	text_far _ViridianForestBeauty1AfterBattleText
	text_end
 
ViridianForestBeauty2Text:
	text_asm
	ld hl, ViridianForestBeautyHeader1
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestBeauty2BattleText:
	text_far _ViridianForestBeauty2BattleText
	text_end

ViridianForestBeauty2EndBattleText:
	text_far _ViridianForestBeauty2EndBattleText
	text_end

ViridianForestBeauty2AfterBattleText:
	text_far _ViridianForestBeauty2AfterBattleText
	text_end

ViridianForestBeauty3Text:
	text_far _ViridianForestBeauty3Text
	text_end

ViridianForestBeauty4Text:
	text_far _ViridianForestBeauty4Text
	text_end

ViridianForestBeauty5Text:
	text_far _ViridianForestBeauty5Text
	text_end