PROGRAM_NAME='BramkaWAGO'
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

CHAR brP[]={'<<'}; //wpisane recznie w  MultiRoom w call rZoneData
CHAR brK[]={'>>'}; //wpisane recznie w  MultiRoom w call rZoneData
CHAR brWagoIp[]='192.168.0.250';
INTEGER brWagoPort=5000;


DEV brBramkaTPar[]={dvTPbramka,vdvTPbramka};

(*	DIG	*)
DEV brDigTPar[]={vdvTPdig,dvTPdig};
INTEGER brDigLenght=80; //!!! !!! !!! !!! wartosc najwyższego joina typu BOOL wysyłanego do AMX-a !!! !!! !!! !!!
INTEGER brDigSetTP1[][]= 
{			//Pary joinWAGO i chanelTP
    { 2,23},
    { 1,24},
    { 3,39},
    { 4,40},
    { 5,41},
    { 6,42},
    { 7,43},
    { 8,65},
    {10,28},
    {11,31},
    {12,30},
    {13,29},
    {15,32},
    {17,45},
    {18,46},
    {19,47},
    {20,25},
    {21,37},
    {22,36},
    {24,26},
    {23,22},
    {26,19},
    {27,20},
    {28,34},
    {29,35},
    {30, 1},
    {31, 2},
    {33, 4},
    {35,11},
    {36,12},
    {38, 8},
    {39, 9},
    {40,14},
    {41,15},
    {32, 3},
    {42, 5},
    {45, 6},
    {50,16},
    {51,17},
    {44,48},
    {66,50},
    {67,51},
    {68,52},
    {70,57},
    {71,58},
    {72,55},
    {73,56},
    {75,53},
    {76,61},
    {77,60}
};

(*	ROL	*)
DEV brRolTPar[]={vdvTProl,dvTProl};
//INTEGER brRolLenght=10 //wartość najwyższego joina typu Rol wysyłanego do AMX-a
//nie uzywana, bo brakuje logiki odnosnie stanow rolet; robisz to c nacisniesz
INTEGER brRolSetTP1[][]=
{		//Pary joinWAGO i chanelTP (numer pierwszego z 3 kolejnych sterujacych; w kolejności UP, STOP, DOWN)

    {0,35},	//Garaz
    {1,30},	//Kuchnia
    {2,25},	//SalonD
    {3,20},	//Sypialnia
    {4,15},	//PokMamy
    {5, 1},	//PokDziecka
    {6,10},	//LazienkaG	
    {7, 5},	//SalonG
    {9,40},	//SalonG2	
    {8,45}	//Łazienka
   // {10,50}	//Ekran
};



DEV brDimTPar[]={vdvTPdim,dvTPdim};
INTEGER brDimLenght=17; //wartosc najwyższego joina dim wysyłanego do AMX-a
INTEGER brDimSetTP1[][]= 
{			//Pary joinWAGO i chanelTP; chanel Level taki sam jak przycisku
    {17,1}
};


DEV brTempTPar[]={vdvTPtemp,dvTPtemp};
INTEGER brTempLenght=7 //wartosc najwyższego numeru polaczonego BiQ
INTEGER brTempSetTP1[][]= 
{			//Pary joinWAGO i chanelTP; chanel Level taki sam jak przycisku
    {7,10},
    {2,17},
    {1,24},
    {3,33},
    {4,40},
    {6,53},
    {5,60}
};

DEV brScenyTPar[]={dvTPsceny,vdvTPsceny}
INTEGER brScenySetTP1[][]=
{			//Pary joinWAGO i chanelTP; chanel Level taki sam jak przycisku
    {7,1},
    {5,11},	
    {2,21},
    {6,31},
    {3,41},
    {1,51},
    {4,61}
};

LONG coolTieline[]={5000};
INTEGER coolTimelineID=2;

INTEGER trybGlobButtons[]={81,82,83,84,85};
INTEGER trybGlobButtonsIphone[]={6,99,99,12,9};

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE BiQ{
    char sAkt[10]
    char sZad[10]
    char tryb
}

