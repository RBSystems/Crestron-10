PROGRAM_NAME='PTZ'

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

char ptzSrc[] = {$00,$01};
char ptzDev[] = {$00,$01};

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile integer ptzCamContol;
volatile integer ptzCamZoomState;

volatile integer errorSubPageRetPTZ;
(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)

DEFINE_CALL 'ptzSend' (char str[]) {
    stack_var char crc;
    stack_var integer i;
    
    stack_var char testStr[60];
    stack_var integer k;
    
    crc=ptzSrc[1]+ptzSrc[2]+ptzDev[1]+ptzDev[2];
    
    for (i=1;i<=length_string(str);i++){
	crc=crc+str[i];
    }
    crc=crc BAND $FF; 
    
    send_string dvRejestrator,"$82,ptzSrc,ptzDev,str,crc";
    
    str="$82,ptzSrc,ptzDev,str,crc";
    
    testStr='';
    for (k=1;k<=length_string(str);k++){
	testStr="testStr,' 0x',itohex(str[k])";
    }
    
    send_string 0,"'test: ',testStr";
}

DEFINE_CALL 'ptzChanelSelect' (integer chan){
    call 'ptzSend' ("$C0,$01,chan-1");
}
DEFINE_CALL 'ptzDisplay' {
    call 'ptzSend' ("$C1,$00");
}
DEFINE_CALL 'ptzControlEnter' {
    call 'ptzSend' ("$D9,$00");
}
DEFINE_CALL 'ptzControlExit' {
    call 'ptzSend' ("$DA,$00");
}
DEFINE_CALL 'ptzControlUPpress' {
    call 'ptzSend' ("$CC,$01,$01");
}
DEFINE_CALL 'ptzControlUPrelease' {
    call 'ptzSend' ("$CC,$01,$00");
}
DEFINE_CALL 'ptzControlDWNpress' {
    call 'ptzSend' ("$CD,$01,$01");
}
DEFINE_CALL 'ptzControlDWNrelease' {
    call 'ptzSend' ("$CD,$01,$00");
}
DEFINE_CALL 'ptzControlLEFTpress' {
    call 'ptzSend' ("$CB,$01,$01");
}
DEFINE_CALL 'ptzControlLEFTrelease' {
    call 'ptzSend' ("$CB,$01,$00");
}
DEFINE_CALL 'ptzControlRIGHTpress' {
    call 'ptzSend' ("$CA,$01,$01");
}
DEFINE_CALL 'ptzControlRIGHTrelease' {
    call 'ptzSend' ("$CA,$01,$00");
}
DEFINE_CALL 'ptzControlZoomINpress' {
    call 'ptzSend' ("$D4,$01,$01");
}
DEFINE_CALL 'ptzControlZoomINrelease' {
    call 'ptzSend' ("$D4,$01,$00");
}
DEFINE_CALL 'ptzControlZoomOUTpress' {
    call 'ptzSend' ("$D3,$01,$01");
}
DEFINE_CALL 'ptzControlZoomOUTrelease' {
    call 'ptzSend' ("$D3,$01,$00");
}


DEFINE_EVENT

data_event [dvTPmain]{
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
		    errorSubPageRetPTZ++;
		    send_string 0,"'!!!UWAGA!!! blad odzyskiwnia stanu strony nr: ',itoa(errorSubPageRetPTZ)";
		}
		
		f=find_string (str,"'-'",1);
		ff=find_string(str,"';'",1);
		
		str=mid_string(str,f+1,ff-f-1);
		
		
		select{
		    active (str='Navigation-Alarm'): {
			//send_string 0,"'strerowaine PTZ: ',itoa(st)";
			
			ptzCamContol=st;
			
			if (st){
			    call 'ptzControlEnter';
			}
			else {
			    call 'ptzControlExit';
			}
		    }
		}
		
	    }
	}
    }
}

data_event [dvRejestrator]{
    ONLINE:{
	SEND_COMMAND dvRejestrator,"'SET BAUD 9600,N,8,1, 485 Enable'";
	
	wait 100{
	    SEND_COMMAND dvRejestrator,"'GET BAUD'";
	}
    }
    command:{
	send_string 0,"'rej com: ',data.text";
    }
    string:{
	send_string 0,"'rej str: ',data.text";
    }
}

button_event [dvTPmain,1]{ // HARDkey UP
    push: {
	if (ptzCamContol){
	    call 'ptzControlZoomINpress';
	}
    }
    release:{
	if (ptzCamContol){
	    call 'ptzControlZoomINrelease';
	}
    }
}

button_event [dvTPmain,2]{ // HARDkey UP
    push: {	
	if (ptzCamContol){
	    call 'ptzControlZoomOUTpress';
	}
    }
    release:{
	if (ptzCamContol){
	    call 'ptzControlZoomOUTrelease';
	}
    }
}
button_event [dvTPmain,10]{ // HARDkey UP
    push: {
	if (ptzCamContol){
	    call 'ptzControlUPpress';
	}
    }
    release:{
	if (ptzCamContol){
	    call 'ptzControlUPrelease';
	}
    }
}
button_event [dvTPmain,11]{ // HARDkey DWN
    push: {
	if (ptzCamContol){
	    call 'ptzControlDWNpress';
	}
    }
    release:{
	if (ptzCamContol){
	    call 'ptzControlDWNrelease';
	}
    }
}
button_event [dvTPmain,12]{ // HARDkey LEFT
    push: {
	if (ptzCamContol){
	    call 'ptzControlLEFTpress';
	}
    }
    release:{
	if (ptzCamContol){
	    call 'ptzControlLEFTrelease';
	}	
    }
}
button_event [dvTPmain,13]{ // HARDkey RIGHT
    push: {
	if (ptzCamContol){
	    call 'ptzControlRIGHTpress';
	}
    }
    release:{
	if (ptzCamContol){
	    call 'ptzControlRIGHTrelease';
	}
    }
}


button_event [dvTPalarm,2]{ // TEST
    push:{
	call 'ptzSend' ("$80,$02,$03,$12");
    }
}
button_event [dvTPalarm,1]{ // Display
    push:{
	call 'ptzControlExit';
	call 'ptzDisplay';
	call 'ptzControlEnter';
    }
}
button_event [dvTPalarm,11]
button_event [dvTPalarm,12]
button_event [dvTPalarm,13]
button_event [dvTPalarm,14]
button_event [dvTPalarm,15]
button_event [dvTPalarm,16]
button_event [dvTPalarm,17]
button_event [dvTPalarm,18]
button_event [dvTPalarm,19]{ // Zazanczenie Kamery
    push:{
	call 'ptzControlExit';
	call 'ptzChanelSelect' (button.input.channel-10);
	call 'ptzControlEnter';
    }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)


(***********************************************************)

