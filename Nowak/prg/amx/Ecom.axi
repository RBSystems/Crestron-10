PROGRAM_NAME='Ecom'
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
LONG tlCount[]={0,3000,3000,3000,3000,3000};  
integer tlID=1;


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEV dvTPintercom[] ={vdvTP,dvTPecom,dvEcomBrama}

DEV vdvTPintercom[] ={vdvTP,vdvTPecom,vdvEcomBrama}

integer ecomMicLevel;
integer ecomVolLevel;
integer ecomLightLevel;
integer muted;
integer mutedZones[8];


(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_CALL 'EcomCall'{
    stack_var integer i;
    
    SEND_COMMAND dvTPmain,"'WAKEUP'";
    SEND_COMMAND dvTPmain, "'PPON-srodekDomofonDuzy'";
    //SEND_COMMAND dvTPmain,"'^RFR-domofon'";
    
    
    if (TIMELINE_ACTIVE(tlID)){
	TIMELINE_KILL(tlID);
	TIMELINE_CREATE (tlID,tlCount,length_array(tlCount),TIMELINE_RELATIVE,TIMELINE_ONCE);
    } 
    else{
	TIMELINE_CREATE (tlID,tlCount,length_array(tlCount),TIMELINE_RELATIVE,TIMELINE_ONCE);
    }
    
    if (muted=0){
	muted=1;
	for (i=1;i<=length_array(Zones);i++){
	    mutedZones[i]=Zones[i].mute;
	    call 'mrVolMutON' (i);
	}
    }
}

DEFINE_CALL 'EcomAnwser'{   
    if (TIMELINE_ACTIVE(tlID)){
	TIMELINE_KILL(tlID);
    }
    
    
    SEND_COMMAND vdvTPecom,"'CREATE_CALL-SOURCE,192.168.0.198'";
    SEND_COMMAND vdvEcomBrama,"'CREATE_CALL-DESTINATION,192.168.0.195'";
    
    SEND_COMMAND vdvTPecom,"'ENABLE_SPEAKER'";
    SEND_COMMAND vdvEcomBrama,"'ENABLE_MIC'";
    
    
    /*
    SEND_COMMAND dvTPmain, "'^ICS-192.168.0.198,9002,9000,2'"
    SEND_COMMAND dvEcomBrama,"'STREAM-SET 192.162.0.195, 9000, 9002, AUDIO ,TALK, 1'"
    */
    //SEND_COMMAND dvEcomBrama,"'STREAM-PLAY 1'"
    
    
    ON [dvTPecom,11];
}

DEFINE_CALL 'EcomEnd'{
    stack_var integer i;

    if (TIMELINE_ACTIVE(tlID)){
	TIMELINE_KILL(tlID);
    }
    
    
    
    SEND_COMMAND vdvTPecom,"'END_CALLS'";
    SEND_COMMAND vdvEcomBrama,"'END_CALLS'";
    
    
    //SEND_COMMAND vdvTPecom,"'DISABLE_SPEAKER'";
    //SEND_COMMAND vdvEcomBrama,"'DISABLE_MIC'";
    
    
    /*
    SEND_COMMAND dvTPmain, "'^ICE'";
    SEND_COMMAND dvEcomBrama,"'STREAM-STOP 1'";
    */
    
    
    SEND_COMMAND dvTPecom, "'PPOF-srodekDomofonDuzy'";
    SEND_COMMAND dvTPecom, "'PPOF-srodekDomofon_volControl'";
    //OFF [dvTPecom,10];
    OFF [dvTPecom,11];
    
    if (muted=1){
	muted=0;
	for (i=1;i<=length_array(Zones);i++){
	    if (mutedZones[i]){
		call 'mrVolMutOFF' (i);
	    }
	}
    }	
}


DEFINE_START

OFF [dvTPecom,11];

//CREATE_LEVEL dvTPecom,21,ecomMicLevel;
//CREATE_LEVEL dvTPecom,25,ecomVolLevel;

(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_MODULE 'AMX_Intercom_Comm' Comm(vdvTPintercom,dvTPintercom)


(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT
timeline_event [tlID]{
    //SEND_STRING 0,"'timeline_event'";
    SEND_COMMAND dvTPecom,"'@SOU-music.mp3'";
    //SEND_COMMAND dvTPecom,"'@SOU-music.wav'";
    if (timeline.sequence=6){
	CALL 'EcomEnd';
    }
}


(*
    dane z TelNet-u:
    
    (0001979056) FIND_PHONEBOOK_ENTRY RETURNING 1 
    (0001979060) FOR VIRTUAL 33001, COMM RECEIVED FROM UI: CREATE_CALL-SOURCE,192.168.0.198 
    (0001979062) FOR VIRTUAL 33010, COMM RECEIVED FROM UI: CREATE_CALL-DESTINATION,192.168.0.197 
    (0001979066) FOR VIRTUAL 33001, COMM RECEIVED FROM UI: ENABLE_SPEAKER 
    (0001979068) FOR VIRTUAL 33010, COMM RECEIVED FROM UI: ENABLE_MIC 

*)

    /*
    Zastąpione CALL-em
    
    RELEASE:{
	SEND_COMMAND vdvTPecom,"'END_CALLS'"
	SEND_COMMAND vdvEcomBrama,"'END_CALLS'"
	SEND_COMMAND dvTPecom, "'PPOF-_DoorAnswerCall'"
    }
    */
   /*
    PUSH:{
	//SEND_COMMAND dvTPmain,"'^ICS-192.168.0.198,3002,3000,2'"
	//SEND_COMMAND dvEcomBrama,"'^ICS-192.168.0.197,3000,3002,2'"
    }
    */


button_event [dvEcomBrama,1]{
    PUSH:{
	CALL 'EcomCall'
    }   
}

button_event [dvEcomBramaIO,1]
button_event [dvEcomBramaIO,2]{
    PUSH:{
	//send_string 0,"'kontaktron ON: ',itoa(button.input.channel)";
    }
    RELEASE:{
	//send_string 0,"'kontaktron OFF: ',itoa(button.input.channel)";
    }
}

button_event [dvTPecom,10]{
    PUSH:{
	CALL 'EcomAnwser';
    }
}

button_event [dvTPecom,11]{
    PUSH:{
	CALL 'EcomEnd';
    }
}

button_event [dvTPecom,30]{
    PUSH:{
	//send_string 0,"'event light'";
	if (ecomLightLevel){
	    //send_string 0,"'event set low'";
	    SEND_COMMAND dvEcomBrama,"'SET CAM-LIGHTLVL LOW'";
	}
	else{
	    //send_string 0,"'event set high'";
	    SEND_COMMAND dvEcomBrama,"'SET CAM-LIGHTLVL NORM'";	
	}
	SEND_COMMAND dvEcomBrama,"'GET CAM-LIGHTLVL'";
    }
}

button_event [dvTPecom,1]{ //furtka
    PUSH:{
	ON [dvEcomBramaRelay,1];
	if (TIMELINE_ACTIVE(1)){
	    TIMELINE_KILL(1);
    }
    }
    RELEASE:{
	//send_string 0,"'otwieranie furtki'";
	cancel_wait 'furtka'; 
	wait 30 'furtka'{
	    //send_string 0,"'zamykanie furtki'";
	    OFF [dvEcomBramaRelay,1];
	}
    }
}
button_event [dvTPbramka,1]{
    Push:{
	if (TIMELINE_ACTIVE(1)){
	    TIMELINE_KILL(1);    
	}
    }	
}

button_event [dvTPecom,20]{
    PUSH:{
	SEND_COMMAND dvTPecom,"'@PPG-srodekDomofon_volControl'";
    }
}


button_event [dvTPecom,21]
button_event [dvTPecom,22]
button_event [dvTPecom,25]
button_event [dvTPecom,26]
{
    PUSH:{
	
	stack_var char str[26];
	stack_var integer int;
	//send_string 0,"'event: ',itoa(button.input.channel)"
	
	switch (button.input.channel){
	    case 21:{
		str='GAIN';
		if (ecomMicLevel>2){
		    int=ecomMicLevel-2;	
		} else {
		    int=0;
		}
	    }
	    case 22:{
		str='GAIN';
		if (ecomMicLevel<98){
		    int=ecomMicLevel+2;	
		} else {
		    int=100;
		}
	    }
	    case 25:{
		str='VOLUME';
		if (ecomVolLevel>2){
		    int=ecomVolLevel-2;	
		} else {
		    int=0;
		}	
	    }
	    case 26:{
		str='VOLUME';
		if (ecomVolLevel<98){
		    int=ecomVolLevel+2;	
		} else {
		    int=100;
		}		
	    }
	}
    
	SEND_COMMAND dvEcomBrama,"'SET ',str,' ',itoa(int)";
	//send_string 0,"'SET ',str,' ',itoa(int)";
	SEND_COMMAND dvEcomBrama,"'GET ',str";
    }
    
    HOLD [10,REPEAT]:
    {	
	stack_var char str[26];
	stack_var integer int;
	//send_string 0,"'event: ',itoa(button.input.channel)"
	
	switch (button.input.channel){
	    case 21:{
		str='GAIN';
		if (ecomMicLevel>2){
		    int=ecomMicLevel-2;	
		} else {
		    int=0;
		}
	    }
	    case 22:{
		str='GAIN';
		if (ecomMicLevel<98){
		    int=ecomMicLevel+2;	
		} else {
		    int=100;
		}
	    }
	    case 25:{
		str='VOLUME';
		if (ecomVolLevel>2){
		    int=ecomVolLevel-2;	
		} else {
		    int=0;
		}	
	    }
	    case 26:{
		str='VOLUME';
		if (ecomVolLevel<98){
		    int=ecomVolLevel+2;	
		} else {
		    int=100;
		}		
	    }
	}
    
	SEND_COMMAND dvEcomBrama,"'SET ',str,' ',itoa(int)";
	//send_string 0,"'SET ',str,' ',itoa(int)";
	SEND_COMMAND dvEcomBrama,"'GET ',str";
    }
}

button_event [dvTPecom,40]{
    PUSH:{
	
    }
}
(*
LEVEL_EVENT [dvTPecom,21]{
    SEND_COMMAND dvEcomBrama,"'SET GAIN ',itoa(level.value)";
    SEND_COMMAND dvEcomBrama,"'GET GAIN'";
}
LEVEL_EVENT [dvTPecom,25]{
    wait 100{
	SEND_COMMAND dvEcomBrama,"'SET VOLUME ',itoa(level.value)";
	SEND_COMMAND dvEcomBrama,"'GET VOLUME'";
    }
}
*)

data_event [dvEcomBrama]{
    ONLINE:{
	wait 200{
	SEND_COMMAND dvEcomBrama,"'GET GAIN'";
	wait 200{
	SEND_COMMAND dvEcomBrama,"'GET VOLUME'";
	wait 200{
	SEND_COMMAND dvEcomBrama,"'GET CAM-LIGHTLVL'";
	}
	}
	}
    }

    STRING:{
	stack_var char str[30]
	stack_var char varStr[50]	
	stack_var integer f
	
	varStr=data.text;
	SEND_STRING 0,"'ECOM: ',data.text,'xx'";
	f=find_string(varStr,'=',1);
	
	if (f){
	    str=left_string(varStr,f-1);
	    //SEND_STRING 0,"'strToCompare: ',str,'xx'";
	    
	    if (str='GAIN '){
		ecomMicLevel=atoi(right_string(varStr,length_string(varStr)-(f+1)));
		//send_string 0,"'ecomMicLevel: ',itoa(ecomMicLevel)"
		//send_string 0,"'strGain: ',right_string(varStr,length_string(varStr)-(f+1))";
		//send_string 0,"'itoaGain: ',itoa(atoi(right_string(varStr,length_string(varStr)-(f+1))))";
		
		SEND_LEVEL dvTPecom,21,ecomMicLevel;
	    }
	    else if (str='VOLUME '){
		ecomVolLevel=atoi(right_string(varStr,length_string(varStr)-(f+1)));
		//send_string 0,"'ecomVolLevel: ',itoa(ecomVolLevel)"
		//send_string 0,"'strVol: ',right_string(varStr,length_string(varStr)-(f+1))";
		//send_string 0,"'itoaVol: ',itoa(atoi(right_string(varStr,length_string(varStr)-(f+1))))";
		
		SEND_LEVEL dvTPecom,25,ecomVolLevel;
	    }
	    else if (str='CAM-LIGHTLVL '){
		str=right_string(varStr,length_string(varStr)-(f+1));
		send_string 0,"str";
		if (str='NORM'){
		    ecomLightLevel=1;
		}
		else if(str='LOW'){
		    ecomLightLevel=0;
		}
	    }
	}
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
[dvTPecom,1]=[dvEcomBramaRelay,1];
[dvTPecom,2]=[dvEcomBramaIO,1];
[dvEcomBramaRelay,2]=[dvEcomBramaIO,1];
[dvTPecom,30]=ecomLightLevel;

//[dvEcomBramaRelay,1]=[dvEcomBrama,1];






