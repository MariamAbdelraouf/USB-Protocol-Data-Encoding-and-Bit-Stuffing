inputData = fileread(".......");
inputData = strrep(inputData, '\n', '');
binaryStream = '';
for i = 1:length(inputData)
    binaryStream = strcat(binaryStream, dec2bin(inputData(i), 8));
end
usbStream = '00000001';
prevBit = '0';
for i = 1:length(binaryStream)
    if binaryStream(i) == '0'
        if prevBit == '0'
            usbStream = strcat(usbStream, '1');
            prevBit = '1';
        else
            usbStream = strcat(usbStream, '0');
            prevBit = '0';
        end
    else
        usbStream = strcat(usbStream, prevBit);
    end
end
usbStreamStuffed = '';
onesCount = 0;
for i = 1:length(usbStream)
    if usbStream(i) == '1'
        onesCount = onesCount + 1;
        if onesCount == 5
            usbStreamStuffed = strcat(usbStreamStuffed, '111110');
            onesCount = 0;
        end
    else
        onesCount = 0;
    end
    usbStreamStuffed = strcat(usbStreamStuffed, usbStream(i));
end
usbStreamWithZeros = '';
for i = 1:length(usbStreamStuffed)
    usbStreamWithZeros = strcat(usbStreamWithZeros, usbStreamStuffed(i));
    if mod(i, 32) == 0
        usbStreamWithZeros = strcat(usbStreamWithZeros, '000');
    end
end
bitsToAdd = mod(length(usbStreamWithZeros), 32);
if bitsToAdd > 0
    usbStreamWithZeros = strcat(usbStreamWithZeros, '0'*(32 - bitsToAdd));
end

fid = fopen('usb_protocol_data.txt', 'wt');
fprintf(fid, usbStreamWithZeros);
fclose(fid);
