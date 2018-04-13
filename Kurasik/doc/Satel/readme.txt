port dedykowany 7094

======================

Tymczasowi użytkownicy:
1) 2018
2) 20180

======================

Wsparcie techniczne Gdańsk - (58) 320 94 20

==========================

Aplikacje:

Integra Control (Android)
GuardX (PC)
DloadX


=========================

Potrzebuję wysłać po ethm komendę do satela, żeby dostać stan czujek, a potem wygrzebać z tego stan konkretnej jednej czujki. Czy jest to możliwe?

Jasne, że jest to możliwe. W dokumentacji protokołu są opisane wszystkie możliwe komendy. 

Komenda odpytująca o stan wejść to 0x00. Uzupełniając to o bajty startu, końca, sumę kontrolną - finalna postać ramki odpytującej wygląda tak: 
{FE}{FE}{00}{D7}{E2}{FE}{0D} 

Potem zgodnie z dokumentacją otrzymujesz stosowną odpowiedź, np.: 
{FE}{FE}{00}{00}{01}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{74}{C8}{FE}{0D} 

gdzie: 
{00}{01}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00}{00} 
to stan wejść. 
I np. zwróć uwagę, że drugi bajt od lewej ma wartość 1, więc wejście nr9 jest naruszone (każdy bajt reprezentuje 8 wejść). 
Coś na wzór: 

# 8 7 6 5 4 3 2 1 # 16 15 14 13 12 11 10 9 # ... 

Odnośnie sterowania alarmem sprawa analogiczna. Wysyłasz ramkę załączającą czuwanie. Potem odpytujesz, czy czuwanie załączone. Zawsze trzeba zadawać pytanie w kierunku centrali. Centrala dobrowolnie nic sama nie wyśle (mówimy o trybie 2 protokołu, czyli integracja).

==========================

Tutaj najmłodszy bajt jest z lewej strony. W dokumentacji protokołu jest to zobrazowane na przykładzie załączenia strefy właśnie. Ogólnie, wygląda to tak: 


0000 0000 | 0000 0000 | 0000 0000 | 0000 0000 
czyli 4 bajty, gdzie każdy bajt to 8 bitów, czyli 8 stref (w dokumentacji jest to tłumaczone jako partycja, ale chodzi o strefę). 

Przykład, strefa 1 i 3: 
0000 0101 | 0000 0000 | 0000 0000 | 0000 0000 , czyli w HEX: 05 00 00 00 

Przykład, strefa 9 i 16: 
0000 0000 | 1000 0001 | 0000 0000 | 0000 0000 , czyli w HEX: 00 81 00 00 

Przykład, strefa 10 i 25, 26, 27: 
0000 0000 | 0000 0010 | 0000 0000 | 0000 0111 , czyli w HEX: 00 02 00 07

==========================

Komenda generująca FE w sumie CRC

komenda	=	E0 30 49 FF FF (odczytywanie danych o użytkowniku z kodem 3049)
crc		=	89 FE
ramka	=	FE FE E0 30 49 FF FF 89 FE F0 FE 0D