STRUCTURE cool{
    integer chl;
    integer lev;
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile char bWAGO[1500];
volatile char chr;
volatile char brComp[2]={'  '};
volatile char brWord[40];

volatile CHAR brDigState[brDigLenght];

volatile CHAR brDimState[brDimLenght];
volatile CHAR brDimVal[brDimLenght];
CHAR dimHELD;

volatile BiQ brBiQ[brTempLenght];

volatile cool cooling[2];

non_volatile integer errorWago;

volatile integer salonD_dimmer;

volatile integer scenaHold;

volatile integer trybGlobal;
volatile integer varTrybGlobal;

volatile INTEGER goraLev=-1;
volatile INTEGER dolLev=-1;

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

DEFINE_CALL 'brKolejkaIN' (CHAR str_in[30]){
    stack_var CHAR f;
    stack_var CHAR typ[10];
    stack_var CHAR word[20];
    
    //SEND_STRING 0,"'called kolejka IN'"
    

    f=find_string (str_in,'_',1)
    typ=left_string(str_in,f-1)
    word=right_string(str_in,length_string(str_in)-f)
    
    select{
	active (compare_string(typ,'d')):{ //wprowadzić zmiane parametru w CALL 'brDigON','brDigOFF'
	    call 'brDig' (word);
	    //wprowadzić zmiane parametru w CALL 'brRolUP','brRolSTOP','brRolDWN'
	}
	active (compare_string(typ,'m')):{
	    call 'brDim' (word);
	}
	active (compare_string(typ,'t')):{
	    call 'brTemp' (word);
	}
	active (compare_string(typ,'c')):{
	    call 'brCool' (word);
	}
	active (compare_string(typ,'z')):{
	    call 'brMR' (word);
	    //send_string 0,"'bramkam MR: ',word";
	}
	active (compare_string(typ,'g')):{
	    call 'brTrybGlob' (word);
	    send_string 0,"'bramkam trybGlobal: ',word";
	}
	active (compare_string(typ,'p')):{
	    call 'brPogoda' (word);
	    //send_string 0,"'bramkam brPogoda: ',word";
	}
	
	active (1):{
	    errorWago=errorWago+1;
	    send_string 0,"'WARNING: blad danych z wago nr: ',itoa(errorWago),' word: ',word";
	}
    }
  

}

DEFINE_CALL 'Kolejka_OFF'{
    stack_var K;
    
    for (k=1;k<=max_length_array(brDigState);k++){
	brDigState[k]=0;
    }  
    for (k=1;k<=max_length_array(brDimState);k++){
	brDimState[k]=0;
    } 
    for (k=1;k<=max_length_array(brBiQ);k++){
	brBiQ[k].sAkt="";
	brBiQ[k].sZad="";
	brBiQ[k].tryb=0;
    }   
    
}


(************************)
(*	DIG		*)
(************************)
DEFINE_CALL 'brDig' (CHAR str_in[20]){
    stack_var CHAR k
    stack_var CHAR m
    stack_var CHAR f
    stack_var CHAR state
    stack_var INTEGER join

    f=find_string(str_in,'_',1)
    
    join=atoi(left_string(str_in,f-1))
    state=atoi(right_string(str_in,length_string(str_in)-f))
    
    if (join<=max_length_array(brDigState)){
	brDigState[join]=state
    }
    for (k=1;k<=max_length_array(brDigTPar);k++){
	for (m=1;m<=max_length_array(brDigSetTP1);m++){
	    if (brDigSetTP1[m][1]=join){		
		if (state=true){		
		    ON [brDigTPar[k],brDigSetTP1[m][2]]
		}
		else{
		    OFF [brDigTPar[k],brDigSetTP1[m][2]]
		}
		break;
	    }
	}
    }
}
DEFINE_CALL 'brDigON' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'d_',itoa(join),'_1',brK"
	//SEND_STRING 0,"brP,'d_',itoa(join),'_1',brK"
    }
}

DEFINE_CALL 'brDigOFF' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'d_',itoa(join),'_0',brK"
	//SEND_STRING 0,"brP,'d_',itoa(join),'_0',brK"
    }
}


(************************)
(*	ROLETY		*)
(************************)
DEFINE_CALL 'brRolUP' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'r_',itoa(join),'_u',brK"
	//SEND_STRING 0,"brP,'r_',itoa(join),'_u',brK"
    }
}
DEFINE_CALL 'brRolSTOP' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'r_',itoa(join),'_s',brK"
	//SEND_STRING 0,"brP,'r_',itoa(join),'_s',brK"
    }
}
DEFINE_CALL 'brRolDWN' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'r_',itoa(join),'_d',brK"
	//SEND_STRING 0,"brP,'r_',itoa(join),'_d',brK"
    }
}



(************************)
(*	DIM		*)
(************************)
DEFINE_CALL 'brDim' (CHAR str_in[20])
{
    stack_var CHAR k
    stack_var CHAR m
    stack_var CHAR f
    stack_var CHAR val
    stack_var INTEGER join

    f=find_string(str_in,'_',1)
    
    join=atoi(left_string(str_in,f-1))
    val=atoi(right_string(str_in,length_string(str_in)-f))
    
    //send_string 0,"'str: ',str_in";
    //send_string 0,"'join: ',itoa(join)";
    //send_string 0,"'val: ',itoa(val)";
    
    if (join<=max_length_array(brDimState)){
	if (val>brDimVal[join]){
	    brDimState[join]=1
	}
	else{
	    brDimState[join]=0
	}	
	brDimVal[join]=val
	CALL 'brRGBstate' (join,val)
    }
    
    for (k=1;k<=max_length_array(brDimTPar);k++){
	for (m=1;m<=max_length_array(brDimSetTP1);m++){
	    if (brDimSetTP1[m][1]=join){
		if (val){
		    ON [brDimTPar[k],brDimSetTP1[m][2]]
		}
		else{
		    OFF [brDimTPar[k],brDimSetTP1[m][2]]
		}
		SEND_LEVEL brDimTPar[k], brDimSetTP1[m][2],val
		break;		
	    }
	}
    }
}

DEFINE_CALL 'brDimON' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'m_',itoa(join),'_v_255',brK"
	
    }
}

