PROGRAM_NAME='MultiRoom'
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
char DefZone=1
char maxZones=8

integer maxKolSC=50
integer maxKolMar=50

char comMrSpSources[9][20]= 
{
    {'Tuner_1'},
    {'Tuner_2'},
    {'idoc'},
    {'dreamBox_1'},
    {'marantz_BR_1'},
    {'Serwer_1'},
    {'srAux'},
    {'USB'}
}

char comMrSpSourcesName[9][20]= 
{
    {'Wybierz'},
    {'Tuner 1'},
    {'Tuner 2'},
    {'iPod'},
    {'Dream Box'},
    {'Blue-Ray'},
    {'Serwer'},
    {'Aux'},
    {'USB'}
}

char marSourcesTypes[9][2]= 
{
    {'C'},
    {'C'},
    {'C'},
    {'5'},
    {'2'},
    {'3'},
    {'C'},
    {'7'}
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE
STRUCTURE zone
{
    char name[15]
    char ID
    char src
    char state
    char volume
    char mute
    char bass
    char treble
}

STRUCTURE source
{
    char ID
    char keyID
    char type
    char expAdr
    char name[15]
}

STRUCTURE tuner
{
    char freq[15]
    char preset[10][15]
    char prName[15]
}

STRUCTURE menu
{
    char expAdr
    char stateStamp
    
    char main[20]
    char high
    char iIndex[6]
    char iName[6][20]
}

//tylko dla iPoda
STRUCTURE media 
{	
    char adr
    char stateStamp
    
    integer play
    integer stop
    integer pause
    
    integer rep
    integer shuff
    
    char timeTotalQ[5]
    char timePlaydQ[5]
    char timePlay[5]
    
    char plTitle[10]
    char plArtist[10]
    char plAlbum[10]
}


DEFINE_VARIABLE

volatile char for_k;

volatile integer innicial;

volatile char bSC[1500];
volatile integer lenbSC;
volatile char sum;
non_volatile integer errorString;
non_volatile integer errorBuffer;
non_volatile integer errorBufEx;

volatile char kolSC[maxKolSC][20]
non_volatile integer errorKolLen;
volatile char semSendSC;

non_volatile integer errorCommand;
non_volatile integer errorRecived;
volatile char resend;

volatile zone Zones[maxZones]
volatile source Sources[9]
volatile tuner Tuners[2]
volatile menu Menues[9]
volatile media iPodMedia

volatile char maxSource;


volatile char ZoneAkt=1;
volatile integer var_level;
volatile integer mrSpEn;
volatile integer mrSpSr;
non_volatile integer errorSubPageRet;

volatile char varZoneSrc[8]={'00000000'};

volatile char bufMar[90];
volatile integer lenMar;
volatile char kolMar[50][20];
volatile integer semMar;
non_volatile integer errorBufMar;
non_volatile integer errorKolMar;
volatile integer errorMARnotRespond;
volatile integer marErr ;

volatile integer marInialize;
volatile integer marPower;
volatile char marSource;
volatile integer marVolume;
volatile integer marMute;
volatile integer marHDMI;

volatile integer lenOfKol;
volatile integer forLenOfKol;
non_volatile integer errorSCnotRespond;

volatile integer projekcja;

volatile integer varBlueRayState;
volatile integer BlueRayState;

volatile integer SerwerState;
volatile integer varSerwerState;

volatile integer DreamBoxState;
volatile integer varDreamBoxState;

volatile char waitK;

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)

// **********
//obsługa polecen przychodzacych
//z zalorzeniem wyczyszczenia z długości i sumy kontrolnej
DEFINE_CALL 'inni'
{

    	wait 20 { call 'iZone' (1);}
	wait 40 { call 'iZone' (2);}
	wait 60 { call 'iZone' (3);}
	wait 80 { call 'iZone' (4);}
	wait 100{ call 'iZone' (5);}
	wait 120 { call 'iZone' (6);}
	wait 140 { call 'iZone' (7);}
	wait 160 { call 'iZone' (8);}
	
	
	wait 260 { call 'iSource' (1)};
	wait 280 { call 'iSource' (2)};
	wait 300 { call 'iSource' (3)};
	wait 320 { call 'iSource' (4)};
	wait 340 { call 'iSource' (5)};
	wait 360 { call 'iSource' (6)};
	wait 380 { call 'iSource' (7)};
	wait 400 { call 'iSource' (8)};
	wait 420 { call 'iSource' (9)};
	
	wait 520 { call 'iReqSource' (1)};
	wait 540 { call 'iReqSource' (2)};
	wait 560 { call 'iReqSource' (3)};
	wait 580 { call 'iReqSource' (4)};
	wait 600 { call 'iReqSource' (5)};
	wait 620 { call 'iReqSource' (6)};
	wait 640 { call 'iReqSource' (7)};
	wait 660 { call 'iReqSource' (8)};
	wait 680 { call 'iReqSource' (9)};

}

DEFINE_CALL 'Recive' (char str[])
{
    stack_var char comType;
    
    comType=str[1];
    
    if(innicial=0)
    {
	innicial=1;
	call 'inni';
	
    }
    
    
    switch (comType)
    {
	case $20:
	{
	    call 'rZoneData'(str); 
	} 
	case $29:
	{
	    call 'rTunerData'(str); 
	}
	case $93:
	{
	    call 'rMediaInf'(str); 
	}
	case $94:
	{
	    call 'rMenuInf'(str);
	}
	case $95:
	{
	    call 'ReciveFB'(str); 
	}
	default:
	{
	}
	
    }
}

