PROGRAM_NAME='Satel'
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
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

integer satMaxInputs=128;
integer satMaxZones=4;



long satTimeArray[1]={1000};

long satTMi1 = 10;
long satTMi2 = 11;
long satTMi3 = 12;
long satTMi4 = 13;

long satTMi[]={satTMi1,satTMi2,satTMi3,satTMi4};





integer SatSupportedLenght[][]= //pary typ sygnalu i dopuszczalne dlugosci
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//!!!!UWAGA!!!! przy podawaniu dlugosci krotsze wczesniej (najpier 4; pozniej 5)!!!!!!!!
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
{
    {$00,4,5},
    {$01,4,5},
    {$02,4,5},
    {$03,4,5},
    {$04,4,5},
    {$05,4,5},
    {$06,4,5},
    {$07,4,5},
    {$08,4,5},
    {$09,4,5},
    {$0A,4,5},
    {$0B,4,5},
    {$0C,4,5},
    {$0D,4,5},
    {$0E,4,5},
    {$0F,4,5},
    {$10,4,5},
    {$11,4,5},
    {$12,4,5},
    {$13,4,5},
    {$14,4,5},
    {$15,4,5},
    {$16,4,5},
    {$17,4},
    {$18,4,5},
    {$19,4},
    {$1A,4,7} //pozostale jesli trzeba
}


integer satWiz[][]={ //pary join czujki i jego join na wiz (mozliwe powturzenia)
    {22,60}, //O kuchnia
    {44,61}, //O jadalnia
    {44,62}, //O salonD
    {43,63}, //D wejsciowe
    {34,64}, //O garaz 1
    {34,65}, //O garaz 2
    {38,66}, //Brama garaz blizej
    {37,67}, //Brama garaz dalej
    //{,67}, //Brama wjazdowa
    {33,68}, //O garaz 3
    {33,69}, //O garaz 4
    {39,70}, //O pralnia
    {41,71}, //O lazienkaD
    {20,72}, //O sypialnia
    {31,81}, //O salonG
    {25,82}, //O Kacper
    {31,83}, //O korytarzG
    {29,84}, //O lazienkaG
    {27,85}, //O pokGosci
    {27,86}, //O pokGosci2
    {31,87}, //O salonG taras
    
    {21,91}, //R sypialnia
    {42,92}, //R lazienkaD
    {45,93}, //R salonD
    {23,94}, //R kuchnia
    {36,95}, //R garaz
    {26,96}, //R kacper
    {32,97}, //R salonG
    {32,98}, //R salonG 2
    {30,99}, //R lazienkaG
    {28,100} //R fitness
}


integer satZones[][]= //pary join strefy Satel i numer zaznaczenia strefy
{
    {1,150},
    {2,154},
    {3,158},
    {4,200}
}


integer joinRolUP = 49;
integer joinRolDWN = 50;

integer satelWagoJoins[][]= //pary joinów input Satel; odpowiadajacy mu joiny WAGO
{
    {20,54},
    {22,55},
    {25,56},
    {27,57},
    {29,58},
    {31,59},
    {41,60},
    {44,61},
    {43,63}
}

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCT bCzuj{
    integer viol
    integer tamper
    integer alarm
    integer tamperAlarm
    integer alarmMemory
    integer tamperAlarmMemory
    integer bypass
    integer noVoilationTrouble
    integer longViolationTrouble
}

STRUCT Czujka{
    integer stat
    integer trouble
    bCzuj z
}

STRUCT bStrefa{
    integer armed
    integer realyArmed
    integer entryTime
    integer exitTimeLong
    integer exitTimeShort
    integer alarm
    integer fire
    integer alarmMemory
    integer fireMemory
    integer firstCode
    integer tempBlocked
    integer gouardRound
    integer armingModeII
    integer armingModeIII
}

STRUCT Strefa{
    integer armed
    integer alarm
    bStrefa z;

}



