PROGRAM_NAME='VirtualKeyPad'
					(***********************************************************)
					(*                                                         *)
					(*             AMX Virtual Keypad ME  (1.0.0)              *)
					(*                                                         *)
					(***********************************************************)
//***********************                                         ***********************
//***********************                                         ***********************
//***********************                                         ***********************

//THE FOLLOWING NETLINX CODE IS TO BE USED ONLY AS SAMPLE CODE NOT AS A FINISHED PRODUCT.
//THE FOLLOWING NETLINX CODE IS TO BE USED ONLY AS SAMPLE CODE NOT AS A FINISHED PRODUCT.
//THE FOLLOWING NETLINX CODE IS TO BE USED ONLY AS SAMPLE CODE NOT AS A FINISHED PRODUCT.

//***********************                                         ***********************
//***********************                                         ***********************
//***********************                                         ***********************
//# Legal Notice :
//#    Copyright, AMX LLC, 2006-2009
//#    Private, proprietary information, the sole property of AMX LLC.  The
//#    contents, ideas, and concepts expressed herein are not to be disclosed
//#    except within the confines of a confidential relationship and only
//#    then on a need to know basis.
//#
//#    Any entity in possession of this AMX Software shall not, and shall not
//#    permit any other person to, disclose, display, loan, publish, transfer
//#    (whether by sale, assignment, exchange, gift, operation of law or
//#    otherwise), license, sublicense, copy, or otherwise disseminate this
//#    AMX Software.
//#
//#    This AMX Software is owned by AMX and is protected by United States
//#    copyright laws, patent laws, international treaty provisions, and/or
//#    state of Texas trade secret laws.
//#
//#    Portions of this AMX Software may, from time to time, include
//#    pre-release code and such code may not be at the level of performance,
//#    compatibility and functionality of the final code. The pre-release code
//#    may not operate correctly and may be substantially modified prior to
//#    final release or certain features may not be generally released. AMX is
//#    not obligated to make or support any pre-release code. All pre-release
//#    code is provided "as is" with no warranties.
//#
//#    This AMX Software is provided with restricted rights. Use, duplication,
//#    or disclosure by the Government is subject to restrictions as set forth
//#    in subparagraph (1)(ii) of The Rights in Technical Data and Computer
//#    Software clause at DFARS 252.227-7013 or subparagraphs (1) and (2) of
//#    the Commercial Computer Software Restricted Rights at 48 CFR 52.227-19,
//#    as applicable.
//####
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
//The following Constants define the button label text which will
//appear on the Virtual Keypad
DEFINE_CONSTANT
BUTTON1 =  'Rol. UP'
BUTTON2 =  'Kon. Okna'
BUTTON3 =  ''
BUTTON4 =  'Rol. DWN'
BUTTON5 =  'Kon. Rol.'
BUTTON6 =  'Komfort '
BUTTON7 =  'Garaz'
BUTTON8 =  'Czujki Sr'
BUTTON9 =  'Zamykam'
BUTTON10 = ''
BUTTON11 = 'Brama' 
BUTTON12 = 'Anty Freez'

//The following array hold the button numbers for each button
//on the Virtual Keypad
integer BTNS[] =
{
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12
}
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
//to prevent runaway ramping
integer ramp_timeout	
volatile integer czujkiKNX;

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
DEFINE_MODULE 'VirtualKeypad_dr1_0_0' VKP(VIRTUALKEYPAD, VIRTUALKEYPAD)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT [VIRTUALKEYPAD]
{
    //The following online event updates the initial display on
		//the text window as well as the button text which are defined above.
		online:
    {
			send_command VIRTUALKEYPAD, "'LINETEXT1-'"
			send_command VIRTUALKEYPAD, "'LINETEXT2-AMX'"
			send_command VIRTUALKEYPAD, "'LINETEXT3-'"
			send_command VIRTUALKEYPAD, "'LABEL1-',BUTTON1"
			send_command VIRTUALKEYPAD, "'LABEL2-',BUTTON2"
			send_command VIRTUALKEYPAD, "'LABEL3-',BUTTON3"
			send_command VIRTUALKEYPAD, "'LABEL4-',BUTTON4"
			send_command VIRTUALKEYPAD, "'LABEL5-',BUTTON5"
			send_command VIRTUALKEYPAD, "'LABEL6-',BUTTON6"
			send_command VIRTUALKEYPAD, "'LABEL7-',BUTTON7"
			send_command VIRTUALKEYPAD, "'LABEL8-',BUTTON8"
			send_command VIRTUALKEYPAD, "'LABEL9-',BUTTON9"
			send_command VIRTUALKEYPAD, "'LABEL10-',BUTTON10"
			send_command VIRTUALKEYPAD, "'LABEL11-',BUTTON11" 
			send_command VIRTUALKEYPAD, "'LABEL12-',BUTTON12"
    }
}