//obsluga danych powracających po wysłanych poleceniach
//otzymane dane z bytem oznaczaacym odpowiedz
//!!dodać logikę sprawdzania czy odpowiedź dotyczy wysłanych danych
DEFINE_CALL 'ReciveFB'(char str[])
{
    stack_var char comType;
    stack_var k;
    stack_var integer lKol;
    
    if (str[3]=$00)
    {	
	//SC sugeruje blad
	//proba kolejnego wyslania polecenia
	resend++;
	
	//jeśli spróbowano wysłać ten sam string po raz 3 bez rezultatu
	if (resend>3)
	{	
	    
	    resend=0;
	    errorCommand++;
	    SEND_STRING 0,"'WARNING: blad polecenia wyslanego do SC nr: ',itoa(errorCommand),' typu: ',itohex(str[2])";
	    
	    //przesuwanie kolejki na nastepny wyraz
	    lKol=length_array(kolSC)
	    if (lKol>1)
	    {
		for (k=2;k<=lKol;k++)
		{
		    kolSC[k-1]=kolSC[k];
		}
		lKol--;
		set_length_array(kolSC,lKol);
	    }
	    else
	    {
		clear_buffer kolSC[1];
		set_length_array (kolSC,0);		
	    }
	    
	}
	semSendSC=0;
    }
    //pakiet otrzymany prawidlowo, dalsza analiza danych
    else if ((str[3]=$01)) 
    { 		
	comType=str[2];
	//sprawdznie czy odpowiedz dotyczyla wysylanych ostatnio danych
	if (comType<>kolSC[1][1])
	{	
	}
	//jesli nie, ponowne wysylanie
	else
	{
	
	    //przesuwanie kolejki na nastepny wyraz
	    lKol=length_array(kolSC)
	    if (lKol>1)
	    {
		for (k=2;k<=lKol;k++)
		{
		    kolSC[k-1]=kolSC[k];
		}
		lKol--;
		set_length_array(kolSC,lKol);
	    }
	    else
	    {
		clear_buffer kolSC[1];
		set_length_array (kolSC,0);		
	    }
	    
	    ////MIEJSCE WYWOLAN DALSZYCH FUNKCJII
	    //#WARN '!!!!!UWAGA doadc logike odpowiedzi ktora moze pomijac FB z Zone == sprawdzic czy faktycznie'
	    switch (comType)
	    {
		case $68:
		{
		    call 'rZoneIni' (str);
		}		
		case $71:
		{
		    call 'rSourceIni' (str);
		}
		case $75:
		{
		    call 'rTunerIni' (str);
		}
		default:
		{
		}		
	    }
	}
	semSendSC=0; 
    }
    else
    {
	errorRecived++;
	//SEND_STRING 0,"'WARNING: blad polecenia odebranego od SC nr: ',itoa(errorRecived),' typu: ',itohex(str[3])";
    }
}


// ****************************
// obrobka otrzymywanych danych

//4.15
DEFINE_CALL 'rZoneIni' (char str[])
{	
    char aktZone;
    
    aktZone=str[4];
    
    Zones[aktZone].name=mid_string(str,6,length_string(str)-7);
    
}

//4.17
DEFINE_CALL 'rZoneReq' (char str[])
{	
    char aktZone
    
    str=right_string(str,length_string(str)-3);
    aktZone=str[1];
    str="Zones[aktZone].state,str";
	
    call 'rZoneData' (str);
    
}



DEFINE_FUNCTION integer flag (integer fl,char byte)
{
    stack_var result;

    result=1 & (byte >> (fl-1));;
    return result;
}

//5.1
DEFINE_CALL 'rZoneData' (char str[])
{	
    stack_var char aktZone
    stack_var char bt
    stack_var integer k
    stack_var integer var_src
    
    aktZone=str[2]+1;
    Zones[aktZone].state=str[1];    
    
    //#WARN '!!UWAGA!! Bajt do obliczania bitow flag moze miec zly numer (reserved)'
    //#WARN '!!UWAGA!! Flagi do sprawdzenia i ewentualnego poprawienia'

    Zones[aktZone].mute=flag(1,str[4]);
    Zones[aktZone].state=flag(2,str[4]);
    var_src=Zones[aktZone].src
    Zones[aktZone].src=str[5]+1;
    
    if (Zones[aktZone].src<>varZoneSrc[aktZone])
    {
	//SEND_STRING dvClientWAGO,"'<<','z_',itoa(aktZone),'_s_',itoa(Zones[aktZone].src),'>>'" //zupełnie z dupy, ale co zrobisz
	varZoneSrc[aktZone]=Zones[aktZone].src;
    }
    
    Zones[aktZone].bass=str[7];
    Zones[aktZone].treble=str[8];
    Zones[aktZone].volume=str[6]*255/100;    
    
    if (aktZone=ZoneAkt&&var_src<>Zones[aktZone].src&&mrSpEn)
    {
	call 'mrWizRefresh';
    }
    
    if (aktZone=1)
    {
	call 'marSync';
    }
    
    call 'mrSoureceLogic';
}

DEFINE_CALL 'mrSoureceLogic'
{
    stack_var integer k;
    
    //sprawdzanie czy  blu ray ma byc wloczony
    for (k=1; k<=maxZones;k++)
    { 
	if (Zones[k].src=5)
	{
	    BlueRayState=1;
	    break;
	}
	BlueRayState=0;
    }
    
    if (BlueRayState<>varBlueRayState)
    {
	varBlueRayState=BlueRayState;
	
	cancel_wait 'BlueRayWait';
	
	wait 200 'BlueRayWait'
	{
	    if (BlueRayState)
	    {
		PULSE [dvIrBluRay,1];
		
		wait 100
		{
		    PULSE [dvIrBluRay,42]
		}
	    }
	    else
	    {
		PULSE [dvIrBluRay,2];
	    }
	}
    }
    
    //sprawdzanie czy  serwer ma byc wloczony
    for (k=1; k<=maxZones;k++)
    { 
	if (Zones[k].src=6)
	{
	    SerwerState=1;
	    break;
	}
	
	SerwerState=0;
    }
    
    if (SerwerState<>varSerwerState)
    {
	varSerwerState=SerwerState;
	
	
	if (varSerwerState)
	{
	    PULSE [dvIrSerwer,1];
	}
    }
    
    /*
    //sprawdzanie czy  DreamBox ma byc wloczony
    for (k=1; k<=maxZones;k++)
    { 
	if (Zones[k].src=4)
	{
	    DreamBoxState=1;
	    break;
	}
	
	DreamBoxState=0;
    }
    
    if (DreamBoxState<>varDreamBoxState)
    {
	varDreamBoxState=DreamBoxState;
	
	/*
	if (varDreamBoxState)
	{
	    
	}
	*/
	
	PULSE [dvIrDreamBox,9];
    }
    */
}

//4.16
DEFINE_CALL 'rSourceIni' (char str[])
{	
    char aktSrc;
    
    aktSrc=str[6];
    
    if (length_array(Sources)<aktSrc)
    {
	set_length_array(Sources,aktSrc);
    
    }
    
    Sources[aktSrc].ID=str[7];
    Sources[aktSrc].keyID=str[8];
    Sources[aktSrc].type=str[9];
    Sources[aktSrc].expAdr=str[10];
    
    if (length_array(Menues)<aktSrc)
    {
	set_length_array(Menues,aktSrc);
    }
    
    Menues[aktSrc].expAdr=str[10];
    Sources[aktSrc].name=right_string(str,length_string(str)-10);   
}

//4.19
DEFINE_CALL 'rTunerIni' (char str[])
{	
    char aktTun;
    aktTun=str[6];
}

