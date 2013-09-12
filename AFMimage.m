%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Matlab program for line by line export of Park Systems .tiff files to .txt. 
%Maciek Dendzik, EPFL, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use left and right arrow to go through profiles. Up arrow exports
% current profile i into the .txt file called Linei in the directory
% named after the file. After clicking mouse button program is paused and
% zooming and moving on the plot is available. To resume just press any
% key. To quit press q.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clc;

%put the path here:
path='';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%imfinfo reads information about the image
info = imfinfo(path);
%image parameters are stored in PSIAHeader (Tag: 50435)
parameters=info.UnknownTags(4,1).Value;
% z=image(1:2);
% z1=typecast(z,'int16');
% z2=typecast(image(3:4),'int16');

%reading parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% by defualt matlab reads the tags from .tiff as byte (uint8). To get
% proper values of parameters they should be casted into those types given
% in specification

% 0=2d mapped image, 1= line profile image, 2=Spectroscopy image
nImageType=typecast(uint8(parameters(1:4)),'int32');


% the strings are coded in ASCII with 2 bytes reserved for 1 char.
% Second byte is always 0 because normal ASCII uses only 127 bits.
% The loop just gets rid of blank spaces.

% Source name (topography, ZDetector, itp)
szSourceNameW=native2unicode(uint8(parameters(5:68)),'ISO-8859-1');
SourceNameW='';
for i=1:2:63
    if szSourceNameW(i)~= szSourceNameW(64)
        SourceNameW=[SourceNameW sprintf('%c',szSourceNameW(i))];
    end;
end;

% Image mode (AFM...)
szImageModeW=native2unicode(uint8(parameters(69:84)),'ISO-8859-1');
ImageModeW='';
for i=1:2:15
    if szImageModeW(i)~= szImageModeW(16)
        ImageModeW=[ImageModeW sprintf('%c',szImageModeW(i))];
    end;
end;

% Low pass filter strength
dfLPFStrength=typecast(uint8(parameters(85:92)),'double');

% Automatic flatten after imaging
bAutoFlatten=typecast(uint8(parameters(93:96)),'int32');

% AC track
bACTrack=typecast(uint8(parameters(97:100)),'int32');

% Number of columns
nWidth=typecast(uint8(parameters(101:104)),'int32');

% Number of rows
nHeight=typecast(uint8(parameters(105:108)),'int32');

% Angle of fast direction about positive x-axis
dfAngle=typecast(uint8(parameters(109:116)),'double');

% Sine Scan
bSineScan=typecast(uint8(parameters(117:120)),'int32');

% OverScan rate
dfOverScan=typecast(uint8(parameters(121:128)),'double');

% Fast scan direction(non-zero for forward, 0 for backward)
bFastScanDir=typecast(uint8(parameters(129:132)),'int32');

% Slow scan direction(non-zero for up, 0 for down)
nSlowScanDir=typecast(uint8(parameters(133:136)),'int32');

% Swap fast-slow scanning direction
bXYSwap=typecast(uint8(parameters(137:140)),'int32');

% X scan size in um  
dfXScanSizeum=typecast(uint8(parameters(141:148)),'double');

% Y scan size in um
dfYScanSizeum=typecast(uint8(parameters(149:156)),'double');

% X offset in um
dfXOffsetum=typecast(uint8(parameters(157:164)),'double');

% Y offset in um
dfYOffsetum=typecast(uint8(parameters(165:172)),'double');

% Scan speed in rows per second 
dfScanRateHz=typecast(uint8(parameters(173:180)),'double');

% Error signal set point
dfSetPoint=typecast(uint8(parameters(181:188)),'double');

% Set point unit
szSetPointUnitW=native2unicode(uint8(parameters(189:204)),'ISO-8859-1');
SetPointUnitW='';
for i=1:2:15
    if szSetPointUnitW(i)~= szSetPointUnitW(16)
        SetPointUnitW=[SetPointUnitW sprintf('%c',szSetPointUnitW(i))];
    end;
end;

% Tip Bias voltage in V
dfTipBiasV=typecast(uint8(parameters(205:212)),'double');

% Sample bias voltage in V
dfSampleBiasV=typecast(uint8(parameters(213:220)),'double');

% Data=DataGain*(dfScale*nData+dfOffset)

% Data gain < 0 UnitW/step
dfDataGain=typecast(uint8(parameters(221:228)),'double');

% Z scale now it is always 1
dfZScale=typecast(uint8(parameters(229:236)),'double');

% Z offset i steps, now always 0 
dfZOffset=typecast(uint8(parameters(237:244)),'double');

% Unit of Data gain per step
szUnitW=native2unicode(uint8(parameters(245:260)),'ISO-8859-1');
UnitW='';
for i=1:2:15
    if szUnitW(i)~= szUnitW(16)
        UnitW=[UnitW sprintf('%c',szUnitW(i))];
    end;
end;

% DataMax < DataMin because DataGain < 0 
nDataMin=typecast(uint8(parameters(261:264)),'int32');

% DataMax < DataMin because DataGain < 0 
nDataMax=typecast(uint8(parameters(265:268)),'int32');

% Average Data
nDataAvg=typecast(uint8(parameters(269:272)),'int32');

% Compession option, not used yet
nCompression=typecast(uint8(parameters(273:276)),'int32');

% Is the data in log scale 
bLogScale=typecast(uint8(parameters(277:280)),'int32');

% Is the data squared 
bSquare=typecast(uint8(parameters(281:284)),'int32');

% Z-Servo gain 
dfZServoGain=typecast(uint8(parameters(285:292)),'double');

