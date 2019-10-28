clear; close all; clc;
instrreset
oldobjs = instrfind;
if (~isempty(oldobjs))
   fclose(oldobjs);   
delete(oldobjs);
end
clear oldobjs;
fieldFox = visa('agilent', 'TCPIP0::192.168.0.1::inst0::INSTR');
set(fieldFox,'InputBufferSize', 640000);
set(fieldFox,'OutputBufferSize', 640000);
fopen(fieldFox);
fprintf(fieldFox,'*IDN?\n');
myId = fscanf(fieldFox,'%c')
fprintf(fieldFox,'*CLS\n');
fprintf(fieldFox,'SYST:ERR?\n');
initErrCheck = fscanf(fieldFox,'%c')
fprintf(fieldFox,'INST:SEL ''NA''')
fprintf(fieldFox,'INIT:CONT 0\n')
fprintf(fieldFox,'FREQ:STAR 60E6;STOP 300E6\n')
fprintf(fieldFox,'SWE:POIN 101\n')
fprintf(fieldFox,'CALC:PAR1:DEF S21;SEL\n')
fprintf(fieldFox,'*OPC?\n')
done = fscanf(fieldFox,'%1d')
fprintf(fieldFox,'INIT;*OPC?\n')
trigComplete = fscanf(fieldFox,'%1d')
fprintf(fieldFox, 'FORM:DATA REAL,32\n')
fprintf(fieldFox,'CALC:DATA:FDATA?\n')
myBinData = binblockread(fieldFox,'float')
hangLineFeed = fread(fieldFox,1)
fprintf(fieldFox, 'FORM:DATA REAL,64\n')
fprintf(fieldFox,'SENS:FREQ:DATA?\n')
myBinStimulusData = binblockread(fieldFox,'double')
hangLineFeed = fread(fieldFox,1)
display myBinData
display myBinStimulusData
myStimulusDataMHz = myBinStimulusData/1E6
clear title xlabel ylabel
plot(myStimulusDataMHz, myBinData)
title('S21 :  177MHz Band Pass Filter')
xlabel('Frequency (MHz)')
ylabel ('Log Mag (dB)')
fprintf(fieldFox, 'SYST:ERR?')
finalErrCheck = fscanf(fieldFox, '%c')
fclose(fieldFox);