DEFINE_CALL 'brDimOFF' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'m_',itoa(join),'_v_0',brK"
	
    }
}

DEFINE_CALL 'brDimUP' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'m_',itoa(join),'_d_u',brK"
	
    }
}
DEFINE_CALL 'brDimDWN' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'m_',itoa(join),'_d_d',brK"
	
    }
}
DEFINE_CALL 'brDimSTOP' (CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'m_',itoa(join),'_d_s',brK"
	
    }
}

DEFINE_CALL 'brDimVAL' (CHAR str_in[]){
    stack_var CHAR f
    stack_var CHAR str[7]
    stack_var INTEGER join
    stack_var CHAR val
    
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    str=left_string(str_in,f-1)
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    str=str_in
	    str_in=''
	}
	
	f=find_string(str,'/',1)
	join=atoi(left_string(str,f-1))
	val=atoi(right_string(str,length_string(str)-f))
	SEND_STRING dvClientWAGO,"brP,'m_',itoa(join),'_v_',itoa(val),brK"
	//SEND_STRING 0,"brP,'m_',itoa(join),'_v_',itoa(val),brK"
	
    }
}

(************************)
(*	TEMP		*)
(************************)
DEFINE_CALL 'brTemp'(CHAR str_in[]){
    stack_var CHAR k
    stack_var CHAR m
    stack_var CHAR f
    stack_var CHAR typ[2]
    stack_var INTEGER join

    //send_string 0,"str_in";
    f=find_string(str_in,'_',1)
    
    join=atoi(left_string(str_in,f-1))
    
    typ=mid_string(str_in,f+1,1)
    
    if (join<=max_length_array(brBiQ)){
    	select{
	    active (compare_string(typ,'a')):{ 
		brBiQ[join].sAkt=right_string(str_in,(length_string(str_in)-f)-2)
		
		brBiQ[join].sAkt=left_string(brBiQ[join].sAkt,find_string(brBiQ[join].sAkt,'.',1)+1);
		
		for (k=1;k<=max_length_array(brTempTPar);k++){
		    for (m=1;m<=max_length_array(brTempSetTP1);m++){
			if (join=brTempSetTP1[m][1]){
			    //send_string 0,"'temp Akt1',brBiQ[join].sAkt"
			    SEND_COMMAND brTempTPar[k],"'^TXT-',itoa(brTempSetTP1[m][2]+3),',0,',brBiQ[join].sAkt"
			    //send_string 0,"'Akt: ^TXT-',itoa(brTempSetTP1[m][2]+3),',0,',brBiQ[join].sAkt"
			    //send_string 0,"'join: ',itoa(brTempSetTP1[m][2]+3)"
			    break;
			}
		    }
		}
	    }
	    active (compare_string(typ,'z')):{ 
		brBiQ[join].sZad=right_string(str_in,(length_string(str_in)-f)-2)
		
		brBiQ[join].sZad=left_string(brBiQ[join].sZad,find_string(brBiQ[join].sZad,'.',1)+1);
		
		for (k=1;k<=max_length_array(brTempTPar);k++){
		    for (m=1;m<=max_length_array(brTempSetTP1);m++){
			if (join=brTempSetTP1[m][1]){
			    //send_string 0,"'temp Zad1',brBiQ[join].sZad"
			    SEND_COMMAND brTempTPar[k],"'^TXT-',itoa(brTempSetTP1[m][2]+5),',0,',brBiQ[join].sZad"
			    //send_string 0,"'Zad: ^TXT-',itoa(brTempSetTP1[m][2]+5),',0,',brBiQ[join].sZad"
			    //send_string 0,"'join: ',itoa(brTempSetTP1[m][2]+5)"
			    break;
			}
		    }
		}
	    }
	    active (compare_string(typ,'t')):{ 
		brBiQ[join].tryb=atoi(right_string(str_in,(length_string(str_in)-f)-2))
		for (k=1;k<=max_length_array(brTempTPar);k++){
		    for (m=1;m<=max_length_array(brTempSetTP1);m++){
			if (join=brTempSetTP1[m][1]){
			    //send_string 0,"'tryb ',itoa(brBiQ[join].tryb)"
			    //SEND_COMMAND brTempTPar[k],"'^ICO,',itoa(brTempSetTP1[m][2]+1),',0,',itoa(brBiQ[join].tryb)"
			    //SEND_COMMAND 0,"'^ICO,',itoa(brTempSetTP1[m][2]+1),',0,',itoa(brBiQ[join].tryb)"
			    SEND_LEVEL brTempTPar,brTempSetTP1[m][2]+1,brBIQ[join].tryb;
			    //SEND_STRING 0,"'join: ',itoa(brTempSetTP1[m][2]+1),'  value: ',itoa(brBIQ[join].tryb)";
			    break;
			}
		    }
		}
	    }
	    (*
	    active (compare_string(typ,'s')):{ 
		brBiQ[join].shift=atoi(right_string(str_in,length_string(str_in)-f-2))
	    }
	    *)
	}	    
    }
    
}