//The following are button events for each button on the Virtual Keypad
//This code is executed when the corresponding button is pushed
//Add the necessary code to a button case to implement your desired action
button_event [VIRTUALKEYPAD,1]{ //RolUP
    PUSH:{
    
	stack_var char k;
	stack_var char str[100];
	   
	for (k=1;k<=max_length_array(brRolSetTP1);k++){
	    if (length_string(str)>0){
		str="str,'_',itoa(brRolSetTP1[k][1])"
	    }
	    else{
		str="itoa(brRolSetTP1[k][1])"
	    }
	}
	
	CALL 'brRolUP' (str)
	
	ON [VIRTUALKEYPAD,1];
    }
    release:{
	OFF [VIRTUALKEYPAD,1];
    }
}
button_event [VIRTUALKEYPAD,4]{ //RolUP
    Push:{
    
	stack_var char k;
	stack_var char str[100];
	   
	for (k=1;k<=max_length_array(brRolSetTP1);k++){
	    if (length_string(str)>0){
		str="str,'_',itoa(brRolSetTP1[k][1])"
	    }
	    else{
		str="itoa(brRolSetTP1[k][1])"
	    }
	}
	
	CALL 'brRolDWN' (str)
	
	
	ON [VIRTUALKEYPAD,4];
    }
    release:{
	OFF [VIRTUALKEYPAD,4];
    }
}
button_event [VIRTUALKEYPAD,7]{ //Garaz
    Push:{
	CALL 'brDigON' ("'48'")
	if (TIMELINE_ACTIVE(1)){
	    TIMELINE_KILL(1);
	}
	wait 7{
	    CALL 'brDigOFF' ('46_47_48')	
	}
	
	ON [VIRTUALKEYPAD,7];
    }
    release:{
	OFF [VIRTUALKEYPAD,7];
    }
}
button_event [VIRTUALKEYPAD,11]{ //Brama
    Push:{
	CALL 'brDigON' ("'46'")
	if (TIMELINE_ACTIVE(1)){
	    TIMELINE_KILL(1);
	}
	wait 7{
	    CALL 'brDigOFF' ('46_47_48')	
	}
	
	ON [VIRTUALKEYPAD,7];
    }
    release:{
	OFF [VIRTUALKEYPAD,7];
    }
}
button_event [VIRTUALKEYPAD,2]{ //Kon Okna
    Push:{
	//nic
    }
}
button_event [VIRTUALKEYPAD,5]{ //Kon Rolety
    Push:{
	//nic
    }
}
button_event [VIRTUALKEYPAD,8]{ //Czujki Srodek
    Push:{
	//nic
    }
}

//button_event [VIRTUALKEYPAD,3]
button_event [VIRTUALKEYPAD,6]
button_event [VIRTUALKEYPAD,9]
button_event [VIRTUALKEYPAD,12]{ //Tryby Globalne 
    Push:{
	stack_var integer trb;
	    
	switch (button.input.channel){
	    case 6:{
		trb=1; //Komfort
	    }
	    case 9:{
		trb=5; //Zamknij
	    }
	    case 12:{
		trb=4; //AntyFreez
	    }
	}
	
	call 'brTrybGlobSEND' (trb);
    }
}




(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


[VIRTUALKEYPAD,10]=brDigState[45]; //FB z bramy wjazdowej
[VIRTUALKEYPAD,7]=satInput[38].stat; //FB z garaz

czujkiKNX = brDigState[65];
if (czujkiKNX // FB z czuje w domu
    or satInput[10].stat
    or satInput[11].stat
    or satInput[12].stat
    or satInput[13].stat
    or satInput[14].stat
    or satInput[14].stat
    or satInput[16].stat
    or satInput[17].stat
    or satInput[18].stat
    or satInput[19].stat){
	on [VIRTUALKEYPAD,8];
} else {
	off [VIRTUALKEYPAD,8];
}


if (satInput[21].stat  // FB z rolet
    or satInput[42].stat
    or satInput[45].stat
    or satInput[23].stat
    or satInput[36].stat
    or satInput[26].stat
    or satInput[32].stat
    or satInput[30].stat
    or satInput[28].stat){
	on [VIRTUALKEYPAD,5];
} else {
	off [VIRTUALKEYPAD,5];
}


if (satInput[22].stat  // FB z okien
    or satInput[44].stat
    or satInput[43].stat
    or satInput[34].stat
    or satInput[33].stat
    or satInput[39].stat
    or satInput[41].stat
    or satInput[20].stat
    or satInput[31].stat
    or satInput[29].stat
    or satInput[27].stat
    or satInput[31].stat){
	on [VIRTUALKEYPAD,2];
} else {
	off [VIRTUALKEYPAD,2];
}