//5.2 0x29
DEFINE_CALL 'rTunerData' (char str[])
{	
    local_var char aktTune;
    local_var char aktFreq[15];
    local_var char aktProg[15];
    
    aktTune=str[2]+1;
    
    aktFreq = "itoa(str[5]),'.',itoa(str[4])";
    
    if (aktFreq<>Tuners[aktTune].freq)
    {
	send_command dvTPmrSource,"'^TXT-',itoa(10*aktTune),',0,',aktFreq"
    }
    
    Tuners[aktTune].freq=aktFreq;
    
    //#WARN 'nie wysyla jesli nie dostal'
    
    aktProg=right_string(str,length_string(str)-5);           
    
    if (aktProg<>Tuners[aktTune].prName)
    {
	send_command dvTPmrSource,"'^TXT-',itoa(10*aktTune)+1,',0,',aktProg"
	//send_string 0,"'^TXT-',itoa((10*aktTune)+1),',0,',aktProg"
    }
    
    Tuners[aktTune].prName=aktProg;
}

//5.6	0x94
DEFINE_CALL 'rMenuInf' (char str[])
{	
    stack_var integer k;
    stack_var integer aktSrc;
    
    for (k=1;k<=length_array(Sources);k++)
    {
	if (Sources[k].expAdr=str[2])
	{
	    aktSrc=k;
	    break;
	}
    }
    
    if (aktSrc>0)
    {    
	
	if (length_array(Menues)<aktSrc)
	{
	    set_length_array(Menues,aktSrc);
	}
	
	if (aktSrc=3)
	{
	    iPodMedia.stateStamp=str[3];
	}
	
	Menues[aktSrc].stateStamp=str[3];
    }
    //send_string 0,"'MENU SourceAdres: ',itoa(aktSrc),'str: ',itoa(str[3]),' stamp: ', itoa(Menues[aktSrc].stateStamp),' adr: ',itoa(Menues[aktSrc].expAdr)";
    
}

//5.7 0x93
DEFINE_CALL 'rMediaInf' (char str[])
{	
    stack_var integer k;
    stack_var integer aktSrc;
    
    for (k=1;k<=length_array(Sources);k++){
	if (Sources[k].expAdr=str[2]){
	    aktSrc=k;
	    break;
	}
    }
    
    if (aktSrc>0){    
	
	if (length_array(Menues)<aktSrc){
	    set_length_array(Menues,aktSrc);
	}
	if (aktSrc=3){
	    iPodMedia.stateStamp=str[3];
	}
	
	Menues[aktSrc].stateStamp=str[3];
    }
    //send_string 0,"'MEDIA SourceAdres: ',itoa(aktSrc),'str: ',itoa(str[3]),' stamp: ', itoa(Menues[aktSrc].stateStamp),' adr: ',itoa(Menues[aktSrc].expAdr)";
}


// *****************************************************
// innicjalizacja komunikacji; prosby o dane na poczatku

DEFINE_CALL 'iZone' (integer zn){ 		//4.15

}

DEFINE_CALL 'iReqZone' (integer zn){	//4.17
    send_string 0,"'!!!!UWAGA!!!! wywolanie nienapisanej funkji iReqZone'"

}

DEFINE_CALL 'iSource' (integer src){
    call 'Send_SC' ("$71,DefZone,$02,src");
    send_string 0,"$71,'  ',itoa($71),'  ',itohex($71)"

}
DEFINE_CALL 'iReqSource' (integer sr){ //chyba ma sie pytac o dane zrodel w zaleznosci od typow (menu i media)?
    
}

DEFINE_CALL 'iTuner' (char tn){
    call 'Send_SC' ("$75,DefZone-1,tn")
}


// ************************
// polecenia wysylane do SC

DEFINE_CALL 'mrPowerON' (char zn)
{
    send_string 0,"'CALL: mrPowerON(', itoa(zn), ')'";
    call 'Send_SC' ("$A0,zn-1");
}

DEFINE_CALL 'mrPowerOFF' (char zn)
{
    send_string 0,"'CALL: mrPowerOFF(', itoa(zn), ')'";
    call 'Send_SC' ("$A1,zn-1");
    
    wait 50
    {
	if (zn=1) call 'marPowerOFF';    
    }
}

DEFINE_CALL 'mrSourceSelect' (char zn, char src)
{
    send_string 0,"'CALL: mrSourceSelect(', itoa(zn), ', ', itoa(src), ')'";
    call 'Send_SC' ("$A3,zn-1,src-1");
}

DEFINE_CALL 'mrVolUP' (char zn)
{
    if (zn=1)
    {
	call 'marVolumeUP'
    }
    else
    {
	call 'Send_SC' ("$57,$00,$00,$01,$00,zn-1");
    }
}

DEFINE_CALL 'mrVolDWN' (char zn)
{
    if (zn=1)
    {
	call 'marVolumeDWN'
    }
    else
    {
	call 'Send_SC' ("$57,$00,$00,$00,$00,zn-1");
    }
}

DEFINE_CALL 'mrVolMuteTG' (char zn)
{
    send_string 0, "'CALL: mrVolMuteTG(', itoa(zn), ')'";
    call 'Send_SC' ("$57,$00,$00,$02,$00,zn-1");
}

DEFINE_CALL 'mrVolMutON' (char zn)
{
    send_string 0, "'CALL: mrVolMutON(', itoa(zn), ')'";
    call 'Send_SC' ("$57,$00,$00,$04,$00,zn-1");
}

DEFINE_CALL 'mrVolMutOFF' (char zn)
{
    send_string 0, "'CALL: mrVolMutOFF(', itoa(zn), ')'";
    call 'Send_SC' ("$57,$00,$00,$03,$00,zn-1");
}

DEFINE_CALL 'mrVolLevel' (char zn, char lev){ //!!!nie dokonczone/nie dziala!!!

    if (zn=1){
    
    }
    
    lev=(256-lev)/4;
    
    if (lev>44){
	lev=((lev-44)*2)+44;
	if (lev>80){
	    lev=80;
	}
    }
    //SEND_STRING 0,"'SetVolume: ',itoa(lev)"
    call 'Send_SC' ("$57,$00,$00,$05,lev,zn-1");
}

DEFINE_CALL 'mrTunPres' (char tun, char pres){
    if (pres>10){
	pres=10
    } else if (pres=0){
	pres=1
    }
    call 'Send_SC' ("$62,tun-1,DefZone-1,pres-1");
}

