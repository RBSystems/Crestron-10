PROGRAM_NAME='RGB'
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

CHAR max_RGB_lenght=4 //ilosc obwodow RGB na budynku
DEV dvRGBar[]={dvTPrgb,vdvTPrgb}
INTEGER brRGBset[][]=
{
    {10,1,2,3},		//SalonDol
    {40,5,6,7},		//Lazienka
    {20,9,10,11},	//SalonGora
    {30,13,14,15}	//LazienkaDol
}


long tmRGB1=20;
long tmRGB2=21;
long tmRGB3=22;
long tmRGB4=23;
long tmRGB[]={tmRGB1,tmRGB2,tmRGB3,tmRGB4};

long tmRGBtimes[]={8000};


integer RGBset[3]={0,4,2}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER levXY[max_RGB_lenght][3];
INTEGER aktRGB[max_RGB_lenght][3];
INTEGER aktRGBstate[max_RGB_lenght];
INTEGER joistickRGB[max_RGB_lenght][3];
INTEGER startRGB;
INTEGER startRGB2;


DEFINE_CALL 'brRGBstate'(integer join,integer val){
    stack_var integer k
    stack_var integer m
    
    //send_string 0,"'max 1',itoa(max_length_array(brRGBset))"
    for (k=1;k<=max_length_array(brRGBset);k++){
	for (m=2;m<=4;m++){
	    if (join=brRGBset[k][m]){
		aktRGB[k][m-1]=val;
		
		call 'RGBstateCheck'(k)
		
	    }
	}
    }
}
DEFINE_CALL 'RGBstateCheck' (integer k){
    integer m;
    
    for (m=1;m<=2;m++){
	if (aktRGB[k][m]>0){
	    aktRGBstate[k]=1;
	    
	    [dvTPrgb,brRGBset[k][1]+3]=1;
	    [dvTPrgb,brRGBset[k][1]+9]=1;
	    
	    return;
	}
    }
    aktRGBstate[k]=0;
    [dvTPrgb,brRGBset[k][1]+3]=0;
    [dvTPrgb,brRGBset[k][1]+9]=0;
}

DEFINE_CALL 'XYtoRGB' (integer k){
    stack_var integer niep
    stack_var integer X
    stack_var integer Y
    stack_var integer Z
    stack_var integer RGB[3]
    stack_var integer n
    
    
    set_length_array (RGB,max_length_array(RGB));
    X=levXY[k][1];
    Y=levXY[k][2];
    Z=levXY[k][3];
    
    niep=X/42;
    
    for (n=1;n<=3;n++){
	if (((RGBset[n]+niep)%3)<>1){ 
	    if ((((niep+RGBset[n]+2)%6)/3)=0){
		RGB[n]=255;
	    }else{
		RGB[n]=0;
	    }
	}
	else { 
	    if (((niep+2)%2)=0){
		RGB[n]=(X%42)*6;
	    }else {
		RGB[n]=(42-X%42)*6;
	    }
	}
    }
    
    if (Y<>0){
	for (n=1;n<=3;n++){
	    if (RGB[n]<>255){
		RGB[n]=RGB[n]+((255-RGB[n])*Y/255);
	    }
	}
    }
    
    for (n=1;n<=3;n++){
	RGB[n]=(RGB[n]*(255-Z))/255;
    }
    
    send_string 0,"' R: ',itoa(RGB[1]),' G: ',itoa(RGB[2]),' B: ',itoa(RGB[3])";
    joistickRGB[k][1]=RGB[1]; 
    joistickRGB[k][2]=RGB[2];
    joistickRGB[k][3]=RGB[3];
}

DEFINE_CALL 'setRGBoff' (integer k){
    stack_var char str[80]   
    
    str="itoa(brRGBset[k][2]),'/',itoa(0),'_',itoa(brRGBset[k][3]),'/',itoa(0),'_',itoa(brRGBset[k][4]),'/',itoa(0)"
    //send_string 0,"str" 
    CALL 'brDimVAL'(str)
    
    if (timeline_active(tmRGB[k])){
	timeline_kill(tmRGB[k]);
    }
}

DEFINE_CALL 'setRGB' (integer k){
    stack_var char str[80]
    
    str="itoa(brRGBset[k][2]),'/',itoa(joistickRGB[k][1]),'_',
    itoa(brRGBset[k][3]),'/',itoa(joistickRGB[k][2]),'_',
    itoa(brRGBset[k][4]),'/',itoa(joistickRGB[k][3])"
    //send_string 0,"str"
    CALL 'brDimVAL'(str)
    //#warn 'dodja call'
}