DEFINE_CALL 'brTempTrybUP'(CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'t_',itoa(join),'_t_u',brK"
	SEND_STRING 0,"brP,'t_',itoa(join),'_t_u',brK"
	
    }
}

DEFINE_CALL 'brTempTrybDWN'(CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'t_',itoa(join),'_t_d',brK"
	
    }
}

DEFINE_CALL 'brTempShiftUP'(CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'t_',itoa(join),'_z_u',brK"
	
    }
}

DEFINE_CALL 'brTempShiftDWN'(CHAR str_in[]){
    stack_var CHAR f
    stack_var INTEGER join
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    join=atoi(left_string(str_in,f-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    join=atoi(str_in)
	    str_in=''
	}
	SEND_STRING dvClientWAGO,"brP,'t_',itoa(join),'_z_d',brK"
	
    }
}


DEFINE_CALL 'brTempScena'(CHAR str_in[]){
    stack_var CHAR f
    stack_var CHAR ff
    stack_var CHAR str[7]
    stack_var INTEGER join
    stack_var INTEGER scn
    
    (*
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	ff=find_string(str_in,'/',1)
	join=atoi(left_string(str_in,ff-1))
	
	if (f){
	    scn=atoi(mid_string(str_in,ff+1,f-ff-1))
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    scn=atoi(mid_string(str_in,ff+1,LENGTH_STRING(str_in)-ff-1))
	    send_string 0,"'scn: ',mid_string(str_in,ff+1,LENGTH_STRING(str_in)-ff-1)"
	    str_in=''
	}
	//SEND_STRING dvClientWAGO,"brP,'t_',itoa(join),'_s_',itoa(scn),brK"
	SEND_STRING 0,"brP,'t_',itoa(join),'_s_',itoa(scn),brK"
	
    }
    *)
    
    
    while (length_string(str_in)){
	f=find_string(str_in,'_',1)
	
	if (f){
	    str=left_string(str_in,f-1)
	    str_in=right_string(str_in,LENGTH_STRING(str_in)-f)
	    
	}
	else{
	    str=str_in
	    str_in=''
	}
	
	f=find_string(str,'/',1)
	join=atoi(left_string(str,f-1))
	scn=atoi(right_string(str,length_string(str)-f))
	
	SEND_STRING dvClientWAGO,"brP,'t_',itoa(join),'_s_',itoa(scn),brK"
	
    }
}


DEFINE_CALL 'brCool'(char str[]){
    stack_var integer join;
    stack_var integer f;
    stack_var char type[2];
    
    f= find_string(str,'_',1);
    
    if (f){
	join=atoi(left_string(str,f-1));
	
	type=mid_string(str,f+1,1);
	
	select{
	    active (compare_string(type,'c')):{
		cooling[join].chl=atoi(right_string(str,length_string(str)-f-2));
	    }
	    active (compare_string(type,'l')):{
		cooling[join].lev=atoi(right_string(str,length_string(str)-f-2));
		SEND_LEVEL dvTPtemp,join,cooling[join].lev;
	    }
	}	
	
	TIMELINE_KILL(coolTimelineID);
	
	TIMELINE_CREATE (coolTimelineID,coolTieline,length_array(coolTieline),TIMELINE_RELATIVE,TIMELINE_REPEAT);
    }
}

DEFINE_CALL 'brMR' (char str[]){
    stack_var integer join;
    stack_var integer f;
    stack_var char type[2];
    stack_var char act[2];
    
    f= find_string(str,'_',1);
    
    if (f){
	join=atoi(left_string(str,f-1));
	
	type=mid_string(str,f+1,1);
	
	
	select{
	    active (compare_string(type,'v')):{
		act=right_string(str,length_string(str)-f-2);
		if (act='u'){
		    call 'mrVolUP' (join);
		}
		else {
		    call 'mrVolDWN' (join);
		}
	    }
	    active (compare_string(type,'s')):{
		act=right_string(str,length_string(str)-f-2);
		
		
		
		send_string 0,"'brMR act1: ',act";
		select {
		    active (act='z'):{
			//wysyłanie zrodla do WAGO
			SEND_STRING dvClientWAGO,"brP,'z_',itoa(join),'_s_',itoa(Zones[join].src),brK"
			
			    //send_string 0,"'brMR act ? : ',act";	
		    }
		    active (act='0'):{	
			call 'mrPowerOFF' (join);
			    //send_string 0,"'brMR act0: ',act";
		    }
		    active (true):{
			
			if (1<=atoi(act) && atoi(act)<=8){
			    call 'mrSourceSelect' (join,atoi(act));
			    
			    //send_string 0,"'brMR act true: ',act,' atoi: ',itohex(act)";
			    
			}
		    }
		}
	    }
	    active (compare_string(type,'c')):{ //!!!!dodać PREV i NEXT w zależności od zrodla
		act=right_string(str,length_string(str)-f-2);
		if (act='n'){
		    call 'mrSourceNext' (Zones[join].src);
		}
		else if (act='p'){
		    call 'mrSourceNext' (Zones[join].src);
		}
	    }
	    active (compare_string(type,'p')):{
		act=right_string(str,length_string(str)-f-2);
		if (act='o'){
		    call 'mrPowerON' (join);
		}
		else{
		    call 'mrPowerOFF' (join);
		
		}
	    }
	}	
    }
}