DEFINE_CALL 'mrTunFM/AM' (char tun){
    call 'Send_SC' ("$63,tun-1,$03");
}
DEFINE_CALL 'mrTunPresNEXT' (char tun){
    call 'Send_SC' ("$63,tun-1,$04");
}
DEFINE_CALL 'mrTunPresPREV' (char tun){
    call 'Send_SC' ("$63,tun-1,$05");
}
DEFINE_CALL 'mrTunSeekUP' (char tun){
    call 'Send_SC' ("$63,tun-1,$06");
}
DEFINE_CALL 'mrTunSeekDWN' (char tun){
    call 'Send_SC' ("$63,tun-1,$07");
}
DEFINE_CALL 'mrTunTuneUP' (char tun){
    call 'Send_SC' ("$63,tun-1,$0B");
}
DEFINE_CALL 'mrTunTuneDWN' (char tun){
    call 'Send_SC' ("$63,tun-1,$0C");
}	

DEFINE_CALL 'mrSourceNext' (integer src){
    send_string 0,"'NEXT: ',itoa(src)";
    
    switch (src) {
	case 1:{
	    call 'mrTunPresNEXT' (1);
	}
	case 2:{
	    call 'mrTunPresNEXT' (2);
	}
	case 3:{
	    call 'mrIpodNEXT';
	}
	case 4:{
	    PULSE [dvIrDreamBox,48];	
	}
	case 5:{
	    PULSE [dvIrBluRay,46];
	}
	case 6:{
	    //call 'mrTunPresNEXT' (1);
	}
	case 7:{
	    //call 'mrTunPresNEXT' (1);
	}
	case 8:{
	    call 'marSend' ("'UPY:4'");
	}
    } 

}
DEFINE_CALL 'mrSourcePrev' (integer src){
    send_string 0,"'PREV: ',itoa(src)";
    
    switch (src) {
	case 1:{
	    call 'mrTunPresPREV' (1);
	}
	case 2:{
	    call 'mrTunPresPREV' (2);
	}
	case 3:{
	    call 'mrIpodPREV';
	}
	case 4:{
	    PULSE [dvIrDreamBox,47];
	}
	case 5:{
	    PULSE [dvIrBluRay,45];
	}
	case 6:{
	    //call 'mrTunPresNEXT' (1);
	}
	case 7:{
	    //call 'mrTunPresNEXT' (1);
	}
	case 8:{
	    call 'marSend' ("'UPY:5'");
	}
    } 

}





// *****************************
//proste wysyłanie poleceń do SC

DEFINE_CALL 'Send_SC' (char str[]){
    stack_var char KolLen
    
    send_string 0,"'CALL: Send_SC(', str, ')'";
    
    KolLen=length_array(kolSC);
    
    if (KolLen<maxKolSC){
	KolLen++;	
	set_length_array (kolSC,KolLen);
	kolSC[KolLen]=str;
    }
    else{
	errorKolLen++;
	//SEND_STRING 0,"'WARNING: za krota kolejka wysylania nr: ',itoa(errorKolLen)";
    }
}

(* Proba logiki przy CommandPort i oknie wysyłania
DEFINE_CALL 'SendScWindow' {
    if ((length_array(kolSC)) && !(semSendSC)){
	stack_var char str[100];
	stack_var char sum;
	stack_var integer k;
    
	semSendSC=1;	//semafor
	
	str=kolSC[1];
	str="length_string(str),str";
	
	sum=0;
	for (k=1;k<length_string(str);k++){
	    sum=sum+str[k];
	}
	
	str="$55,str,sum";

	SEND_STRING dvSC,"str";    
    }
}
*)


// ***************************
//sterowanie wizualizacją

DEFINE_CALL 'mrWizRefresh'{
    stack_var integer k;
    
    if (mrSpEn){
	cancel_wait 'ZoneAktRestoreWait';
	
	
	SEND_COMMAND dvTPmain,"'@PPO-mrSrodekMultrioom'";
	
	for (k=1;k<=maxZones;k++){
	    OFF [dvTPmr,10+k];
	}
	
	
	ON [dvTPmr,10+ZoneAkt];
	
    
	SEND_COMMAND dvTPmr,"'^TXT-3,0,',comMrSpSourcesName[Zones[ZoneAkt].src+1]";
	
	if (Zones[ZoneAkt].state){
	    SEND_COMMAND dvTPmain,"'@PPF-mrWyborZrodla'";
	    SEND_COMMAND dvTPmain,"'@PPN-',comMrSpSources[Zones[ZoneAkt].src],';SubPagesMain'";
	    send_string 0,"'@PPN-',comMrSpSources[Zones[ZoneAkt].src],';SubPagesMain'";
	    
	    
	    
	    if (ZoneAkt=1){ //pokazywanie bocznego panelu kontroli TV
		SEND_COMMAND dvTPmain,"'@PPN-mrTv;SubPagesMain'";
		SEND_COMMAND dvTPmain,"'@PPN-mrEkranOnOff;SubPagesMain'";
		
	    }else{
		SEND_COMMAND dvTPmain,"'@PPF-mrTv;SubPagesMain'";
		SEND_COMMAND dvTPmain,"'@PPF-mrEkranOnOff;SubPagesMain'";
	    }
	}
	else{
	    SEND_COMMAND dvTPmain,"'@PPN-mrWyborZrodla;SubPagesMain'";
	    SEND_COMMAND dvTPmr,"'^TXT-3,0,Wybierz'";
	}
    }
    else {
	SEND_COMMAND dvTPmain,"'@PPF-mrWyborZrodla'";
	SEND_COMMAND dvTPmain,"'@PPF-mrTrebleAndBass'";
	SEND_COMMAND dvTPmain,"'@PPF-mrSrodekMultrioom'";
	wait 6000 'ZoneAktRestoreWait'{
	    ZoneAkt=1;
	}
    }
    
    
}

DEFINE_CALL 'marSend' (char str[]){
    stack_var integer l;
    
    l=length_array(kolMar);
    
    if (l<max_length_array(kolMar)){
	l++;
	set_length_array(kolMar,l);
	kolMar[l]=str;
    } else {
	errorKolMar++;
	send_string 0,"'WARING: przekroczono kolejke wysylania Marantza'";
    }
}

DEFINE_CALL 'marSyncPower'{
    if (marInialize){
    }

}

DEFINE_CALL 'marSync'{
    if (marInialize){
	if (Zones[1].state<>marPower){
	    wait 100{
		if (Zones[1].state){
		    call 'marPowerON';
		} else {
		    send_string 0,"'ZoneState: ', itoa(Zones[1].state), ' | marPower: ', itoa(marPower)";
		    //call 'marPowerOFF'
		    //send_string 0,"'[marPowerOFF] MR: 1006'";
		}
	    }
	}
	
	if (Zones[1].mute<>marMute){
	    if (Zones[1].mute){
		call 'marVolumeMuteON';
	    } else {
		call 'marVolumeMuteOFF';
	    }
	}
	
	if (Zones[1].src>0){
	    if (marSource<>marSourcesTypes[Zones[1].src]){
		send_string 0,"'marant: ',marSource,' SC: ',marSourcesTypes[Zones[1].src]";
		call 'marSrcSelect';
	    }
	}
    }
}