(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile char bSatel[1500];
volatile integer ErrorSatelProtocolType;
volatile integer ErrorSatelBufferOwerflow;

volatile Czujka satInput[satMaxInputs];
volatile Strefa satStrefy[satMaxZones];

//timeline


volatile integer waitCount1;
volatile char testStr[100];

volatile char satCode[20]; 

volatile integer varRolUP;
volatile integer varRolDWN;


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



DEFINE_CALL 'SatSend' (char str[]){
    stack_var char xorCr;
    stack_var char Cr;
    stack_var integer k;
    
    stack_var char tStr[100];
    
    xorCR=0;
    for (k=1;k<=length_string(str);k++){
	xorCr=xorCr BXOR str[k];
    }
    
    
    str="str,xorCr";

    Cr=0;
    for (k=1;k<=length_string(str);k++){
	Cr=Cr + str[k];
    }
    
    str="$FF,$FF,str,Cr,$FF,$AA";
    
    send_string dvSatel,"str";
    
    /*
    tStr='';
    for (k=1;k<=length_string(str);k++){
	tStr="tStr,' 0x',itohex(str[k])";
    }
    send_string 0,"'Wys³ane do Satela: ',tStr";
    */
}
/*
DEFINE_FUNCTION char[100] satXor (char str[]){
    stack_var integer k;
    stack_var char cr;
    stack_var char tStr[100];    
    cr=$00;
    
    for (k=1;k<=length_string(str);k++){
	cr=cr XOR str[k];
    }
    tStr="str,cr";
    
    return tStr;

}
*/

DEFINE_CALL 'satRecive' (char str[]){
    stack_var char cmd;
    stack_var char tStr[100];
    stack_var integer k;
    
    cmd=str[1];

    select {
	active ($00<=cmd && cmd<=$11):{
	    call 'satRecInput'(str);
	}
	active ($12<=cmd && cmd<=$1A):{
	    call 'satRecStrefa'(str);
	}
	active ($54<=cmd && cmd<=$5F):{
	    call 'satRecMain'(str);
	}
	active (true):{
	    tStr='';
	    for (k=1;k<=length_string(str);k++){
		tStr="tStr,' 0x',itohex(str[k])"
	    }
	    send_string 0,"'WARNING: Satel nie uwzglednione s³owo: ',tStr,'xx'";
	}
    }
}

DEFINE_FUNCTION integer Flg (integer pos, integer chr){
    stack_var integer flgg;
    
    flgg=(chr>>(pos-1))&1;
    
    return(flgg);
}

DEFINE_CALL 'satRecInput' (char str[]){
    stack_var char cmd;
    stack_var integer shift;
    stack_var integer join;
    stack_var integer state;
    
    stack_var integer k;
    stack_var integer m;
    
    stack_var char tStr[50];
    stack_var integer n;
    cmd=str[1];
    
    shift=((cmd % 2) * 32);
    
    shift = shift + (64 * (length_string(str) - 5) );
    
    cmd=cmd/2;
    //send_string 0,"'Satel Input: ',itoa(shift),' cmd: 0x',itohex(cmd),' len: ',itoa(length_string(str))"; 
    //same o dlugosci 5, jeszcze strawdzic dlaczemu nie dluzsze
    
    for (m=2;m<=5;m++){
	for (k=1;k<=8;k++){
	    state = Flg(k,str[m]);
	    join = shift + ( (m-2) * 8 ) + k
	    if (join > satMaxInputs){
		break;
	    }
	    
	    switch (cmd){
		case 0 :{
		    satInput[join].z.viol=state;
		}
		case 1 :{
		    satInput[join].z.tamper=state;
		}
		case 2 :{
		    satInput[join].z.alarm=state;
		}
		case 3 :{
		    satInput[join].z.tamperAlarm=state;
		}
		case 4 :{
		    satInput[join].z.alarmMemory=state;
		}
		case 5 :{
		    satInput[join].z.tamperAlarmMemory=state;
		}
		case $6 :{
		    satInput[join].z.bypass=state;
		}
		case 7 :{
		    satInput[join].z.noVoilationTrouble=state;
		}
		case 8 :{
		    satInput[join].z.longViolationTrouble=state;
		}
	    }
	    
	    call 'satImputUpdate' (join);
	    
	    //send_string 0,"'SATEL join: ',itoa(join)";
	    
	    /*TESTY
	    if (join=29){
		#warn 'Sprawdzanie czujek'
		tStr='';
		for (n=1;n<=length_string(str);n++){
		    tStr="tStr,' 0x',itohex(str[n])"
		}
	    
		
		send_string 0,"'SAT join: ', itoa(join)";
		send_string 0,"'SAT str: ', tStr";
		
		
		send_string 0,"'SAT state:                ', itoa(satInput[join].stat)";
		send_string 0,"'SAT trouble:              ', itoa(satInput[join].trouble)";
		send_string 0,"'SAT alarm:                ', itoa(satInput[join].z.alarm)";
		send_string 0,"'SAT alarmMemory:          ', itoa(satInput[join].z.alarmMemory)";
		send_string 0,"'SAT bypass:               ', itoa(satInput[join].z.bypass)";
		send_string 0,"'SAT longViolationTrouble: ', itoa(satInput[join].z.longViolationTrouble)";
		send_string 0,"'SAT noVoilationTrouble:   ', itoa(satInput[join].z.noVoilationTrouble)";
		send_string 0,"'SAT tamper:               ', itoa(satInput[join].z.tamper)";
		send_string 0,"'SAT tamperAlarm:          ', itoa(satInput[join].z.tamperAlarm)";
		send_string 0,"'SAT tamperAlarmMemory:    ', itoa(satInput[join].z.tamperAlarmMemory)";
		send_string 0,"'SAT viol:                 ', itoa(satInput[join].z.viol)";
	    }
	    */
	    
	    
	    call 'satSMS-y' (join);
	    
	}
	
	if (join > satMaxInputs){
	    break;
	}
    }
    

}


DEFINE_CALL 'satImputUpdate' (integer join){
    if (satInput[join].z.viol 
    || satInput[join].z.alarm
    || satInput[join].z.tamper
    || satInput[join].z.tamperAlarm){
	satInput[join].stat=1;
    }
    else{
	satInput[join].stat=0;
    }
    
    
    if (satInput[join].z.alarm
    || satInput[join].z.alarmMemory
    || satInput[join].z.tamper
    || satInput[join].z.tamperAlarm
    || satInput[join].z.tamperAlarmMemory
    || satInput[join].z.longViolationTrouble
    || satInput[join].z.noVoilationTrouble){
	satInput[join].trouble=1;
    }
    else{
	satInput[join].trouble=0;
    }
}

DEFINE_CALL 'satSMS-y'(integer join){
    stack_var char str[100];
    stack_var integer n;
    
    if (join = joinRolUP){
	
	if (satInput[join].stat<>varRolUP){
	    varRolUP=satInput[join].stat;
	    
	    send_string 0,"'SATEL: rolUP state: ',itoa(varRolUP)";
	    
	    if (varRolUP){
	        
		for (n=1;n<=max_length_array(brRolSetTP1);n++){
		    if (length_string(str)>0){
			str="str,'_',itoa(brRolSetTP1[n][1])"
		    }
		    else{
			str="itoa(brRolSetTP1[n][1])"
		    }
		}
		call 'brRolUP' (str);
		
		send_string 0,"'brRolUP ',str";
		
	    }
	}
    }
    
    if (join = joinRolDWN){
	
	if (satInput[join].stat<>varRolDWN){
	    varRolDWN=satInput[join].stat;	 
	    
	    send_string 0,"'SATEL: rolDWN state: ',itoa(varRolDWN)";

	    if (varRolDWN){
	        
		for (n=1;n<=max_length_array(brRolSetTP1);n++){
		    if (length_string(str)>0){
			str="str,'_',itoa(brRolSetTP1[n][1])"
		    }
		    else{
			str="itoa(brRolSetTP1[n][1])"
		    }
		}
		call 'brRolDWN' (str);
		
		send_string 0,"'brRolUP ',str";
	    }
	}
    }
    
}



DEFINE_CALL 'satRecStrefa' (char str[]){
    stack_var integer cmd;
    stack_var integer lng;
    stack_var integer state;
    stack_var integer join;
    
    stack_var integer k;
    stack_var integer m;
    
    lng = length_string(str) - 1;
    cmd= str[1];
   
    for (m=2;m<=5;m++){
	for (k=1;k<=8;k++){
	    state = Flg(k,str[m]);
	    join = ( (m-2) * 8 ) + k
	    
	    if (join > satMaxZones){
		break;
	    }
	    
	    switch (cmd){
		case $12 :{
		    if ( lng= 4){
			satStrefy[join].z.armed=state;
		    } else if (lng = 5){
			satStrefy[join].z.realyArmed=state;
		    }
		}
		case $13 :{
		    if ( lng= 4){
			satStrefy[join].z.entryTime=state;
		    } else if (lng = 5){
			satStrefy[join].z.tempBlocked=state;
		    }
		}
		case $14 :{
		    if ( lng= 4){
			satStrefy[join].z.exitTimeLong=state;
		    } else if (lng = 5){
			satStrefy[join].z.gouardRound=state;
		    }
		}
		case $15 :{
		    if ( lng= 4){
			satStrefy[join].z.exitTimeShort=state;
		    } else if (lng = 5){
			satStrefy[join].z.armingModeII=state;
		    }
		}
		case $16 :{
		    if ( lng= 4){
			satStrefy[join].z.alarm=state;
		    } else if (lng = 5){
			satStrefy[join].z.armingModeIII=state;
		    }
		}
		case $17 :{
		    satStrefy[join].z.fire=state;
		}
		case $18 :{
		    satStrefy[join].z.alarmMemory=state;
		}
		case $19 :{
		    satStrefy[join].z.fireMemory=state;
		}
		case $1A :{
		    satStrefy[join].z.firstCode=state;
		}
	    }
	    
	    call 'satStrefaUpdate' (join);
	    
	}
	
	if (join > satMaxZones){
	    break;
	}
    }
} 



DEFINE_CALL 'satStrefaUpdate' (join){
    stack_var integer k;

    if (join<=satMaxZones){
	if (satStrefy[join].z.fire
	|| satStrefy[join].z.alarm){
	    satStrefy[join].alarm=1;
	    
	    if (!(timeline_active(satTMalarm[join]))){
		TIMELINE_CREATE(satTMalarm[join], satTimelineAlarmArray,1, TIMELINE_RELATIVE, TIMELINE_REPEAT);
	    }
	}
	else{
	    satStrefy[join].alarm=0;
	    
	    if (timeline_active(satTMalarm[join])){
		TIMELINE_KILL(satTMalarm[join]);
	    }
	}
	
	if (satStrefy[join].z.armingModeII
	|| satStrefy[join].z.armingModeIII
	|| satStrefy[join].z.entryTime
	|| satStrefy[join].z.exitTimeLong
	|| satStrefy[join].z.exitTimeShort){
	    
	    if (!(timeline_active(9+join))){
		TIMELINE_CREATE(satTMi[join], satTimeArray,1, TIMELINE_RELATIVE, TIMELINE_REPEAT);
	    }
	}
	else{
	
	    if (timeline_active(satTMi[join])){
		TIMELINE_KILL(satTMi[join]);
	    }
	}
	
	    
	if (satStrefy[join].z.armed
	|| satStrefy[join].z.realyArmed){
	    
	    satStrefy[join].armed=1;
	}
	else{
	    
	    satStrefy[join].armed=0;
	}
	
	
	
	if (!(timeline_active(satTMi[join]))){
	    [dvTPalarm,satZones[join][2]+1]=satStrefy[join].armed;
	}
	
    }
}

DEFINE_CALL 'satRecMain' (char str[]){
    
}


DEFINE_CALL 'satPassCreate' (char code[],integer arm){
    stack_var integer i;
    stack_var integer k;
    stack_var integer m;
    
    
    stack_var char strr[13];	
    
    //stack_var char tStr[100];
    
    strr='nnnnnnnnnnnn';  // dwanascie znaków aby u³atwiæ dodawanie
    
    k=0;
    for (i=1;i<=length_string(code);i++){
	
	k++;
	
	if (k%2=1){
	    strr[(k/2)+1]=atoi("code[i]")*16;
	}
	else{
	    strr[(k/2)]=strr[(k/2)]+atoi("code[i]");
	}
    }
    
    if (k%2=1){
	strr[(k/2)+1]=strr[(k/2)+1]+$A;
    }
    else{
	strr[(k/2)+1]=$AA;
    }
    
    for (i=(k/2)+2;i<=8;i++){
	strr[i]=$AA;
    }
    
    strr[9]=$00;
    strr[10]=$00;
    strr[11]=$00;
    strr[12]=$00;
    
    for (k=1;k<=length_array(satZones);k++){
	if ([dvTPalarm,satZones[k][2]]>0){
	
	    strr[(satZones[k][1]/8) + 9] = strr[(satZones[k][1]/8) + 9] BOR ( 1 << (( satZones[k][1] MOD 8 )-1 ));
	}
    }
    
    if (arm){
	strr="strr,$00";
    }
    
    /* TESTY
    send_string 0,"'CODE len: ',length_string(strr)";
    
    tStr='';
    for (k=1;k<=length_string(strr);k++){
	tStr="tStr,' 0x',itohex(strr[k])";
    }
    
    send_string 0,"'CODE : ',tStr";
    */
    
    if (arm){
	call 'SatSend' ("$80,strr");
    } else {
	call 'SatSend' ("$84,strr");
    }
}



DEFINE_START

set_length_array (satInput,satMaxInputs);
set_length_array (satStrefy,satMaxZones);

CREATE_BUFFER  dvSatel,bSatel;


TIMELINE_CREATE (satelWagoTMID,satelWagoTM,length_array(satelWagoTM),TIMELINE_RELATIVE,TIMELINE_REPEAT);
//set_virtual_level_count (dvTPtemp,61);
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)