DEFINE_CALL 'brTrybGlob' (char str[]){
    stack_var k;
    trybGlobal = atoi(str);
    
    for (k=1;k<=length_array(trybGlobButtons);k++){ //przyciski na wiz na Panelu i na Iphonie
	if (k=trybGlobal){
	    ON [dvTPmain,trybGlobButtons[k]];
	    ON [VIRTUALKEYPAD,trybGlobButtonsIphone[k]];
	} else{
	    OFF [dvTPmain,trybGlobButtons[k]];
	    OFF [VIRTUALKEYPAD,trybGlobButtonsIphone[k]];
	}
    }
    
    
    for (k=1;k<=length_array(trybGlobButtons);k++){ //przyciski na wiz na Panelu
	if (k=trybGlobal){
	    ON [dvTPmain,trybGlobButtons[k]];
	} else{
	    OFF [dvTPmain,trybGlobButtons[k]];
	}
    }
    
    
    
    send_level dvTPmain,85,trybGlobal;
    
    //logika trybów 
    if (varTrybGlobal<>trybGlobal){
	
	switch (trybGlobal){
	    case 2:{ (*wychodze*)
		for (k=1;k<=maxZones;k++){
		    call 'mrPowerOFF' (k);
		}
	    }
	    case 3:{ (*noc*)
		for (k=1;k<=maxZones;k++){
		    call 'mrPowerOFF' (k);
		}
	    }
	    case 5:{ (*noc*)
		for (k=1;k<=maxZones;k++){
		    call 'mrPowerOFF' (k);
		}
	    }
	}
	
	varTrybGlobal=trybGlobal;
    }
    
}

DEFINE_CALL 'brTrybGlobSEND' (integer tr){
    SEND_STRING dvClientWAGO,"brP,'g_',itoa(tr),brK";
    //send_string 0,"brP,'g_',itoa(tr),brK";
}

DEFINE_CALL 'brPogoda' (char str[]){
    stack_var char type;
    stack_var char dat[10];
    
    type=str[1];
    
    dat=right_string(str,length_string(str)-2);
    
    
    select{
	active (type='t'):{
	    dat=left_string(dat,find_string(dat,'.',1)+1);
	    
	    SEND_COMMAND dvTPmain,"'^TXT-90,0,',dat,' C'"
	    
	    //send_string 0,"'^TXT-90,0,',dat,' C'";
	}
	active (type='w'):{
	    if (find_string(dat,'.',1)){
		dat=left_string(dat,find_string(dat,'.',1)+1);
	    }
	    
	    SEND_COMMAND dvTPmain,"'^TXT-91,0,',dat,' m/s'"
	    
	    //send_string 0,"'^TXT-91,0,',dat,' m/s'"
	}
	active (type='r'):{
	    if (dat='1'){
		ON [dvTPmain,92];
	    } else{
		OFF [dvTPmain,92];
	    }
	}
    }
}




DEFINE_START


set_length_array(brDigState,brDigLenght);
set_length_array(brDimState,brDimLenght);
set_length_array(brDimVal,brDimLenght);
set_length_array(brBiQ,brTempLenght);

set_length_array(cooling,max_length_array(cooling));

CREATE_BUFFER  dvClientWAGO,bWAGO;
IP_CLIENT_OPEN (dvClientWAGO.PORT,brWagoIp,brWagoPort,1);


TIMELINE_CREATE (coolTimelineID,coolTieline,length_array(coolTieline),TIMELINE_RELATIVE,TIMELINE_REPEAT);


//set_virtual_level_count (dvTPtemp,61);
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

data_event [dvTPmain]{ //pilnowanie zapytan o tryb
    STRING:{
	stack_var str[40]
	
	str=data.text;
	
	//send_string 0,"'string: ',str";
	
	select{
	    active (left_string(str,3)='@PP'): {
		stack_var f;
		stack_var ff;
		
		f=find_string (str,"'-'",1);
		ff=find_string(str,"';'",1);
		
		str=mid_string(str,f+1,ff-f-1);
		
		
		select{
		    active (str='trybyGlowne'): {	
			call 'brTrybGlobSEND' (0);
		    }
		}
		
	    }
	}
    }
}
data_event [dvClientWAGO]{
    ONLINE:{
	SEND_STRING 0,"'polaczony'"	
    }
    OFFLINE:{
	SEND_STRING 0,"'rozloczony'"
	IP_CLIENT_OPEN (dvClientWAGO.PORT,brWagoIp,brWagoPort,1)
    }
    ONERROR:{
	cancel_wait 'TCPerror'
	wait 30*10 'TCPerror'{
	    IP_CLIENT_OPEN (dvClientWAGO.PORT,brWagoIp,brWagoPort,1)
	}
    }
}

