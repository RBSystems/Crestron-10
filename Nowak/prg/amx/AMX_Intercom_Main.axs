PROGRAM_NAME='AMX_Intercom_Main'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 02/18/2005 AT: 08:33:13               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/15/2007  AT: 09:00:26        *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 02/18/2005                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvTP1   	 = 11001:1:0	(* MVP-8400 TOUCH PANEL *)
dvTP2		 = 10002:1:0	(* NXT-CV7 TOUCH PANEL  *)
dvTP3		 = 10004:1:0	
dvTP4		 = 10001:1:0	(* METREAU ENTRY COMMUNICATOR *)
dvTP5		 = 11002:1:0	(* METREAU ENTRY COMMUNICATOR *)
dvTP6		 = 11003:1:0
dvTP7		 = 10007:1:0
dvTP8		 = 10008:1:0
dvTP9		 = 10009:1:0
dvTP10		 = 10010:1:0
dvTP11		 = 10011:1:0
dvTP12		 = 10012:1:0
dvTP13		 = 10013:1:0
dvTP14		 = 10014:1:0
dvTP15		 = 10015:1:0
dvTP16		 = 10016:1:0
dvTP17		 = 10017:1:0
dvTP18		 = 10018:1:0
dvTP19		 = 10019:1:0
dvTP20		 = 10020:1:0
virtualTP   = 35000:1:0			(* dummy variable for connection purposes *)

vdvTP1		= 33001:1:0			// VIRTUAL DEVICE FOR dvTP1
vdvTP2		= 33002:1:0			// VIRTUAL DEVICE FOR dvTP2
vdvTP3		= 33003:1:0			// VIRTUAL DEVICE FOR dvTP3
vdvTP4		= 33004:1:0			// VIRTUAL DEVICE FOR dvTP4
vdvTP5		= 33005:1:0			// VIRTUAL DEVICE FOR dvTP5
vdvTP6		= 33006:1:0			// VIRTUAL DEVICE FOR dvTP6
vdvTP7		= 33007:1:0			// VIRTUAL DEVICE FOR dvTP7
vdvTP8		= 33008:1:0			// VIRTUAL DEVICE FOR dvTP8
vdvTP9		= 33009:1:0			// VIRTUAL DEVICE FOR dvTP9
vdvTP10		= 33010:1:0			// VIRTUAL DEVICE FOR dvTP10
vdvTP11		= 33011:1:0			// VIRTUAL DEVICE FOR dvTP11
vdvTP12		= 33012:1:0			// VIRTUAL DEVICE FOR dvTP12
vdvTP13		= 33013:1:0			// VIRTUAL DEVICE FOR dvTP13
vdvTP14		= 33014:1:0			// VIRTUAL DEVICE FOR dvTP14
vdvTP15		= 33015:1:0			// VIRTUAL DEVICE FOR dvTP15
vdvTP16		= 33016:1:0			// VIRTUAL DEVICE FOR dvTP16
vdvTP17		= 33017:1:0			// VIRTUAL DEVICE FOR dvTP17
vdvTP18		= 33018:1:0			// VIRTUAL DEVICE FOR dvTP18
vdvTP19		= 33019:1:0			// VIRTUAL DEVICE FOR dvTP19
vdvTP20		= 33020:1:0			// VIRTUAL DEVICE FOR dvTP20
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

#warn 'Please make sure that nMAX_TPS in the UI.axs file matches the length of your vdvTP_DPS_ARRAY and dvTP_DPS_ARRAY.'
VOLATILE DEV vdvTP_DPS_ARRAY[] =	// AN ARRAY OF VIRTUAL DEVICES
{
	virtualTP, 	vdvTP1,		vdvTP2,
	vdvTP3,		vdvTP4,		vdvTP5,
	vdvTP6,		vdvTP7,		vdvTP8,
	vdvTP9,		vdvTP10,	vdvTP11,
	vdvTP12,	vdvTP13,	vdvTP14,
	vdvTP15,	vdvTP16,	vdvTP17,
	vdvTP18,	vdvTP19,	vdvTP20
}

