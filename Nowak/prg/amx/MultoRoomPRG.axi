PROGRAM_NAME='MultoRoomPRG'



// *******
//obs³uga danych przychodz¹cych z SC
[dvTPmr,2]=projekcja;

lenbSC=length_string(bSC);

if (lenbSC>=(max_length_array(bSC)-10)){
    errorBufEx++;
    send_string 0,"'WARNING: Przepelniono Buffer nr: ',itoa(errorBufEx), 'len" ',itoa(lenbSC)";
    clear_buffer bSC;
}

if (lenbSC){
    stack_var integer f;
    //stack_var char srch;
    //srch = $55;
    //find_string(bSC,srch,1)
    
    f=find_string(bSC,"$55",1);	//byte snchronizacji;
    
    if (f){
	stack_var integer k;
	stack_var integer count;
	
	//send_string 0,"'znaleziono: ',itoa(f)";
	
	
	count=bSC[f+1];		//domniemana d³ugoœæ stringu
	
	if (lenbSC>=(f+count)){		//sprawdzanie czy stroing jest ca³y w buferze
	    //send_string 0,"'string caly'";
	    sum=0;
	    for (k=f;k<f+count;k++){	//liczenie prostej sumy
		//SEND_STRING 0,"'liczona litera',itoa(bSC[k])";
		sum=sum+bSC[k];	    
	    }
	    
	    sum=256-sum;
	    
	    //SEND_STRING 0,"'suma w dec: ',itoa(sum)";
	    //SEND_STRING 0,"'suma w dec: ',itoa(bSC[(f+count)])";
	    
	    
	    //sprawdzanie prostej sumy i albo odzysykiwanie polecenia albo usuwanie teoretycznie blednych danych
	    //az do kolejnego bajtu synchronizacji
	    
	    if (sum==bSC[(f+count)]){	
		//send_string 0,"'odzyskano dobrze'"
		cancel_wait 'waitForSCans'
		
		call 'Recive' (mid_string(bSC,f+2,count-2));
		bSC=right_string(bSC,lenbSC-f-count);
	    }
	    else{
		stack_var integer ff;
		ff=find_string (bSC,$55,f+2);
		if (ff){
		    stack_var char trash[100];
		    
		    trash=remove_string(bSC,"$55",1);
		    
		    errorString++;
		    SEND_STRING 0,"'WARNING: usunieto teoretycznie bledny string nr: ',itoa(errorString)";
		}
		else{
		    CLEAR_BUFFER bSC;
		    
		    errorBuffer++;
		    SEND_STRING 0,"'WARNING: usunieto teoretycznie bledny buffer nr: ',itoa(errorBuffer)";
		}
	    }
	}	
    }
} 

// *******************
//wysy³anie poleceñ do SC
//wraz z semaforem (resetowanie gdzie indziej)
//oraz obliczaniem sumy kontrolnej
if ((length_array(kolSC)) && !(semSendSC)){
    stack_var char str[100];
    stack_var char test[100];
    stack_var char sum;
   // stack_var char len;
    stack_var integer k;

    semSendSC=1;	//semafor
    
    str=kolSC[1];
    str="$55,length_string(str)+2,str";
    
    sum=0;
    for (k=1;k<=length_string(str);k++){
	sum=sum+str[k];
	//send_string 0,"'str[',itoa(k),']: ',itohex(str[k])"
    }
    sum=256-sum;
    
    
    str="str,sum";
    
    //send_string 0,"'suma: ',itoa (sum)"
   // send_string 0,"'dlugosc: ',itohex (len)"
    

    SEND_STRING dvSC,"str"; 
    
    wait 20 'waitForSCans'{ //czyszczenie kolejki jesli  SC nie odpowiedzial na polecenie
	errorSCnotRespond++;
	send_string 0,"'WARING: brak odpowiedzi z SC nr: ',itoa(errorSCnotRespond)";
	
	lenOfKol=length_array(kolSC)
	if (lenOfKol>1){
	    for (forLenOfKol=2;forLenOfKol<=lenOfKol;forLenOfKol++){
		kolSC[forLenOfKol-1]=kolSC[forLenOfKol];
	    }
	    lenOfKol--;
	    set_length_array(kolSC,lenOfKol);
	}
	else{
	    clear_buffer kolSC[1];
	    set_length_array (kolSC,0);		
	}
	semSendSC=0;
	
    }
    /*
    test='';
    for (k=1;k<=length_string(str);k++){
	test="test,'_',itohex(str[k])";
    }
    send_string 0,"test";
    */
}

[dvTPmr,7(*mute*)]=Zones[ZoneAkt].mute;
if (ZoneAkt=1){
	if (var_level<>marVolume){
	var_level=marVolume;
	send_level dvTPmr,5,marVolume;
	//send_string 0,"'volume: ', itoa(Zones[ZoneAkt].volume)"
	}
    
}
else{
    if (var_level<>Zones[ZoneAkt].volume){
	var_level=Zones[ZoneAkt].volume;
	send_level dvTPmr,5,Zones[ZoneAkt].volume;
	//send_string 0,"'volume: ', itoa(Zones[ZoneAkt].volume)"
    }
}
[dvTPmr,8]=Zones[ZoneAkt].mute;

(*	zawatre w mrWizRefresh
for (for_k=1;for_k<=maxZones;for_k++){
    if (for_k=ZoneAkt){
	ON [dvTPmr,10+for_k];
    } else{
	OFF[dvTPmr,10+for_k];
    }
}
*)
for (for_k=1;for_k<=maxZones;for_k++){
    [dvTPmr,30+for_k]=Zones[for_k].state;
}



(********************)
(*BUFFER z Marantz-a*)
(********************)
lenMar=length_string(bufMar);