% Z scanner Range
dfZScannerRange=typecast(uint8(parameters(293:300)),'double');

% XY Voltage mode
szXYVoltageMode=native2unicode(uint8(parameters(301:316)),'ISO-8859-1');
XYVoltageMode='';
for i=1:2:15
    if szXYVoltageMode(i)~= szXYVoltageMode(16)
        XYVoltageMode=[XYVoltageMode sprintf('%c',szXYVoltageMode(i))];
    end;
end;

% Z voltage Mode
szZVoltageMode=native2unicode(uint8(parameters(317:332)),'ISO-8859-1');
ZVoltageMode='';
for i=1:2:15
    if szZVoltageMode(i)~= szZVoltageMode(16)
        ZVoltageMode=[ZVoltageMode sprintf('%c',szZVoltageMode(i))];
    end;
end;

% XY servo mode
szXYServoMode=native2unicode(uint8(parameters(333:348)),'ISO-8859-1');
XYServoMode='';
for i=1:2:15
    if szXYServoMode(i)~= szXYServoMode(16)
        XYServoMode=[XYServoMode sprintf('%c',szXYServoMode(i))];
    end;
end;

% Data Type 0=16bitshort, 1= 32bit int, 2= 32bit float
nDataType=typecast(uint8(parameters(349:352)),'int32');

% # of X PDD region
bXPDDRegion=typecast(uint8(parameters(353:356)),'int32');

% # of Y PDD region
bYPDDRegion=typecast(uint8(parameters(357:360)),'int32');

% Non Contact Mode Amplitude
dfNCMAmplitude=typecast(uint8(parameters(361:368)),'double');

% Non Contact Mode Frequency
dfNCMFrequency=typecast(uint8(parameters(369:376)),'double');

% Head Rotation Angle
dfHeadRotationAngle=typecast(uint8(parameters(377:384)),'double');

% Cantilever name
szCantilever=native2unicode(uint8(parameters(385:400)),'ISO-8859-1');
Cantilever='';
for i=1:2:15
    if szCantilever(i)~= szCantilever(16)
        Cantilever=[Cantilever sprintf('%c',szCantilever(i))];
    end;
end;

% Non Contact Mode Drive %, range= 0-100
dfNCMDrivePercent=typecast(uint8(parameters(401:408)),'double');

% intensity factor (dimensionless) = (A+B)/3
dfIntensityFactor=typecast(uint8(parameters(409:416)),'double');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Changing the image into matrix nWidth x nHeight.

% data is stored in PSIAData (Tag: 50434)
img=uint8(info.UnknownTags(3,1).Value);


% Image data is stored as byte (uint8). Each point is stored as 2 bytes so
% each couple of bytes should be typecasted into int16. After that we get
% the file row by row. The code below converts the file into easier to
% handle matrix nWidth x nHeight.


% Such algorhitm seems to be significantly faster than calculating
% calculating each element at a time (z(i,j)).
z=[];
z1=[];
for j=1:1:nWidth
    for i=(j-1)*2*nHeight+1:2:j*2*nHeight
        z1=[z1 typecast(img(i:i+1),'int16')];
    end
    z=[z;z1];
    z1=[];
end


%all data needs to by multiplied by dfDataGain
z=dfDataGain*double(z);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculations of scan size
x=linspace(0, dfXScanSizeum, nHeight);
y=linspace(0, dfYScanSizeum, nWidth)';

% showing the image
[img_small,cmap]=imread(path);
screen_size = get(0, 'ScreenSize');

f1=figure(1);
set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
subplot(1,2,1);
imshow(img_small,cmap),title(path);
subplot(1,2,2);
% figure;
%  colormap(cmap), 
% making the directory where the profiles will be saved. Name of the
% directory is just the name of the file without .tiff

[s,mess,messid]=mkdir(strrep(path,'.tiff',''));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This piece of code is responsible for plotting the profiles.
% Use left and right arrow to go through profiles. Up arrow exports
% current profile i into the .txt file called Linei in the directory
% named after the file. After clicking mouse button program is paused and
% zooming and moving on the plot is available. To resume just press any
% key. To quit press q.

% This will produce nice um for x unit
UnitX=native2unicode(uint8([181 109]),'ISO-8859-1');

i=1;
while (i<=nHeight+1)
    plot(x,z(i,:))
    title(['X line: ' num2str(i) ' / ' num2str(nHeight)]);
    xlabel(['x(' UnitX ')']);
    ylabel(['z(' UnitW ')']);
    w = waitforbuttonpress;
    if w ==1
    p = get(gcf, 'CurrentCharacter');
    switch (double(p))
%         left arrow
        case 28 
        if i>1
           i=i-1;
        end
%         right arrow
        case 29
            if i<nHeight
                i=i+1;
            end
%             q exits the program
        case 113
            close all;
            return
%             up arrow exports the profile
        case 30
            filename=[strrep(path,'.tiff','') '\Line' num2str(i) '.txt'];
            header1={'x' 'z'};
            header2={UnitX UnitW};
            headerTxt1=sprintf('%s\t',header1{:});
            headerTxt2=sprintf('%s\t',header2{:});
            headerTxt1(end)='';
            headerTxt2(end)='';
            dlmwrite(filename,headerTxt1,'');
            dlmwrite(filename,headerTxt2,'-append','delimiter','');
%             headers with units and names of the values
            dlmwrite(filename,[x' z(i,:)'] ,'-append','delimiter','\t');
            
    end
    else
    pause
    end
end

% to read exported profiles use:
% a=dlmread('Line1.txt', '', 2, 0)
% plot(a(:,1),a(:,2))
