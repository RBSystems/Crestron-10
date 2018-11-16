PROGRAM_NAME='Nowak'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
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

DEFINE_DEVICE
//dvSystem	=	0:0:0; 

dvTPmain	=	10001:1:0;
dvTPmainIR	=	10001:3:0;
dvTPalarm	=	10001:4:0;
dvTPbramka	=	10001:19:0;
dvTPdig		=	10001:20:0;
dvTProl		=	10001:23:0;
dvTPdim		=	10001:22:0;
dvTPtemp	=	10001:21:0;
dvTPsceny	=	10001:24:0;
dvTPrgb		=	10001:10:0;
dvTPmr		=	10001:15:0;
dvTPmrSource	=	10001:16:0;

vdvTPbramka	=	33000:19:0;
vdvTPdig	=	33000:20:0;
vdvTProl	=	33000:23:0;
vdvTPdim	=	33001:22:0;
vdvTPtemp	=	33001:21:0;
vdvTPsceny	=	33001:24:0;
vdvTPrgb	=	33001:10:0;


dvTPecom	=	10001:5:0;
//dvEcomBrama	=	10010:1:0;
//dvEcomBramaIO	=	10010:2:0;
//dvEcomBramaRelay=	10010:3:0;

vdvTP		=	33000:1:0;
vdvTPecom	=	33001:5:0;
///vdvEcomBrama	=	33010:1:0;

VIRTUALKEYPAD	= 	41001:1:0;

dvSC		=	5001:1:0;	//RS_1
dvMarantz	=	5001:2:0;	//RS_2
dvProj		=	5001:3:0;	//RS_3

dvSatel		=	5001:4:0;	//RS_4
dvRejestrator	=	5001:6:0;	//RS_6

dvIrKlimaGora	=	5001:9:0;	//IR_1
dvIrKlimaDol	=	5001:10:0;	//IR_2
dvIrSamsug	=	5001:11:0;	//IR_3
dvIrMarantz	=	5001:12:0;	//IR_4
dvIrBluRay	=	5001:13:0;	//IR_5
dvIrSerwer	=	5001:14:0;	//IR_6
dvIrDreamBox	=	5001:15:0;	//IR_7

dvIrNowe	=	5001:16:0;	//IR_8 TEMP
 
dvInputs	=	5001:17:0;	//Wejscia

dvClientWAGO	=	0:FIRST_LOCAL_PORT:0;






(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

long panelTM_ID = 7;


LONG panelTM_arr[]={100000};



(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
volatile integer kk;

PERSISTENT INTEGER RGBpreset[5][5][3];

volatile integer varKacper;


(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)

INCLUDE 'MultiRoom';
INCLUDE 'BramkaWAGO';
    //INCLUDE 'Ecom'; //przaeniesiony do MultiRoom ze wzgledu na zakres zmiennych
INCLUDE 'RGB';
INCLUDE 'PTZ';
INCLUDE 'Satel2';
INCLUDE 'VirtualKeypad';

DEFINE_START


TIMELINE_CREATE (panelTM_ID,panelTM_arr,length_array(panelTM_arr),TIMELINE_RELATIVE,TIMELINE_REPEAT);


//dodanie zewnetrznego linka do VCN dla 
SEND_COMMAND 0:1:0,"'G4WC "MVP 5200i zewnetrzna",89.174.35.12,5024,1'";


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT [panelTM_ID]{

    SEND_COMMAND dvTPmain,"'?BCT-92,1'"
    send_string 0,"'Panel Event'";
}




button_event [dvTPmain,100]{ //wolanie Kacpra na glownej stronie
    push:{
    
	varKacper=brDigState[38];
	
	if (varKacper){
	    call 'brDigOFF' ("'38'");
	    send_string 0,"'MAIN OFF ',itoa(varKacper)";
	} else {
	    call 'brDigON' ("'38'");		
	    send_string 0,"'MAIN ON ',itoa(varKacper)";
	}
	
	wait 10{
	    if (varKacper){
		call 'brDigON' ("'38'");
	    send_string 0,"'MAIN OFF ',itoa(varKacper)";
	    } else {
		call 'brDigOFF' ("'38'");			
	    send_string 0,"'MAIN ON ',itoa(varKacper)";
	
	    }
	}
	wait 20{
	    if (varKacper){
		call 'brDigOFF' ("'38'");
	    send_string 0,"'MAIN OFF ',itoa(varKacper)";
	    } else {
		call 'brDigON' ("'38'");	
	    send_string 0,"'MAIN ON ',itoa(varKacper)";	
	    }
	}
	wait 30{
	    if (varKacper){
		call 'brDigON' ("'38'");
	    send_string 0,"'MAIN ON ',itoa(varKacper)";
	    } else {
		call 'brDigOFF' ("'38'");	
	    send_string 0,"'MAIN OFF ',itoa(varKacper)";	
	    }
	}
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

INCLUDE 'SatelPRG2';
INCLUDE 'MultoRoomPRG';
INCLUDE 'RGBprg'

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