if (lenMar>=(max_length_array(bufMar)-10)){
    errorBufMar++;
    send_string 0,"'WARNING: Przepelniono Buffer MArantza nr: ',itoa(errorBufMar), 'len" ',itoa(errorBufMar)";
    clear_buffer bufMar;
}

if (lenMar){
    stack_var integer f;
    stack_var char word[20];
    stack_var char type[6];
    stack_var integer lKol;
    stack_var integer k;
    stack_var integer vl;
    
    
    
    
    word=remove_string(bufMar,"$0D",1);	//byte snchronizacji;
    
    f=find_string(word,"'@'",1);
    
    cancel_wait 'waitForMARans';
    
    
    if (f){
	word=mid_string(word,f+1,length_string(word)-f-1);
	
	    
	if (word<>'$15'){
	
	    lKol=length_array(kolMar)
	    if (lKol>1){
		for (k=2;k<=lKol;k++){
		    kolMar[k-1]=kolMar[k];
		}
		lKol--;
		set_length_array(kolMar,lKol);
	    }
	    else{
		clear_buffer kolMar[1];
		set_length_array (kolMar,0);		
	    }
	} else{
	    marErr++;
	    if (marErr>3){
		marErr=0;
		send_string 0,"'WARNING: Proba wyslania zlego polenenia do Marantza: ',kolMar[1],'xx'";
		if (lKol>1){
		    for (k=2;k<=lKol;k++){
			kolMar[k-1]=kolMar[k];
		    }
		    lKol--;
		    set_length_array(kolMar,lKol);
		}
		else{
		    clear_buffer kolMar[1];
		    set_length_array (kolMar,0);		
		}
	    }
	}
	semMar=0;
	
	f=find_string(word,"':'",1);
	type=left_string(word,f-1);
	select{
	    active(word='PWR:1'):{
		marPower=0;
		call 'mrPowerOFF'(1);
		send_string 0,"'[mrPowerOFF] MR_PRG: 245'";
	    }	
	    active(word='PWR:2'):{
		marPower=1;
		call 'marSend' ("'@AST:',$0F");
		
		//marSource=word[6];  // UWAGA - sprawdziæ
		
		send_string 0,"'WORD: ',word";
		
		// !!! Sprawdziæ, czy akcja z DreamBox-em dzieje siê tylko, przy w³¹czaniu go przy wy³¹czonej strefie
		// czy tak¿e przy w³¹czeniu go w salonie, kiedy coœ tam ju¿ gra
		
		if (Zones[1].src > 0){
		    /*
		    if (marSource<>marSourcesTypes[Zones[1].src])
		    {
			
			for (k=1;k<=max_length_array(marSourcesTypes);k++)
			{
			    if (marSource = marSourcesTypes[k])
			    {
				send_string 0, "'!!! [PRG] Line 264'";
				call 'mrSourceSelect' (1,k);
				break;
			    }
			}
		    }
		    */
		}
		else
		{
		    /*
		    for (k=1;k<=max_length_array(marSourcesTypes);k++)
		    {
			if (marSource=marSourcesTypes[k])
			{
			    send_string 0, "'!!! [PRG] Line 278'";
			    call 'mrSourceSelect' (1,k);
			    break;
			}
		    }
		    */
		}
		
	    }
	    active(word='AMT:1'):{
		marMute=0;
	    }	
	    active(word='AMT:2'):{
		marMute=1;
	    }
	    active(type='VOL'):{
		vl=atoi(right_string(word,2));
		
		//send_string 0,"'volume txt: ',right_string(word,2)";
		
		if (word[5]='+'){
		    vl=vl+71;
		}
		else {
		    vl=71-vl;
		}
		//send_string 0,"'znak: ',word[5]";
		//send_string 0,"'volume Marantz: ',itoa(vl)";
		marVolume=vl*255/89;
		//send_string 0,"'volume Marantz: ',itoa(marVolume)";
	    }
	    active(type='SRC'):{
		marSource=word[6];
		
		if (Zones[1].src > 0)
		{
		    /*
		    if (marSource<>marSourcesTypes[Zones[1].src])
		    {
			for (k=1;k<=max_length_array(marSourcesTypes);k++)
			{
			    if (marSource=marSourcesTypes[k])
			    {
				send_string 0, "'!!! [PRG] Line 309 | k = ', k";
				call 'mrSourceSelect' (1,k);
				break;
			    }
			}
		    }
		    */
		}
		else
		{
		    for (k=1;k<=max_length_array(marSourcesTypes);k++)
		    {
			if (marSource=marSourcesTypes[k])
			{
			    send_string 0, "'!!! [PRG] Line 316'";
			    call 'mrSourceSelect' (1,k);
			    break;
			}
		    }
		}
		
	    }	
	    
	    
	}
    }
} 

if (length_array(kolMar)&&(semMar=0)){
    semMar=1
    SEND_STRING dvMarantz,"'@',kolMar[1],$0D";
    //SEND_STRING 0,"'Do Mar: @',kolMar[1],$0D";
    
    wait 8 'waitForMARans'{ //czyszczenie kolejki jesli  Mar nie odpowiedzial na polecenie
	errorMARnotRespond++;
	send_string 0,"'WARING: brak odpowiedzi z MAR nr: ',itoa(errorMARnotRespond),' dane: ',kolMar[1] ";
	
	lenOfKol=length_array(kolMar)
	if (lenOfKol>1){
	    for (forLenOfKol=2;forLenOfKol<=lenOfKol;forLenOfKol++){
		kolMar[forLenOfKol-1]=kolMar[forLenOfKol];
	    }
	    lenOfKol--;
	    set_length_array(kolMar,lenOfKol);
	}
	else{
	    clear_buffer kolMar[1];
	    set_length_array (kolMar,0);		
	}
	semMar=0;
    }
}