DEFINE_CALL 'marVolumeUP'{
    call 'marSend' ('VOL:1');
}
DEFINE_CALL 'marVolumeDWN'{
    call 'marSend' ('VOL:2');
}
/*
DEFINE_CALL 'marVolume' (integer lv){ //nieskonczone!!!!!!!!!!!
    //call 'marSend' ('VOL:0');
}
*/
DEFINE_CALL 'marVolumeMuteON' {
    call 'marSend' ('AMT:2');
}
DEFINE_CALL 'marVolumeMuteOFF' {
    call 'marSend' ('AMT:1');
}
DEFINE_CALL 'marVolumeMuteTG' {
    call 'marSend' ('AMT:0');
}
DEFINE_CALL 'marSrcSelect' {
    call 'marSend' ("'SRC:',marSourcesTypes[Zones[1].src]");
}

DEFINE_CALL 'marPowerON'{
    PULSE [dvIrMarantz,30];
    SEND_COMMAND dvTPmain,"'^IRM-3,30, 5, 5'" 
    wait 60 {
	call 'marSend' ("'@AST:',$0F");
    }
}
DEFINE_CALL 'marPowerOFF'{
    call 'marSend' ("'PWR:1'");
}

DEFINE_CALL 'sendIpod'(str[]){
    call 'Send_SC'("$90,Menues[2].expAdr,$01,Menues[2].stateStamp,$01,str");
    send_string 0,"'Stamp: ',itohex(Menues[3].stateStamp)";

}
DEFINE_CALL 'mrIpodPlayPAUSE'{
    call 'sendIpod' ("$02");
}
DEFINE_CALL 'mrIpodSTOP'{
    call 'sendIpod' ("$05");
}
DEFINE_CALL 'mrIpodNEXT'{
    call 'sendIpod' ("$06");
}
DEFINE_CALL 'mrIpodPREV'{
    call 'sendIpod' ("$07");
}
DEFINE_CALL 'mrIpodNextCHAP'{
    call 'sendIpod' ("$0B");
}
DEFINE_CALL 'mrIpodPrevCHAP'{
    call 'sendIpod' ("$0C");
}

DEFINE_CALL 'mrIpodShuffle'{
    call 'sendIpod' ("$16");
}
DEFINE_CALL 'mrIpodRepeat'{
    call 'sendIpod' ("$1A");
}


DEFINE_CALL 'ProjekcjaON'{
    
    if (projekcja=0){
	projekcja=1;
	
	call 'brRolDWN' ('1'); //opuszczenie rolet Kuchnia
	call 'brRolDWN' ('2'); //SalonD
	call 'brRolDWN' ('7'); //SalonG 1
	call 'brRolDWN' ('9'); //SalonG 2
	
	call 'brDimOFF' ('17'); //wylaczenie SalonD glowne
	
	call 'brDigOFF' ('2_3_5_7_22_20'); //wylacznie swiatel na dole
	call 'brDigON' ('1_6'); 
	
	call 'setRGBpreset' (1,1);
	call 'setRGBpreset' (4,1);
    }
    
    call 'marSend' ("'HDM:2'"); //zmiana wyjscia na Marantz-ie ( bo moze obsluzyc tylko 1 )
    call 'brRolDWN' ("'10'"); //opuszczanie Ekranu
    SEND_STRING dvProj,"$02,'PON',$03"; //wlaczanie projektora
    wait 300{
	SEND_STRING dvProj,"$02,'IIS:HD1',$03"; //ustawieni wejscia na 1
    }
}

DEFINE_CALL 'ProjekcjaOFF'{
    if (projekcja <> 0){
	projekcja=0;
	
	call 'setRGBoff' (1); //wylaczanie ledow salonD
	call 'setRGBoff' (2); //SalonD 2
	
	call 'brDimVAL' ('17/70'); //swiatlo glowne w salonie wlacz na przyciemniona wartosc
    }
    
    call 'marSend' ("'HDM:1'"); //zmiana wyjscia na Marantz-ie ( bo moze obsluzyc tylko 1 )
    call 'brRolUP' ("'10'"); //podnoszenie ekranu
    
    SEND_STRING dvProj,"$02,'POF',$03";  //wyl. projektora
}





//INCLUDE 'Ecom' //Ecom usunięty bo zdecydwalismy sie na inne rozwiazanie

DEFINE_START


CREATE_BUFFER dvSC,bSC

CREATE_BUFFER dvMarantz,bufMar



innicial=0;

set_length_array (Menues,9);


(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************)