VOLATILE DEV dvTP_DPS_ARRAY[] =	// AN ARRAY OF TOUCH PANEL DPS ADDRESSES
{	virtualTP, 	dvTP1, 		dvTP2,
	dvTP3,		dvTP4,		dvTP5,
	dvTP6,		dvTP7,		dvTP8,
	dvTP9,		dvTP10,		dvTP11,
	dvTP12,		dvTP13,		dvTP14,
	dvTP15,		dvTP16,		dvTP17,
	dvTP18,		dvTP19,		dvTP20
}

// ALL TOUCH PANELS USE THESE CHANNEL ASSIGNMENTS.
INTEGER nCHAN_BTN[] =                   // CHANNEL BUTTONS ON TOUCH PANEL
{
	1,	// PHONE BOOK ENTRY 1
	2,	// PHONE BOOK ENTRY 2
	3,	// PHONE BOOK ENTRY 3
	4,	// PHONE BOOK ENTRY 4
	5,	// PHONE BOOK ENTRY 5
	
	6,	// PAGE ALL
	7,	// PLACE CALL
	8,	// END CALL
	9,	// CALL PRIVACY TOGGLE
	10,	// MONITORING SETTING TOGGLE
	
	11,	// MONITORABLE TOGGLE
	12,	// AUTO ANSWER TOGGLE
	13,	// PAGE UP
	14,	// PAGE DOWN
	15,	// INTERCOMM TIMEOUT DECREMENT
	
	16,	// INTERCOMM TIMEOUT INCREMENT
	17,	// INCOMING CALL - ANSWER
	18,	// INCOMING CALL - IGNORE/HANG UP
	19,	// MONITOR
	20,	// EXTEND CALL 	
	
	36,	// DOOR PRIVACY TOGGLE
	53,	// DOOR MIC LEVEL CHANNEL 
	54	// DOOR SPEAKER LEVEL CHANNEL 
}

INTEGER nDISPLAY_BTN[] =				// INDICATES PHONE BOOK ENTRY SETTINGS
{
	21,	// LIST ITEM 1 IN A CALL
	22,	// LIST ITEM 1 HAS PRIVACY ENABLED
	23,	// LIST ITEM 1 HAS MONITORABLE SET
	24,	// LIST ITEM 2 IN A CALL
	25,	// LIST ITEM 2 HAS PRIVACY ENABLED
	
	26,	// LIST ITEM 2 HAS MONITORABLE SET 
	27,	// LIST ITEM 3 IN A CALL
	28,	// LIST ITEM 3 HAS PRIVACY ENABLED
	29,	// LIST ITEM 3 HAS MONITORABLE SET 
	30,	// LIST ITEM 4 IN A CALL
	
	31,	// LIST ITEM 4 HAS PRIVACY ENABLED
	32,	// LIST ITEM 4 HAS MONITORABLE SET 
	33,	// LIST ITEM 5 IN A CALL
	34,	// LIST ITEM 5 HAS PRIVACY ENABLED
	35	// LIST ITEM 5 HAS MONITORABLE SET 
}