DEFINE_EVENT


data_event [dvSatel]{
    ONLINE:{
	SEND_COMMAND dvSatel,"'SET BAUD 4800,N,8,1, 485 Disable'";
    }
    STRING:{
	
	if (find_string(data.text,"$FF,$FF",1)){
	    //send_string dvSatel,"$FF,$FF,$01,$02,$03,$04,$05,$01,$10,$FF,$AA";
	    
	    ErrorSatelProtocolType++;
	    send_string 0,"'WARNING: wykryto blod protokolu Satela nr: ',itoa(ErrorSatelProtocolType)";
	    send_string 0,"'WARNING: text: ',data.text";
	}
    }
}

TIMELINE_EVENT [satTMi1]{
    stack_var integer statButton;
    statButton=satZones[1][2]+1; //lewy wskaznik odpowiada za zone
    
    if ([dvTPalarm,statButton]){
	[dvTPalarm,statButton]=0;
    } else {
	[dvTPalarm,statButton]=1;
    }
}
TIMELINE_EVENT [satTMi2]{
    stack_var integer statButton;
    statButton=satZones[2][2]+1; //lewy wskaznik odpowiada za zone
    
    if ([dvTPalarm,statButton]){
	[dvTPalarm,statButton]=0;
    } else {
	[dvTPalarm,statButton]=1;
    }
}