(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT [dvProj]{
    ONLINE:{
	SEND_COMMAND dvProj,"'SET BAUD 9600,N,8,1, 485 Disable'";
    }
    STRING:{
	send_string 0,"'otrzymane z Proj: ',data.text,'xx'";
    }
}
DATA_EVENT [dvMarantz]{
    ONLINE:{
	
	SEND_COMMAND dvMarantz,"'SET BAUD 9600,N,8,1, 485 Disable'";
	call 'marSend' ("'@PWR:?'");
	wait 30{
	//wait 930{	
	    if (marPower)
	    {
		call 'marSend' ("'@AST:',$0F");
		call 'marSend' ("'@PWR:?'");
		call 'marSend' ("'@VOL:?'");
		call 'marSend' ("'@SRC:?'");
		call 'marSend' ("'@SSC:?'");
	    }
	    else
	    {
		PULSE [dvIrMarantz, 30];
		wait 50{
		//wait 350{
		    call 'marSend' ("'@AST:',$0F");
		    call 'marSend' ("'@PWR:?'");
		    call 'marSend' ("'@VOL:?'");
		    call 'marSend' ("'@SRC:?'");
		    call 'marSend' ("'@SSC:?'");
		}
	    }
	}
	marInialize=1;
	wait 150 {
	//wait 1050 {
	    //call 'marPowerOFF'; //czemu tak? co jeśli to zakomentujemy?
	}
    }
    STRING:{
	//send_string 0,"'otrzymane z Marantza: ',data.text,'xx'";
    }
}

DATA_EVENT [dvSC]{
    ONLINE: {
	SEND_COMMAND dvSC,"'SET BAUD 57600,N,8,1, 485 Disable'";
    }
    
    STRING: {
	
	cancel_wait 'new';
	wait 50000 'new' {
	    innicial=0;
	    send_string 0,"'!!!!!!!!!!!!!! inicjalizacja'";
	}
	
    }
    
}

DATA_EVENT [dvTPmain]{ //pilowanie stron na wiz
    STRING:{
	stack_var str[40]
	
	str=data.text;
	
	//send_string 0,"'string: ',str";
	
	select{
	    active (left_string(str,3)='@PP'): {
		stack_var f;
		stack_var ff;
		stack_var st;
		
		if (str[4]='F'){
		    st=0;
		}
		else if (str[4]='N'){
		    st=1;
		}
		else {
		    errorSubPageRet++;
		    //send_string 0,"'!!!UWAGA!!! blad odzyskiwnia stanu strony nr: ',itoa(errorSubPageRet)";
		}
		
		f=find_string (str,"'-'",1);
		ff=find_string(str,"';'",1);
		
		str=mid_string(str,f+1,ff-f-1);
		
		//send_string 0,"'uzyskany Sp: ',str";
		select{
		    active (str='navigation-multiroom'): {
			mrSpEn=st;
			call 'mrWizRefresh';
			
			if (projekcja=1){
			    call 'ProjekcjaON';
			}
			else{
			    call 'ProjekcjaOFF';
			}
		    }
		}
		
	    }
	}
	
    }
}

button_event [dvTPmr,2]{  //bassTrable
    push:{    
	if (projekcja){
	    call 'ProjekcjaOFF';
	} else {
	    call 'ProjekcjaON';	    
	}
    }
}
button_event [dvTPmr,3]{ //zrodla
    push:{
	
	if (Zones[ZoneAkt].src){
	    SEND_COMMAND dvTPmain,"'@PPG-mrWyborZrodla;SubPagesMain'";
	    
	    //ponowne sprawdzanie typu projekcji
	}
    }
}

//zmiana pokoju
button_event [dvTPmr,11]
button_event [dvTPmr,12]
button_event [dvTPmr,13]
button_event [dvTPmr,14]
button_event [dvTPmr,15]
button_event [dvTPmr,16]
button_event [dvTPmr,17]
button_event [dvTPmr,18]
{ 
    PUSH:
    {
	ZoneAkt=button.input.channel-10;
	call 'mrWizRefresh';
	
	send_string 0,"'== Zmiana Pokoju =='";
	
	send_string 0,"'Zona: ',itoa(ZoneAkt),' ID: ',itoa(Zones[ZoneAkt].ID)";
	send_string 0,"'Zona: ',itoa(ZoneAkt),' name: ',itoa(Zones[ZoneAkt].name)";
	send_string 0,"'Zona: ',itoa(ZoneAkt),' state: ',itoa(Zones[ZoneAkt].state)";
	send_string 0,"'Zona: ',itoa(ZoneAkt),' src: ',itoa(Zones[ZoneAkt].src)";
	send_string 0,"'Zona: ',itoa(ZoneAkt),' mute: ',itoa(Zones[ZoneAkt].mute)";
	
	/*
	send_string 0,"'Zona: ',itoa(ZoneAkt),' bass: ',itoa(Zones[ZoneAkt].bass)";
	send_string 0,"'Zona: ',itoa(ZoneAkt),' treble: ',itoa(Zones[ZoneAkt].treble)";
	send_string 0,"'Zona: ',itoa(ZoneAkt),' volume: ',itoa(Zones[ZoneAkt].volume)";
	*/
    }
}

//powerOn/Off z przycisków obok nazw stref
button_event [dvTPmr,31]
button_event [dvTPmr,32]
button_event [dvTPmr,33]
button_event [dvTPmr,34]
button_event [dvTPmr,35]
button_event [dvTPmr,36]
button_event [dvTPmr,37]
button_event [dvTPmr,38]
{ 
    PUSH:
    {
	stack_var char zn;
	
	zn = button.input.channel-30;
	
	if (Zones[zn].state)
	{
	    send_string 0,"'[ZoneButton] Strefa nr ', itoa(zn), ' On/Off: OFF'";
	    call 'mrPowerOFF' (zn);
	    send_string 0,"'[mrPowerOFF] MR: 1355'";
	}
	else
	{
	    send_string 0,"'[ZoneButton] Strefa nr ', itoa(zn), ' On/Off: ON'";
	    call 'mrPowerON' (zn);
	}
    }
}

//zmiana Zrodla
button_event [dvTPmr,51]
button_event [dvTPmr,52]
button_event [dvTPmr,53]
button_event [dvTPmr,54]
button_event [dvTPmr,55]
button_event [dvTPmr,56]
button_event [dvTPmr,57]
button_event [dvTPmr,58]
button_event [dvTPmr,59]
{   
    PUSH:
    {
	stack_var char src;
	
	src = button.input.channel - 50;
	send_string 0,"'== Zmiana zrodla == | Strefa : ' , itoa(ZoneAkt), ' | Zrodlo : ' , itoa(src)";
	call 'mrSourceSelect' (ZoneAkt, src);
    }
}
(* problemy z przeliczaniem
najwidoczniej wyslanie level-a powoduje jego kolejny event
level_event [dvTPmr,5]{
    call 'mrVolLevel' (ZoneAkt,level.value);
}
*)
button_event [dvTPmr,5]{    //VolDWN
    PUSH:{
	call 'mrVolDWN' (ZoneAkt);
    }
}
button_event [dvTPmain,2]{ //VolDWN on wheel
    PUSH:{
	if (mrSpEn){
	    call 'mrVolDWN' (ZoneAkt);
	}
    }
}
button_event [dvTPmr,6]{    //volUP
    PUSH:{
	call 'mrVolUP' (ZoneAkt);
    }
}
button_event [dvTPmain,1]{ //volUp on wheel
    PUSH:{
	if (mrSpEn){
	    call 'mrVolUP' (ZoneAkt);
	}
    }
}
button_event [dvTPmr,8]{    //volMute
    PUSH:{
	call 'mrVolMuteTG' (ZoneAkt);
    }
}

//powerOn/Off danej Zony z przycisku POWER
button_event [dvTPmr,9]
{ 
    PUSH:
    {
	if (Zones[ZoneAkt].state)
	{
	    send_string 0,"'[PowerButton] Strefa nr ', itoa(ZoneAkt), ' On/Off: OFF'";
	    call 'mrPowerOFF' (ZoneAkt);
	    send_string 0,"'[mrPowerOFF] MR: 1430'";
	}
	else
	{
	    send_string 0,"'[PowerButton] Strefa nr ', itoa(ZoneAkt), ' On/Off: ON'";
	    call 'mrPowerON' (ZoneAkt);
	}
    }
}

//powerOn/Off danej Zony HardButton
button_event [dvTPmain,5]
{ 
    PUSH:
    {
	if (mrSpEn)
	{
	    if (Zones[ZoneAkt].state)
	    {
		send_string 0,"'[HardButton] Strefa nr ', itoa(ZoneAkt), ' On/Off: OFF'";
		call 'mrPowerOFF' (ZoneAkt);
		send_string 0,"'[mrPowerOFF] MR: 1451'";
	    }
	    else
	    {
		send_string 0,"'[HardButton] Strefa nr ', itoa(ZoneAkt), ' On/Off: ON'";
		call 'mrPowerON' (ZoneAkt);
	    }
	}
    }
}



button_event [dvTPmrSource,1]
button_event [dvTPmrSource,2]
button_event [dvTPmrSource,3]
button_event [dvTPmrSource,4]
button_event [dvTPmrSource,5]
button_event [dvTPmrSource,6]
button_event [dvTPmrSource,7]
button_event [dvTPmrSource,8]
button_event [dvTPmrSource,9]{	//presety Radio1
    PUSH:{
	call 'mrTunPres' (1,button.input.channel)
    }
}

button_event [dvTPmrSource,11]{ //mrTunTuneDWN
    PUSH:{
	call 'mrTunTuneDWN' (1);
    }
}
button_event [dvTPmrSource,12]{ //mrTunTuneUP
    PUSH:{
	call 'mrTunTuneUP' (1);
    }
}
button_event [dvTPmrSource,13]{ //mrTunFM/AM COMENTED OUT
    PUSH:{
	//call 'mrTunFM/AM' (1);
    }
}

button_event [dvTPmrSource,14]{ //mrTunSeekDWN
    PUSH:{
	call 'mrTunSeekDWN' (1);
    }
}
button_event [dvTPmrSource,15]{ //mrTunSeekUP
    PUSH:{
	call 'mrTunSeekUP' (1);
    }
}


button_event [dvTPmrSource,21]
button_event [dvTPmrSource,22]
button_event [dvTPmrSource,23]
button_event [dvTPmrSource,24]
button_event [dvTPmrSource,25]
button_event [dvTPmrSource,26]
button_event [dvTPmrSource,27]
button_event [dvTPmrSource,28]
button_event [dvTPmrSource,29]{ //presety Radio2
    PUSH:{
	call 'mrTunPres' (2,button.input.channel-20)
    }
}

button_event [dvTPmrSource,31]{ //mrTunTuneDWN
    PUSH:{
	call 'mrTunTuneDWN' (2);
    }
}
button_event [dvTPmrSource,32]{ //mrTunTuneUP
    PUSH:{
	call 'mrTunTuneUP' (2);
    }
}
button_event [dvTPmrSource,33]{ //mrTunFM/AM COMENTED OUT
    PUSH:{
	//call 'mrTunFM/AM' (2);
    }
}
button_event [dvTPmrSource,34]{ //mrTunSeekDWN
    PUSH:{
	call 'mrTunSeekDWN' (2);
    }
}
button_event [dvTPmrSource,35]{ //mrTunSeekUP
    PUSH:{
	call 'mrTunSeekUP' (2);
    }
}


button_event [dvTPmrSource,40]{ //TV power
    PUSH:{
	PULSE [dvIrSamsug,9];
	send_string 0,"'dvIrSamsug power'";
    }
}
button_event [dvTPmrSource,41]{ //TV source
    PUSH:{
	cancel_wait 'wtTVsource'
	PULSE [dvIrSamsug,118];
	send_string 0,"'dvIrSamsug source'";
	
	wait 50 'wtTVsource'{
	    PULSE [dvIrSamsug,49];
	send_string 0,"'dvIrSamsug OK'";
	}
    }
}


button_event [dvTPmrSource,50]
button_event [dvTPmrSource,51]
button_event [dvTPmrSource,52]
button_event [dvTPmrSource,53]
button_event [dvTPmrSource,54]
button_event [dvTPmrSource,55]
button_event [dvTPmrSource,56]{ //BluRay Transport
    PUSH:{
	TO [dvIrBluRay,button.input.channel-8];		
    }

}

button_event [dvTPmrSource,57]{ //BluRay Dimmer
    PUSH:{
	TO [dvIrBluRay,9];	
    }
}

button_event [dvTPmrSource,60]
button_event [dvTPmrSource,61]
button_event [dvTPmrSource,62]
button_event [dvTPmrSource,63]
button_event [dvTPmrSource,64]
button_event [dvTPmrSource,65]
button_event [dvTPmrSource,66]
button_event [dvTPmrSource,67]
button_event [dvTPmrSource,68]
button_event [dvTPmrSource,69]{ //BluRay K-pad
    PUSH:{
	PULSE [dvIrBluRay,button.input.channel-29];	
    }
}
button_event [dvTPmrSource,70]{ //BluRay Clear
    PUSH:{
	PULSE [dvIrBluRay,8];	
    }
}
button_event [dvTPmrSource,71]{ //BluRay Search
    PUSH:{
	PULSE [dvIrBluRay,49];	
    }
}
button_event [dvTPmrSource,72]{ //BluRay A-B repeat
    PUSH:{
	PULSE [dvIrBluRay,4];	
    }
}
button_event [dvTPmrSource,73]{ //BluRay repeat
    PUSH:{
	PULSE [dvIrBluRay,50];	
    }
}
button_event [dvTPmrSource,74]{ //BluRay random
    PUSH:{
	PULSE [dvIrBluRay,51];	
    }
}
button_event [dvTPmrSource,75]{ //BluRay Zoom
    PUSH:{
	PULSE [dvIrBluRay,13];	
    }
}
button_event [dvTPmrSource,76]{ //BluRay TopMenu
    PUSH:{
	PULSE [dvIrBluRay,54];	
    }
}
button_event [dvTPmrSource,77]{ //BluRay PopUpMenu
    PUSH:{
	PULSE [dvIrBluRay,53];	
    }
}
button_event [dvTPmrSource,78]{ //BluRay Setup
    PUSH:{
	PULSE [dvIrBluRay,56];	
    }
}
button_event [dvTPmrSource,79]{ //BluRay Return
    PUSH:{
	PULSE [dvIrBluRay,25];	
    }
}



button_event [dvTPmrSource,80]
button_event [dvTPmrSource,81]
button_event [dvTPmrSource,82]
button_event [dvTPmrSource,83]
button_event [dvTPmrSource,84]{ //BluRay Up,Dwn...Enter
    PUSH:{
	PULSE [dvIrBluRay,button.input.channel-60];	
    }
}


button_event [dvTPmrSource,86]{ //BluRay RED
    PUSH:{
	PULSE [dvIrBluRay,61];	
    }
}
button_event [dvTPmrSource,87]{ //BluRay GREEN
    PUSH:{
	PULSE [dvIrBluRay,62];	
    }
}
button_event [dvTPmrSource,88]{ //BluRay BLUE
    PUSH:{
	PULSE [dvIrBluRay,59];		
    }
}
button_event [dvTPmrSource,89]{ //BluRay YELLOW
    PUSH:{
	PULSE [dvIrBluRay,60];		
    }
}
button_event [dvTPmrSource,90]{ //BluRay angle
    PUSH:{
	PULSE [dvIrBluRay,5];	
    }
}
button_event [dvTPmrSource,91]{ //BluRay subtitle
    PUSH:{
	PULSE [dvIrBluRay,55];		
    }
}
button_event [dvTPmrSource,92]{ //BluRay audio
    PUSH:{
	PULSE [dvIrBluRay,6];		
    }
}
button_event [dvTPmrSource,93]{ //BluRay pured
    PUSH:{
	PULSE [dvIrBluRay,61];		
    }
}
button_event [dvTPmrSource,94]{ //BluRay display
    PUSH:{
	PULSE [dvIrBluRay,10];		
    }
}
button_event [dvTPmrSource,95]{ //BluRay mode
    PUSH:{
	PULSE [dvIrBluRay,16];		
    }
}

button_event [dvTPmrSource,100]
button_event [dvTPmrSource,101]
button_event [dvTPmrSource,102]
button_event [dvTPmrSource,103]
button_event [dvTPmrSource,104]
button_event [dvTPmrSource,105]{ //DreamBox menu
    PUSH:{
	PULSE [dvIrDreamBox,button.input.channel-56];		
    }
}


button_event [dvTPmrSource,106]{ //DreamBox menu
    PUSH:{
	PULSE [dvIrDreamBox,51];		
    }
}
button_event [dvTPmrSource,107]{ //DreamBox menu
    PUSH:{
	PULSE [dvIrDreamBox,76];			
    }
}
button_event [dvTPmrSource,108]{ //DreamBox menu
    PUSH:{
	PULSE [dvIrDreamBox,77];			
    }
}


button_event [dvTPmrSource,110]
button_event [dvTPmrSource,111]
button_event [dvTPmrSource,112]
button_event [dvTPmrSource,113]
button_event [dvTPmrSource,114]
button_event [dvTPmrSource,115]
button_event [dvTPmrSource,116]
button_event [dvTPmrSource,117]
button_event [dvTPmrSource,118]
button_event [dvTPmrSource,119]{ //DreamBox transport/info
    PUSH:{
	PULSE [dvIrDreamBox,button.input.channel-31];		
    }
}


button_event [dvTPmrSource,120]
button_event [dvTPmrSource,121]
button_event [dvTPmrSource,122]
button_event [dvTPmrSource,123]
button_event [dvTPmrSource,124]
button_event [dvTPmrSource,125]
button_event [dvTPmrSource,126]
button_event [dvTPmrSource,127]
button_event [dvTPmrSource,128]
button_event [dvTPmrSource,129]{ //DreamBox transport/info
    PUSH:{
	PULSE [dvIrDreamBox,button.input.channel-110];		
    }
}
button_event [dvTPmrSource,132]{ //DreamBox power
    PUSH:{
	TO [dvIrDreamBox,9];		
    }
}

button_event [dvTPmrSource,171]{
    PUSH: {
	call 'mrIpodPlayPAUSE';
    }
}
button_event [dvTPmrSource,172]{
    PUSH: {
	call 'mrIpodSTOP';
    }
}
button_event [dvTPmrSource,173]{
    PUSH: {
	call 'mrIpodNEXT';
    }
}
button_event [dvTPmrSource,174]{
    PUSH: {
	call 'mrIpodPREV';
    }
}
button_event [dvTPmrSource,175]{
    PUSH: {
	call 'mrIpodNextCHAP';
    }
}
button_event [dvTPmrSource,176]{
    PUSH: {
	call 'mrIpodPrevCHAP';
    }
}

//USB transport
button_event [dvTPmrSource,151]
button_event [dvTPmrSource,152]
button_event [dvTPmrSource,153]
button_event [dvTPmrSource,154]
button_event [dvTPmrSource,155]
{ 	
    PUSH:
    {
	    call 'marSend' ("'UPY:',itoa(button.input.channel-150)");
    }
}
button_event [dvTPmrSource,156]{ 	//USB transport2 UP
    PUSH:{
	call 'marSend' ("'UCU:0'");
    }
}
button_event [dvTPmrSource,157]{ 	//USB transport2 DWN
    PUSH:{
	call 'marSend' ("'UCU:1'");
    }
}
button_event [dvTPmrSource,158]{ 	//USB transport2 LEFT
    PUSH:{
	call 'marSend' ("'UCU:2'");
    }
}
button_event [dvTPmrSource,159]{ 	//USB transport2 RIGHT
    PUSH:{
	call 'marSend' ("'UCU:3'");
    }
}
button_event [dvTPmrSource,160]{ 	//USB transport ENTER
    PUSH:{
	call 'marSend' ("'UMC:0'");
    }
}


button_event [dvTPmrSource,191]		//Serwer
button_event [dvTPmrSource,192]		//Serwer
button_event [dvTPmrSource,193]		//Serwer
button_event [dvTPmrSource,194]		//Serwer
button_event [dvTPmrSource,195]		//Serwer
button_event [dvTPmrSource,196]		//Serwer
button_event [dvTPmrSource,197]		//Serwer
button_event [dvTPmrSource,200]		//Serwer
button_event [dvTPmrSource,200]		//Serwer
button_event [dvTPmrSource,200]		//Serwer
button_event [dvTPmrSource,210]		//Serwer
button_event [dvTPmrSource,211]		//Serwer
button_event [dvTPmrSource,212]		//Serwer
button_event [dvTPmrSource,213]		//Serwer
button_event [dvTPmrSource,214]		//Serwer
button_event [dvTPmrSource,215]		//Serwer
button_event [dvTPmrSource,216]		//Serwer
button_event [dvTPmrSource,217]{ 	//Serwer
    PUSH:{
	//send_string 0,"'xbmc pulse: ',itoa(button.input.channel-190)";
	TO [dvIrSerwer,button.input.channel-190];
    }
}

//wejscie z domofonu
channel_event [dvInputs,3]
{ 		
    ON:
    {
	char k;
	
	send_string 0, "'DigitalInput3_ON'";
	
	for (k=1; k<=maxZones; k++)
	{
	    //send_string 0,"'[Domofon] Mute Zone nr ', itoa(k)";
	    call 'mrVolMutON'(k);
	}
    }   
    OFF:
    {
    }
}