INTEGER nTXT_BTN[] =                    // TEXT BUTTONS ON TOUCH PANEL
{
	1,	// 1- LIST ITEM 1
	2,	// 2- LIST ITEM 2
	3,	// 3- LIST ITEM 3
	4,	// 4- LIST ITEM 4
	5,	// 5- LIST ITEM 5
	
	7,	// 6- INCOMING CALL - CONNECTED TO 
	9,	// 7- SETUP - INTERCOMM TIMEOUT
	10	// 8- CALL INFO
}
(*
INTEGER nDOOR_BTN[] =			// BUTTONS ASSOCIATED WITH THE METREAU ENTRY COMMUNICATORS
{
    260,	// 1- DOOR ANSWER CALL - ANSWER
    261,	// 2- DOOR ANSWER CALL - VIEW
    262,	// 3- DOOR ANSWER CALL - IGNORE/EXIT
    206,	// 4- DOOR SETUP - DOOR CHIME 1
    207,	// 5- DOOR SETUP - DOOR CHIME 2
    
    208,	// 6- DOOR SETUP - DOOR CHIME 3
    209,	// 7- DOOR SETUP - DOOR CHIME 4
    210,	// 8- DOOR SETUP - DOOR CHIME 5
    211,	// 9- DOOR SETUP - DOOR CHIME 6
    212,	// 10- DOOR SETUP - DOOR 1
    
    213,	// 11- DOOR SETUP - DOOR 2
    214,	// 12- DOOR SETUP - DOOR 3
    215,	// 13- DOOR SETUP - DOOR 4
    216,	// 14- DOOR SETUP - DOOR 5
    37,		// 15- DOOR SETUP - DND
    
    38,		// 16- DOORBELL ADJUSTMENTS - DOOR SPEAKER MUTE
    39,		// 17- DOORBELL ADJUSTMENTS - DOOR SPEAKER DECREMENT
    40,		// 18- DOORBELL ADJUSTMENTS - DOOR SPEAKER INCREMENT
    371,	// 19- DOORBELL ADJUSTMENTS - DOOR MIC MUTE
    372,	// 20- DOORBELL ADJUSTMENTS - DOOR MIC INCREMENT
    
    373,	// 21- DOORBELL ADJUSTMENTS - DOOR MIC DECREMENT
    41,		// 22- DOOR ANSWER CALL - END CALL
    42,		// 23- DISPLAY SETUP - GRAPHIC 1
    43,		// 24- DISPLAY SETUP - GRAPHIC 2
    44,		// 25- DISPLAY SETUP - GRAPHIC 3
    
    45,		// 26- DISPLAY SETUP - GRAPHIC 4
    46,		// 27- DISPLAY SETUP - GRAPHIC 5
    47,		// 28- DISPLAY SETUP - GRAPHIC 6
    48,		// 29- DISPLAY SETUP - DOOR 1
    49,		// 30- DISPLAY SETUP - DOOR 2
    
    50,		// 31- DISPLAY SETUP - DOOR 3
    51,		// 32- DISPLAY SETUP - DOOR 4
    52		// 33- DISPLAY SETUP - DOOR 5
}
*)

INTEGER nDOOR_LVL_BTN[] =		// LEVEL BUTTONS ASSOCIATED WITH THE METREAU ENTRY COMMUNICATORS
{
    1,		// 1- DOORBELL ADJUSTMENTS - DOOR MIC LEVEL 
    2		// 2- DOORBELL ADJUSTMENTS - DOOR SPEAKER LEVEL 
}

INTEGER nDOOR_TXT_BTN[] =		// TEXT FIELDS ASSOCIATED WITH THE METREAU ENTRY COMMUNICATORS
{
    211,	// 1- DOOR ANSWER CALL - DOOR NAME
    217,	// 2- SOMEONE AT THE DOOR - CALL FROM ''
    240,	// 3- SOMEONE AT THE DOOR - VIDEO WINDOW
    6,		// 4- DOOR ANSWER CALL - END CALL
    8,		// 5- DOOR ANSWER CALL - IGNORE/EXIT
    
    221,	// 6- DOOR SETUP - DOOR BELL 1 NAME
    225,	// 7- DOOR SETUP - DOOR BELL 2 NAME
    229,	// 8- DOOR SETUP - DOOR BELL 3 NAME
    233,	// 9- DOOR SETUP - DOOR BELL 4 NAME
    237,	// 10- DOOR SETUP - DOOR BELL 5 NAME
    
    11,		// 11- DOOR DISPLAY SETUP - GRAPHIC 1 NAME
    12,		// 12- DOOR DISPLAY SETUP - GRAPHIC 2 NAME
    13,		// 13- DOOR DISPLAY SETUP - GRAPHIC 3 NAME
    14,		// 14- DOOR DISPLAY SETUP - GRAPHIC 4 NAME
    15,		// 15- DOOR DISPLAY SETUP - GRAPHIC 5 NAME
    
    16		// 16- DOOR DISPLAY SETUP - GRAPHIC 6 NAME
}
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

DEFINE_MODULE 'AMX_Intercom_Comm' Comm(vdvTP_DPS_ARRAY,dvTP_DPS_ARRAY)
DEFINE_MODULE 'AMX_Intercom_UI' UI(vdvTP_DPS_ARRAY,dvTP_DPS_ARRAY,nCHAN_BTN,nTXT_BTN,nDISPLAY_BTN,nDOOR_BTN,nDOOR_TXT_BTN,nDOOR_LVL_BTN)
(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)