TIMELINE_EVENT [satTMi3]{
    stack_var integer statButton;
    statButton=satZones[3][2]+1; //lewy wskaznik odpowiada za zone
    
    if ([dvTPalarm,statButton]){
    [dvTPalarm,statButton]=0;
    } else {
	[dvTPalarm,statButton]=1;
    }
}





//porównywanie i aktualizowanie stanu zmiennych wejsc Saatela na WAGO 
TIMELINE_EVENT [satelWagoTMID]{ 
    

    integer sat;
    integer wgo;
    integer k;
   
    for (k=1;k<=length_array(satelWagoJoins);k++){
	sat=satelWagoJoins[k][1];
	wgo=satelWagoJoins[k][2];
	
	if (satInput[sat].stat<>brDigState[wgo]){
	
	    send_string 0,"'event satelWagoTM joinWAGO: ',itoa(wgo),' joinSatel ',itoa(sat), ' stat: ',itoa(satInput[sat].stat)";
	    
	    if (satInput[sat].stat){
		call 'brDigON' (itoa(wgo));
	    } else {
		call 'brDigOFF' (itoa(wgo));	
	    }
	    break;
	}
    }
    
}

button_event [dvTPalarm,40]
button_event [dvTPalarm,41]
button_event [dvTPalarm,42]
button_event [dvTPalarm,43]
button_event [dvTPalarm,44]
button_event [dvTPalarm,45]
button_event [dvTPalarm,46]
button_event [dvTPalarm,47]
button_event [dvTPalarm,48]
button_event [dvTPalarm,49]{ //klawiatura
    PUSH:{
	stack_var integer k;
	stack_var char str[10];
	
	//satCode=satCode*10+button.input.channel-40;
	satCode="satCode,itoa(button.input.channel-40)";
	str='';
	for (k=1;k<=length_string(satCode);k++){
	    str="str,'*'";
	}
	
	SEND_COMMAND dvTPalarm,"'^TXT-51,0,',str";	
    }
}