(*	BRAMAKA	*)
button_event [brBramkaTPar,1]	//brama garazowa1
button_event [brBramkaTPar,2]	//brama garazowa2
button_event [brBramkaTPar,3]{	//brama wjazdowa
    PUSH:{
	CALL 'brDigON' ("itoa(button.input.channel+45)")
	if (TIMELINE_ACTIVE(1)){
	    TIMELINE_KILL(1);
	}
	wait 7{
	    CALL 'brDigOFF' ('46_47_48')	
	}
    }
}

(*	DIG	*)
button_event [brDigTPar,0]{
    PUSH:{
	stack_var CHAR k
	//dodać array TPset-ów
	//SEND_STRING 0,"'przycisk :',itoa(button.input.channel)"
	//SEND_STRING 0,"'max_State: ',itoa(max_length_array(brDigState))"
	//SEND_STRING 0,"'act_State: ',itoa(length_array(brDigState))"
	for (k=1;k<=max_length_array(brDigSetTP1);k++){
	    if (button.input.channel=brDigSetTP1[k][2]){
		//SEND_STRING 0,"'przycisk ',itoa(button.input.channel),' join ',itoa(brDigSetTP1[k][2])"
		//SEND_STRING 0,"'stan ',itoa(brDigSetTP1[k][1]),' ',itoa(brDigState[brDigSetTP1[k][1]])"
		
		if (brDigState[brDigSetTP1[k][1]]){
		    CALL 'brDigOFF' ("itoa(brDigSetTP1[k][1])")
		}
		else{
		    CALL 'brDigON' ("itoa(brDigSetTP1[k][1])")
		}
	    }
	}
    }
    HOLD[30]:{
	stack_var CHAR k
	//dodać array TPset-ów
	for (k=1;k<=max_length_array(brDigSetTP1);k++){
	    if (button.input.channel=brDigSetTP1[k][2]){
		if (brDigState[brDigSetTP1[k][1]]){
		   CALL 'brDigON' ("itoa(brDigSetTP1[k][1])")
		   CALL 'brDigOFF' ("itoa(brDigSetTP1[k][1])")
		}
		else{
		   CALL 'brDigOFF' ("itoa(brDigSetTP1[k][1])")
		   CALL 'brDigON' ("itoa(brDigSetTP1[k][1])")
		}
	    }
	}
    }
}

(*	ROL	*)
button_event [brRolTPar,0]{
    PUSH:{
	
	
	stack_var CHAR k;
	stack_var CHAR m;
	//dodać array TPset-ów;
	
	
	for (k=1;k<=max_length_array(brRolSetTP1);k++){
	    if (button.input.channel>=brRolSetTP1[k][2] && button.input.channel<=(brRolSetTP1[k][2]+2)){
		m=button.input.channel - brRolSetTP1[k][2];
		switch (m){
		    case 0:{
			CALL 'brRolUP' (itoa(brRolSetTP1[k][1]))
		    }
		    case 1:{
			CALL 'brRolSTOP' (itoa(brRolSetTP1[k][1]))
		    }
		    case 2:{
			CALL 'brRolDWN' (itoa(brRolSetTP1[k][1]))
		    }
		}
		
		(*
		for (m=0;m<3;m++){
		    if (button.input.channel=(brRolSetTP1[k][2]+m)){
			switch (m){
			    case 0:{
				CALL 'brRolUP' (itoa(brRolSetTP1[k][1]))
			    }
			    case 1:{
				CALL 'brRolSTOP' (itoa(brRolSetTP1[k][1]))
			    }
			    case 2:{
				CALL 'brRolDWN' (itoa(brRolSetTP1[k][1]))
			    }
			}
		    break
		    }
		    
		}
		*)
	    }
	}
    }
    HOLD[30]:{
	stack_var CHAR k
	stack_var CHAR m
	stack_var CHAR n
	stack_var CHAR str[100]
	//dodać array TPset-ów
	
	for (k=1;k<=max_length_array(brRolSetTP1);k++){
	    if ((button.input.channel>=brRolSetTP1[k][2]) && (button.input.channel<=(brRolSetTP1[k][2]+2))){
		for (m=0;m<3;m++){
		    if (button.input.channel=(brRolSetTP1[k][2]+m)){
			for (n=1;n<=max_length_array(brRolSetTP1);n++){
			    if (length_string(str)>0){
				str="str,'_',itoa(brRolSetTP1[n][1])"
			    }
			    else{
				str="itoa(brRolSetTP1[n][1])"
			    }
			}
			
			switch (m){
			    case 0:{
				CALL 'brRolUP' (str)
			    }
			    case 1:{
				CALL 'brRolSTOP' (str)
			    }
			    case 2:{
				CALL 'brRolDWN' (str)
			    }
			}
			break
		    }
		}
		break
	    }
	}
    }
}

