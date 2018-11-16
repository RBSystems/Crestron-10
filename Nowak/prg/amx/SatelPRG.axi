PROGRAM_NAME='SatelPRG'

if (length_string(bSatel)>(max_length_string(bSatel)-30)){
    ErrorSatelBufferOwerflow++;
    send_string 0,"'WARNING: przepelnienie buffera Satel nr: ',itoa(ErrorSatelBufferOwerflow)";
    
    clear_buffer bSatel;
    
}

if (length_string(bSatel)){
    stack_var integer f;
    stack_var char word[70];
    stack_var integer wordLen;
    stack_var char car;
    
    stack_var integer wordOK;
    stack_var integer k,m,n; 
    
    stack_var char CRC;
    
    f=find_string(bSatel,"$FE",1);
    
    
    if ((f>0)){
    
	while (bSatel[f+1]=$FE){ //usuwanie powtarzajaccyh sie przerw miedzy sygnalami
	    f++;
	}
	
	while (find_string(bSatel,"$FE",f+1) && waitCount1<200){ //sprawdzanie czy w bufferze znajduje sie jeszcze kolejny wyraz
	    
	    
	    for (k=1;k<=max_length_array(SatSupportedLenght);k++){ //szukanie typu danych
		if (bSatel[f+1]=SatSupportedLenght[k][1]){
		    for (m=2;m<=length_array(SatSupportedLenght[k]);m++){ //sprawdzanie dobrych dlugosci
			wordLen=1+SatSupportedLenght[k][m]
			car=bSatel[f+wordLen+2];
			
			//send_string 0,"'szukana dlugosc: ',itoa(SatSupportedLenght[k][m]),' czyli: ',itoa(m)";
			if (car=$FF || car=$FE){ //sprawdz za koncem faktycznie jest koniec
			
			    send_string 0,"'ZNALEZIONA dlugosc: ',itoa(SatSupportedLenght[k][m]),' czyli: ',itoa(m)";
			    
			    word=mid_string(bSatel,f+1,wordLen);
			    
			     
			    CRC=0;
			    for (k=0;k<=length_string(word);k++){
				CRC=CRC + bSatel[f+k];
			    }
			    
				
			    
			    if (CRC = bSatel[f+wordLen+1]){
			    
				
				call 'satRecive' (word);
				
				
				bSatel=right_string(bSatel,length_string(bSatel)-f-wordLen);
				
				f=0;
				
				break;
			    } else {
				send_string 0,"'CRC potrzebne'";
			    }
			}
		    }
		    
		    break;
		}
	    }
	    
	    f=find_string(bSatel,"$FE",f+1);
	    
	    if (f){
		bSatel=right_string(bSatel,length_string(bSatel)-f+1)
	    }
	    f=1;
	    
	    while (bSatel[f+1]=$FE){ //usuwanie powtarzajaccyh sie przerw miedzy sygnalami
		f++;
	    }
	    waitCount1++;
	}
	waitCount1=0;
    } 
    
}


//WIZUALIZACJA wejsc alarmu
for (kk=1;kk<=length_array(satWiz);kk++){
    if (satWiz[kk][1]< satMaxInputs ){
	[dvTPalarm,satWiz[kk][2]]=satInput[satWiz[kk][1]].stat;
    }
}

[dvTPalarm,39] = satStrefy[1].armed;