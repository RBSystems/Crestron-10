PROGRAM_NAME='SatelPRG2'

if (length_string(bSatel)>(max_length_string(bSatel)-30)){
    ErrorSatelBufferOwerflow++;
    send_string 0,"'WARNING: przepelnienie buffera Satel nr: ',itoa(ErrorSatelBufferOwerflow)";
    
    clear_buffer bSatel;
    
}

if (satelSendSemafor=0){
    satelSendSemafor=1;
    cancel_wait 'wait_ForAnwser';
    wait 10 'wait_ForAnwser'{
	satelSendSemafor=0;
	send_string 0,"'WARNING: timeElpased'";
    }
    
    if ( length_string (satelToSend) > 0 ){ //logika zwiazana z satelToSend bo wysylanie moze sie pokryc (wyscig)
	send_string dvSatel,"satelToSend";
	satelToSend="";
    }
    
    else{
	if (satKolViol>3){
	    satKolViol=0;
	    
	    call 'SatSend' ("$00");
	} 
	else{
	    satKolViol++;
	    
	    if (satKolWaz<6){
		satKolWaz++;
		call 'SatSend' ("satelKolejkaWazne[satKolWaz]");
	    }else{
		satKolWaz=0;
		//send_string 0,"'calka kolejka Wazne'";
		
		satKolMalo++;
		if (satKolMalo>15){
		    satKolMalo=1;
		}
		
		call 'SatSend' ("satelKolejkaMalo[satKolMalo]");
		
	    }
	}
	
	send_string dvSatel,"satelToSend";
	satelToSend="";
	
    }
    
}



if (length_string(bSatel)){
    stack_var integer start;
    stack_var integer end;
    stack_var char word[20];
    
    
    stack_var char tStr[500];
    stack_var integer k;
    
    if (satelRecSemafor=0){
	satelRecSemafor=1
	
	end = find_string (bSatel,"$FE,$0D",1);
	
	
	
	if (end){
	    //send_string 0,"'Znalazl koniec na miejscu: ',itoa(end)";
	    
	
	    start = SatelFindStart(end,bSatel);
	    //send_string 0,"'Znalazl poczatek na miejscu: ',itoa(start)";
	    
	    tStr='';
	    for (k=1;k<=end;k++){
		tStr="tStr,' 0x',itohex(bSatel[k])";
	    }
	    //send_string 0,"'Znalezione slowo: ',tStr";
	    
	    //sprawdz CRC!!!!
	    
	    if (start>0){
		start=start+2;
		
		word = mid_string(bSatel,start,end-start)
		
		satelSendSemafor=0;
		call 'satRecive' (word);
	    }else{
		send_string 0,"'WARNING: possible Satel data Error'";
	    }
	    if (length_string(bSatel) = end+1){
		clear_buffer bSatel;
	    }	
	    else{
		bSatel=right_string(bSatel,length_string(bSatel)-end-1);
	    }
	}
	satelRecSemafor=0
    }

}








//WIZUALIZACJA wejsc alarmu
for (kk=1;kk<=length_array(satWiz);kk++){
    if (satWiz[kk][1]< satMaxInputs ){
	[dvTPalarm,satWiz[kk][2]]=satInput[satWiz[kk][1]].stat;
    }
}

[dvTPalarm,39] = satStrefy[1].armed;