button_event [brRolTPar,50]
button_event [brRolTPar,51]
button_event [brRolTPar,52]{	//sterowanie ekranem 
    PUSH:{
	integer m;
	
	m=button.input.channel-50;
	switch (m){
	    case 0:{
		CALL 'brRolUP' ("'10'");
	    }
	    case 1:{
		CALL 'brRolSTOP' ("'10'");
	    }
	    case 2:{
		CALL 'brRolDWN' ("'10'");
	    }
	}
    }    
}
(*	DIM	*)
button_event [brDimTPar,0]{
    RELEASE:{
	
	stack_var CHAR k
	//dodać array TPset-ów
	//send_string 0,"'release'";
	for (k=1;k<=max_length_array(brDimSetTP1);k++){
	    if (button.input.channel=brDimSetTP1[k][2]){
		if (dimHELD){
		    CALL 'brDimSTOP' ("itoa(brDimSetTP1[k][1])");
		    //send_string 0,("'stop: ',itoa(brDimSetTP1[k][1])");
		}
		else{
		    if (brDimVal[brDimSetTP1[k][1]]){
			CALL 'brDimOFF' ("itoa(brDimSetTP1[k][1])");
			//send_string 0,("'off: ',itoa(brDimSetTP1[k][1])");
		    }
		    else{
			CALL 'brDimON' ("itoa(brDimSetTP1[k][1])");
			//send_string 0,("'on: ',itoa(brDimSetTP1[k][1])");
		    }
		}
	    }
	}
	dimHELD=0
    }
    HOLD[30]:{
	stack_var CHAR k
	//dodać array TPset-ów
	//send_string 0,"'release'";
	
	dimHELD=1
	for (k=1;k<=max_length_array(brDimSetTP1);k++){
	    if (button.input.channel=brDimSetTP1[k][2]){
		if (brDimState[brDimSetTP1[k][1]]){
		    CALL 'brDimDWN' ("itoa(brDimSetTP1[k][1])");
		    //send_string 0,("'dimDwn: ',itoa(brDimSetTP1[k][1])");
		}
		else{
		    CALL 'brDimUP' ("itoa(brDimSetTP1[k][1])");
		    //send_string 0,("'dimUP: ',itoa(brDimSetTP1[k][1])");
		}
	    }
	}
    }
}