button_event [dvTPalarm,50]{ //cofnij
    push:{
	stack_var integer k;
	stack_var char str[10];
	
	if ( length_string(satCode)>0 ) {
	    satCode=left_string(satCode,length_string(satCode)-1);
	}
	
	
	str='';
	for (k=1;k<=length_string(satCode);k++){
	    str="str,'*'";
	}
	
	SEND_COMMAND dvTPalarm,"'^TXT-51,0,',str";	
	
    }
}


button_event [dvTPalarm,52]{ //Koduj
    PUSH:{
	call 'satPassCreate' (satCode,1);
	satCode='';
	
	SEND_COMMAND dvTPalarm,"'^TXT-51,0, '";
    }
}
button_event [dvTPalarm,51]{ //Rozkoduj
    PUSH:{
	call 'satPassCreate' (satCode,0);
	satCode='';
	
	SEND_COMMAND dvTPalarm,"'^TXT-51,0, '";
    }
}

button_event [dvTPalarm,150]
button_event [dvTPalarm,154]
button_event [dvTPalarm,158]{ //zaznaczanie stref do kodowania

    push:{
	stack_var k;
	
	k=button.input.channel;
	    
	if ([dvTPalarm,k]){
	    [dvTPalarm,k]=0;
	}
	else{
	    [dvTPalarm,k]=1;
	}
    }
}


button_event [dvTPalarm,66]{ //bramam garazowa 2
    push:{
	CALL 'brDigON' ("'48'")
	if (TIMELINE_ACTIVE(1)){
	    TIMELINE_KILL(1);
	}
	wait 7{
	    CALL 'brDigOFF' ('46_47_48')	
	}
    
    }
}
button_event [dvTPalarm,67]{ //bramam garazowa 1
    push:{
	CALL 'brDigON' ("'45'")
	if (TIMELINE_ACTIVE(1)){
	    TIMELINE_KILL(1);
	}
	wait 7{
	    CALL 'brDigOFF' ('46_47_48')	
	}
    
    }
}


