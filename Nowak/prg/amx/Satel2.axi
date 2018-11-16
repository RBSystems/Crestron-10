PROGRAM_NAME='Satel2'
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
integer satMaxZones=3;

LONG satTimeArray[1]={1000};
long satTMi1 = 10;
long satTMi2 = 11;
long satTMi3 = 12;
long satTMi4 = 13;

long satTMi[]={satTMi1,satTMi2,satTMi3,satTMi4};


LONG satelWagoTM[]={1000};
INTEGER satelWagoTMID=30;


long satTMalarm1 = 16;
long satTMalarm2 = 17;
long satTMalarm3 = 18;
long satTMalarm[]={satTMalarm1,satTMalarm2,satTMalarm3};
long satTimelineAlarmArray[1]={3000};
char satSwiatlaAlarmowe[]='70_71_72_73';

INTEGER satelKolejkaWazne[]={
    $02,
    $09,
    $0A,
    $0E,
    $0F,
    $10
}

INTEGER satelKolejkaMalo[]={	
    $01,
    $03,
    $04,
    $05,
    $06,
    $07,
    $08,
    $0B,
    $0C,
    $11,
    $12,
    $13,
    $14,
    $15,
    $16
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

volatile integer waitCount1;
volatile char testStr[100];

volatile char satCode[20]; 

volatile integer varRolUP;
volatile integer varRolDWN;

volatile integer satelRecSemafor;
volatile integer satelSendSemafor;

volatile integer satKolViol;
volatile integer satKolWaz;
volatile integer satKolMalo;


volatile char satelToSend[100];

volatile char strr[13];




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


define_function integer SatelFindStart (integer position, char buffer[]){
    stack_var sinteger k;
    stack_var char startStr[2];
    
    for (k=position - 2;k>0;k--){
	startStr="buffer[k],buffer[k+1]";
	if (startStr="$FE,$FE"){
	    return (k);
	}
    }
    return 0;
}


define_function integer rotateLeft (integer byte){
    stack_var integer returnByte;
    
    if (Flg(16,byte)=1){
	returnByte = (byte << 1) | 1; 
    }
    else{ 
	returnByte = (byte << 1); 
    }
    
    return(returnByte);
}

DEFINE_CALL 'SatSend' (char str[]){	
    stack_var integer k;
    stack_var integer Crc;
    stack_var char CrcHigh;
    stack_var char CrcLow;
    stack_var char strCrc[30];
    
    //stack_var char tStr[300];
    
    
    Crc= $147A;
    
    for (k=1;k<=length_string(str);k++){
	Crc = rotateLeft(Crc);
	crc = crc ^ $FFFF;
	
	CrcHigh = crc/256;
	crc = crc + CrcHigh + str[k];	
    }
    
    CrcHigh = crc/256;
    CrcLow = crc%256;
    
    strCrc="str,CrcHigh,CrcLow";
    
    //sprawdzanie $FE
    //send_string 0,"'0xFE ', itoa(find_string( strCrc,"$FE",1))";
    
    strCrc="$FE,$FE,strCrc,$FE,$0D";
    
    
    /*TESTY
    tStr='';
    for (k=1;k<=length_string(strCrc);k++){
	tStr="tStr,' 0x',itohex(strCrc[k])";
    }
    
    send_string 0,"'CODE : ',tStr";
    */
    
    satelToSend=strCrc;
    
    
}

DEFINE_CALL 'satRecive' (char str[]){
    stack_var char cmd;
    stack_var char tStr[100];
    stack_var integer k;
    
    cmd=str[1];

    select {
	active ($00<=cmd && cmd<=$08):{
	    call 'satRecInput'(str);
	}
	active ($09<=cmd && cmd<=$16):{
	    call 'satRecStrefa'(str);
	}
	active ($17<=cmd && cmd<=$24):{
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
    stack_var integer join;
    stack_var integer state;
    
    stack_var integer k;
    stack_var integer m;
    
    //stack_var char tStr[50];
    //stack_var integer n;
    
    cmd=str[1];
    
    for (m=2;m<=17;m++){//po wszystkich bajtach w slowie
	for (k=1;k<=8;k++){ //po wszystkich bitach w bajcie
	    state = Flg(k,str[m]);
	    join = ((m-2) * 8 ) + k;
	    
	    if (join > satMaxInputs){
		break;
	    }
	    
	    switch (cmd){
		case $00 :{
		    satInput[join].z.viol=state;
		}
		case $01 :{
		    satInput[join].z.tamper=state;
		}
		case $02 :{
		    satInput[join].z.alarm=state;
		}
		case $03 :{
		    satInput[join].z.tamperAlarm=state;
		}
		case $04 :{
		    satInput[join].z.alarmMemory=state;
		}
		case $05 :{
		    satInput[join].z.tamperAlarmMemory=state;
		}
		case $06 :{
		    satInput[join].z.bypass=state;
		}
		case $07 :{
		    satInput[join].z.noVoilationTrouble=state;
		}
		case $08 :{
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
		
		send_string 0,"'brRolDWN ',str";
	    }
	}
    }
    
}



DEFINE_CALL 'satRecStrefa' (char str[]){
    stack_var integer cmd;
    stack_var integer state;
    stack_var integer join;
    
    stack_var integer k;
    stack_var integer m;
    
    cmd= str[1];
   
    for (m=2;m<=5;m++){//po wszystkich bajtach w slowie
	for (k=1;k<=8;k++){//po wszystkich bitach w bajcie
	    state = Flg(k,str[m]);
	    join = ( (m-2) * 8 ) + k
	    
	    if (join > satMaxZones){
		break;
	    }
	    
	    switch (cmd){
		case $09 :{
		    satStrefy[join].z.armed=state;
		}
		case $0A :{
		    satStrefy[join].z.realyArmed=state;
		}
		case $0B :{
		    satStrefy[join].z.armingModeII=state;
		}
		case $0C :{
		   satStrefy[join].z.armingModeIII=state;
		}
		case $0D :{
		    satStrefy[join].z.firstCode=state;
		}
		case $0E :{
		    satStrefy[join].z.entryTime=state;
		}
		case $0F :{
		    satStrefy[join].z.exitTimeShort=state;
		}
		case $10 :{
		    satStrefy[join].z.exitTimeLong=state;
		}
		case $11 :{
		   satStrefy[join].z.tempBlocked=state;
		}
		case $12 :{
		   satStrefy[join].z.gouardRound=state;
		}
		case $13 :{
		    satStrefy[join].z.alarm=state;
		}
		case $14 :{
		    satStrefy[join].z.fire=state;
		}
		case $15 :{
		    satStrefy[join].z.alarmMemory=state;
		}
		case $16 :{
		    satStrefy[join].z.fireMemory=state;
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
    
    
    //stack_var char strr[13];	
    
    stack_var char tStr[100];
    
    strr='nnnnnnnnnnnn';  // dwanascie znaków aby ulatwic dodawanie
    
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
	strr[(k/2)+1]=strr[(k/2)+1]+$F;
    }
    else{
	strr[(k/2)+1]=$FF;
    }
    
    for (i=(k/2)+2;i<=8;i++){
	strr[i]=$FF;
    }
    
    
    
    //obliczanie Stref do zakodowania
    strr[9]=$00;
    strr[10]=$00;
    strr[11]=$00;
    strr[12]=$00;
    
    for (k=1;k<=length_array(satZones);k++){
	if ([dvTPalarm,satZones[k][2]]>0){
	
	    strr[(satZones[k][1]/8) + 9] = strr[(satZones[k][1]/8) + 9] BOR ( 1 << (( satZones[k][1] MOD 8 )-1 ));
	}
    }
    
    /*
    send_string 0,"'CODE len: ',itoa(length_string(strr))";
    
    tStr='';
    for (k=1;k<=length_string(strr);k++){
	tStr="tStr,' 0x',itohex(strr[k])";
    }
    
    
    send_string 0,"'CODE : ',tStr";
    */
    
    if (arm){
	call 'SatSend' ("$80,strr");
	wait 100{
	    call 'SatSend' ("$81,strr");
	}
	wait 200{
	    call 'SatSend' ("$82,strr");
	}
	wait 300{
	    call 'SatSend' ("$83,strr");
	}
    } else {
	call 'SatSend' ("$84,strr");
    }
    
}



DEFINE_CALL 'satAlarmFlashLights' {

    send_string 0,"'SATEL: AlarmLights ON: ',satSwiatlaAlarmowe";
    call 'brDigON' (satSwiatlaAlarmowe);
    
    wait 15{
	send_string 0,"'SATEL: AlarmLights OFF: ',satSwiatlaAlarmowe";
	call 'brDigOFF' (satSwiatlaAlarmowe);
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
	SEND_COMMAND dvSatel,"'SET BAUD 19200,N,8,1, 485 Disable'";
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

TIMELINE_EVENT [satTMalarm1]{
    call 'satAlarmFlashLights'
}

TIMELINE_EVENT [satTMalarm2]{
    call 'satAlarmFlashLights'
}

TIMELINE_EVENT [satTMalarm3]{
    call 'satAlarmFlashLights'
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