DEFINE_CALL 'setRGBall' (integer k){
    stack_var char str[80]
    stack_var integer n
    for (n=1;n<=max_RGB_lenght;n++){
	str="itoa(brRGBset[n][2]),'/',itoa(joistickRGB[k][1]),'_',
	itoa(brRGBset[n][3]),'/',itoa(joistickRGB[k][2]),'_',
	itoa(brRGBset[n][4]),'/',itoa(joistickRGB[k][3])"
	send_string 0,"str"
	CALL 'brDimVAL'(str)
	//#warn 'dodja call'
    }
}

DEFINE_CALL 'setRGBpreset' (integer k,m){	//!!!opisywać funkce i parametry, bo nie moge
    stack_var char str[80]
    
    str="itoa(brRGBset[k][2]),'/',itoa(RGBpreset[k][m][1]),
    '_',itoa(brRGBset[k][3]),'/',itoa(RGBpreset[k][m][2]),
    '_',itoa(brRGBset[k][4]),'/',itoa(RGBpreset[k][m][3])"
    CALL 'brDimVAL'(str)
}

DEFINE_CALL 'saveRGBpreset' (integer k,m){

    RGBpreset[k][m][1]=aktRGB[k][1];
    RGBpreset[k][m][2]=aktRGB[k][2];
    RGBpreset[k][m][3]=aktRGB[k][3];

    SEND_COMMAND dvTPrgb,"'^BCF-',itoa(brRGBset[k][1]+m+3),',0,#',RGBtoHEX(RGBpreset[k][m][1],RGBpreset[k][m][2],RGBpreset[k][m][3]),'FF'"
}

define_function char[6] RGBtoHEX (integer R, integer G, integer B){
    stack_var integer k;
    stack_var integer m;
    
    stack_var integer rgb[3];
    stack_var char str[6];
    stack_var char hex[2];
    
    
    str='';
    hex='';
    
    rgb[1]=R;
    rgb[2]=G;
    rgb[3]=B;
    
    
    for (k=1;k<=3;k++){
	hex=itohex(rgb[k])
	for (m=length_string(hex);m<2;m++){
	    hex="'0',hex";
	}
	str="str,hex";
    }
    
    return (str);
}