(*	TEMP	*)
button_event [brTempTPar,0]{
    RELEASE:{
	
	stack_var CHAR k
	stack_var CHAR m
	//dodać array TPset-ów
	for (k=1;k<=max_length_array(brTempSetTP1);k++){
	    if (button.input.channel>=brTempSetTP1[k][2]&& button.input.channel<=brTempSetTP1[k][2]+6){
		for (m=0;m<7;m++){
		    if (button.input.channel=(brTempSetTP1[k][2]+m)){
			//send_string 0,"'m: ',itoa(m)"
			switch (m){
			    case 0:{
				CALL 'brTempTrybUP' (itoa(brTempSetTP1[k][1]))
			    }
			    case 1:{
				CALL 'brTempTrybUP' (itoa(brTempSetTP1[k][1]))
			    }
			    case 2:{
				CALL 'brTempTrybDWN' (itoa(brTempSetTP1[k][1]))
			    }
			    case 4:{
				CALL 'brTempShiftUP' (itoa(brTempSetTP1[k][1]))
			    }
			    case 5:{
				CALL 'brTempShiftUP' (itoa(brTempSetTP1[k][1]))
			    }
			    case 6:{
				
				CALL 'brTempShiftDWN' (itoa(brTempSetTP1[k][1]))
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

(*	SCENY	*)

button_event [brScenyTPar,0]{
    RELEASE:{	
	stack_var CHAR k
	stack_var CHAR m
	//dodać array TPset-ów
	
	if (scenaHold=0){
	    for (k=1;k<=max_length_array(brScenySetTP1);k++){
		if (button.input.channel>=brScenySetTP1[k][2] && button.input.channel<=(brScenySetTP1[k][2]+3)){
		    for (m=0;m<4;m++){
			if (button.input.channel=(brScenySetTP1[k][2]+m)){
			    //SEND_STRING 0,"'SCENA: ',itoa(brScenySetTP1[k][1]),'/',itoa(m)";
			    CALL 'brTempScena' ("itoa(brScenySetTP1[k][1]),'/',itoa(m)")
			break
			}
		    }
		}
	    }
	}
	
	scenaHold=0;
    }
    
    HOLD[30]:{
	stack_var CHAR k
	stack_var CHAR m
	//dodać array TPset-ów
	
	scenaHold=1;
	
	for (k=1;k<=max_length_array(brScenySetTP1);k++){
	    if (button.input.channel>=brScenySetTP1[k][2] && button.input.channel<=(brScenySetTP1[k][2]+3)){
		for (m=0;m<4;m++){
		    if (button.input.channel=(brScenySetTP1[k][2]+m)){
			CALL 'brTempScena' ("itoa(brScenySetTP1[k][1]),'/',itoa(m+128)")
			SEND_STRING 0,"'SCENA: ',itoa(brScenySetTP1[k][1]),'/',itoa(m+128)";
		    break
		    }
		    
		}
	    }
	}
    
    }
}

level_event [dvTPdim,1]{
    salonD_dimmer=level.value;
}

button_event [dvTPdim,2]{
    RELEASE:{
	call 'brDimVAL' ("'17/',itoa(salonD_dimmer)");
	send_string 0,("'17/',itoa(salonD_dimmer)");
    }	
}

button_event [dvTPsceny,9]{
    push:{
	call 'brDigOFF' ('4_5_6');
	call 'brDimOFF' ('1_2_3_13_14_15_17');
    }
}
button_event [dvTPsceny,39]{
    push:{
	call 'brDigOFF' ('30_31_32');
    }
}
button_event [dvTPsceny,69]{
    push:{
	call 'brDigOFF' ('38_39');
    }
}
button_event [dvTPsceny,49]{
    push:{
	call 'brDigOFF' ('35_36');
    }
}
button_event [dvTPsceny,19]{
    push:{
	call 'brDigOFF' ('40_41_42_33_50_51');
	call 'brDimOFF' ('9_10_11');
    }
}
button_event [dvTPsceny,29]{
    push:{
	call 'brDigOFF' ('40_41_42_33');
	//call 'brDimOFF' ('5_6_7');
    }
}

button_event [dvTPsceny,59]{
    push:{
	call 'brDigOFF' ('17_18_19');
	call 'brDimOFF' ('5_6_7');
    }
}

button_event [dvTPmain,81]
button_event [dvTPmain,82]
button_event [dvTPmain,83]
button_event [dvTPmain,84]
button_event [dvTPmain,85]{//tryby Globalne
    PUSH:{
	call 'brTrybGlobSEND' (button.input.channel-80);
    }
    
}

button_event [dvTPdig,6]{
    push:{
	call 'brDigON' ('46');
	wait 10 {
	    call 'brDigOFF' ('46_47_48');
	}
    }	
    
}

timeline_event [coolTimelineID]{ //wysylanie IR do klimatyzacji
    
    // LEGENDA
    //
    // A) dvInputs (1 i 2) - stycznik dla klimatyzacji (odp.: dół i góra)
    //    
    //	  Przyjmowane wartości - 0 (wyłączone)
    //				 1 (włączone)
    //
    // -------------------------------------------------------------------
    //
    // B) cooling[].chl - zapotrzebowanie na chłodzenie
    //
    //    Przyjmowane wartości - 0 (chłodzenie niepotrzebne)
    //				 1 (chłodzenie potrzebne)
    //
    // -------------------------------------------------------------------
    //
    // C) cooling[].lev - bieg wentylacji (do spr.)
    //
    //    Przyjmowane wartości - 1
    //				 2
    //			  	 3
    //
    // -------------------------------------------------------------------
    //
    // D) dvIrKlimaDol | dvIrKlimaGora - wyjścia IR dla klimatyzacji
    //
    //    Dostępne polecenia:
    //
    //    10) Start - przełącznik zasilania klimatyzacji
    //
    //    20) cold 16 min - chłodzenie na I biegu
    //    21) cold 16 mid - chłodzenie na II biegu
    //    22) cold 16 max - chłodzenie na III biegu
    //
    //    30) heat 30 min - grzanie na I biegu
    //    30) heat 30 mid - grzanie na II biegu
    //    30) heat 30 max - grzanie na III biegu
    //
    // -------------------------------------------------------------------

    // Klimatyzacja Góra - START
    
    if (cooling[1].chl != [dvInputs, 1])
    {
	//send_string 0, "'[GORA] change : power'"
	PULSE [dvIrKlimaGora, 10];
    }
    
    wait 20
    {
	if (goraLev != cooling[1].lev)
	{
	    goraLev = cooling[1].lev;
	    PULSE [dvIrKlimaGora, cooling[1].lev + 19];
	    //send_string 0, "'[GORA] change : level'";
	}
    }
    
    //wait 70 send_string 0, "'[GORA] - powerNeed: ', itoa(cooling[1].chl), ' | powerState: ', itoa([dvInputs, 1]), ' | level: ', itoa(cooling[1].lev)";
    
    // Klimatyzacja Góra - STOP
    
    // Klimatyzacja Dół - START
    
    if (cooling[2].chl != [dvInputs,2])
    {
	//send_string 0, "'[DOL] change : power'"
	PULSE [dvIrKlimaDol, 10];
    }
    
    wait 21
    {
	if (dolLev != cooling[2].lev)
	{
	    dolLev = cooling[2].lev;
	    PULSE [dvIrKlimaDol, cooling[2].lev + 19];
	    //send_string 0, "'[DOL] change : level'";
	}
    }
    
    //wait 71 send_string 0, "'[DOL] - powerNeed: ', itoa(cooling[2].chl), ' | powerState: ', itoa([dvInputs, 2]), ' | level: ', itoa(cooling[2].lev)";
    
    // Klimatyzacja Dół - STOP
    
}



(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

if (length_string(bWAGO))
{    	
    chr=get_buffer_char(bWAGO)
    
    brComp="right_string(brComp,1),chr"
    if (compare_string(brComp,brP)){
	brWord="''";
    }
    else if (compare_string(brComp,brK)){
	brWord="left_string(brWord,length_string(brWord)-1)"
	//SEND_STRING 0,"'Word: ',brWord"
	CALL 'brKolejkaIN' (brWord);
    }
    else{
	brWord="brWord,chr";
    }    
}

[brBramkaTPar,1]=brDigState[45];
[brBramkaTPar,4]=brDigState[44];


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)