DEFINE_CALL 'RGBrandom' (integer num){
    stack_var integer value;
    stack_var integer color;
    stack_var integer color2;
    
    color=(random_number(12)/4)+2;
    
    value=random_number(256);
    call 'brDimVAL' ("itoa(brRGBset[num][color]),'/',itoa(value)");
    
    color2=color;
    
    while (color=color2){
	color2=(random_number(12)/4)+2;
    }
    
    call 'brDimVAL' ("itoa(brRGBset[num][color2]),'/0'");
    
    //value=random_number(256);
    //call 'brDimVAL' ("itoa(brRGBset[num][3]),'/',itoa(value)");
    
    //value=random_number(256);
    //call 'brDimVAL' ("itoa(brRGBset[num][4]),'/',itoa(value)");
    

/* zmiany calych kolorow 
    stack_var char str[80];
    stack_var integer value;
    stack_var integer color;
    
    stack_var integer k;
    
    str='';
    color=random_number(2)+1
    
    for (k=1;k<=3;k++){
	value=random_number(370)
	if (value<50){
	    value=50;
	}else if(value<=305){
	    value=value-50;
	}
	else{
	    value=255;
	}
	
	if (k=color){
	    value=0;
	}
	
	str="str,itoa(brRGBset[num][k]),'/',itoa(value)";
	
	if (k<3){
	    str="str,'_'";
	}
	
    }
    /*
    str="itoa(brRGBset[num][2]),'/',itoa(random_number(255)),'_',
    itoa(brRGBset[num][3]),'/',itoa(random_number(255)),'_',
    itoa(brRGBset[num][4]),'/',itoa(random_number(255))"
    */
    
    send_string 0,"'RGB: ',str";
    
    CALL 'brDimVAL'(str);
*/
}
(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

(*
INTEGER levXY[max_RGB_lenght][2]
CHAR aktRGB[max_RGB_lenght][3]
CHAR setRGB[max_RGB_lenght][3]
PERSISTENT INTEGER RGBpreset[max_RGB_lenght][3]
*)

set_length_array (levXY,max_length_array(levXY));
for (startRGB=1;startRGB<=max_length_array(levXY);startRGB++){
    set_length_array (levXY[startRGB],max_length_array(levXY[startRGB]));
}

set_length_array (aktRGB,max_length_array(aktRGB));
for (startRGB=1;startRGB<=max_length_array(aktRGB);startRGB++){
    set_length_array (aktRGB[startRGB],max_length_array(aktRGB[startRGB]));
}

set_length_array (joistickRGB,max_length_array(joistickRGB));
for (startRGB=1;startRGB<=max_length_array(joistickRGB);startRGB++){
    set_length_array (joistickRGB[startRGB],max_length_array(joistickRGB[startRGB]));
}

set_length_array (RGBpreset,max_length_array(RGBpreset));
for (startRGB=1;startRGB<=max_length_array(RGBpreset);startRGB++){
    set_length_array (RGBpreset[startRGB],max_length_array(RGBpreset[startRGB]));
    for (startRGB2=1;startRGB2<=max_length_array(RGBpreset[startRGB]);startRGB2++){
	set_length_array (RGBpreset[startRGB][startRGB2],max_length_array(RGBpreset[startRGB][startRGB2]));
    }
}

(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************)


(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)

DEFINE_EVENT

DATA_EVENT [dvTPmain]{
    ONLINE:{
	stack_var k;
	stack_var m;
	
	for (k=1;k<=length_array(RGBset);k++){
	    for (m=1;m<=5;m++){
		SEND_COMMAND dvTPrgb,"'^BCF-',itoa(brRGBset[k][1]+m+3),',0,#',RGBtoHEX(RGBpreset[k][m][1],RGBpreset[k][m][2],RGBpreset[k][m][3]),'FF'"
	    }
	}
    }
}

button_event [dvRGBar,0]{
    RELEASE:{
	stack_var integer k
	stack_var integer l
	
	for (k=1;k<=max_length_array(brRGBset);k++){
	    if (button.input.channel>=brRGBset[k][1]&&button.input.channel<=(brRGBset[k][1]+8)){
		for (l=0;l<=8;l++){
		    if (button.input.channel=(brRGBset[k][1]+l)){
			switch (l){	
			    case 0:{ 
				CALL 'XYtoRGB' (k)
				break;	
			    }
			    case 1:{
				if (timeline_active(tmRGB[k])){
				    timeline_kill(tmRGB[k]);
				}else{
				    timeline_create(tmRGB[k],tmRGBtimes,length_array(tmRGBtimes),timeline_relative,timeline_repeat);
				    call 'RGBrandom' (k);
				}
				break;
			    }
			    case 2:{
				if (button.holdtime<30){
				    CALL 'setRGB'(k)
				}
				break;
			    }
			    case 3:{
				if (button.holdtime<30){
				    CALL 'setRGBoff'(k)
				}
				break;
			    }
			    default :{
				if (button.holdtime<30){
				    CALL 'setRGBpreset'(k,l-3)
				}
				
			    }
			}
			break
		    }
		}
	    break
	    }
	}
    }
    HOLD [30]:{
	stack_var integer k
	stack_var integer l
	stack_var integer n
	
	for (k=1;k<=max_length_array(joistickRGB);k++){
	    if (button.input.channel>=brRGBset[k][1]&&button.input.channel<=(brRGBset[k][1]+8)){
		for (l=0;l<=8;l++){
		    if (button.input.channel=(brRGBset[k][1]+l)){
			switch (l){
			    case 0:{ 
				break;
			    }
			    case 1:{
				break;
			    }
			    case 2:{
				CALL 'setRGBall'(k)
				break;
			    }
			    case 3:{
				for (n=1;n<=max_RGB_lenght;n++){
				    CALL 'setRGBoff'(n)
				}
			    break;
			    }
			    default :{
				CALL 'saveRGBpreset'(k,l-3)				
			    }
			}
			break;
		    }
		}
	    break;
	    }
	}
    }
}

level_event [dvRGBar,0]{
    stack_var integer k
    
    for (k=1;k<=max_length_array(brRGBset);k++){
	if (level.input.level=brRGBset[k][1]){
	    levXY[k][1]=level.value;	    
	}
	else if (level.input.level=(brRGBset[k][1]+1)){
	    levXY[k][2]=level.value;
	}
	else if (level.input.level=(brRGBset[k][1]+3)){
	    levXY[k][3]=level.value;
	}
    }
}



TIMELINE_EVENT [tmRGB1]{
    call 'RGBrandom'(1);
    send_string 0,"'timeline exe1'";
}
TIMELINE_EVENT [tmRGB2]{
    call 'RGBrandom'(2);
    send_string 0,"'timeline exe2'";
}
TIMELINE_EVENT [tmRGB3]{
    call 'RGBrandom'(3);
    send_string 0,"'timeline exe3'";
}
TIMELINE_EVENT [tmRGB4]{
    call 'RGBrandom'(4);
    send_string 0,"'timeline exe4'";
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)




