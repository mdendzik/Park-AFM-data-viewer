close all; clear all; clc;

% This code opens both lateral and error signal from the same measurements
% Put the filename here:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filenamelat='';
path='';
% Remember to put \ at the end!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% goodindex=dlmread([path 'goodindex' filenamelat(20:22) '.txt'],'\n');


path1=[path filenamelat];
% path2=strrep(path1, 'Error Signal', 'Lateral Force');
path2=strrep(path1, 'Lateral Force', 'Error Signal');
% changing 'Lateral Force' into 'Error Signal'


%imfinfo reads information about the image
info1 = imfinfo(path1);
info2 = imfinfo(path2);

%image parameters are stored in PSIAHeader (Tag: 50435)
parameters1=info1.UnknownTags(4,1).Value;
parameters2=info2.UnknownTags(4,1).Value;

% Number of columns
nWidth=typecast(uint8(parameters1(101:104)),'int32');

% Number of rows
nHeight=typecast(uint8(parameters1(105:108)),'int32');

% X scan size in um  
dfXScanSizeum=typecast(uint8(parameters1(141:148)),'double');

% Y scan size in um
dfYScanSizeum=typecast(uint8(parameters1(149:156)),'double');

% Unit of Data gain per step lateral
szUnitW=native2unicode(uint8(parameters1(245:260)),'ISO-8859-1');
UnitW1='';
for i=1:2:15
    if szUnitW(i)~= szUnitW(16)
        UnitW1=[UnitW1 sprintf('%c',szUnitW(i))];
    end;
end;

% Unit of Data gain per step error signal
szUnitW=native2unicode(uint8(parameters2(245:260)),'ISO-8859-1');
UnitW2='';
for i=1:2:15
    if szUnitW(i)~= szUnitW(16)
        UnitW2=[UnitW2 sprintf('%c',szUnitW(i))];
    end;
end;

% Data gain < 0 UnitW/step lateral
dfDataGain1=typecast(uint8(parameters1(221:228)),'double');

% Data gain < 0 UnitW/step error signal
dfDataGain2=typecast(uint8(parameters2(221:228)),'double');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changing the image into matrix nWidth x nHeight.

% data is stored in PSIAData (Tag: 50434)
img1=uint8(info1.UnknownTags(3,1).Value);
img2=uint8(info2.UnknownTags(3,1).Value);

% Image data is stored as byte (uint8). Each point is stored as 2 bytes so
% each couple of bytes should be typecasted into int16. After that we get
% the file row by row. The code below converts the file into easier to
% handle matrix nWidth x nHeight.


% Such algorhitm seems to be significantly faster than calculating
% calculating each element at a time (z(i,j)).
% lateral
z1=[];
ztemp=[];
for j=1:1:nWidth
    for i=(j-1)*2*nHeight+1:2:j*2*nHeight
        ztemp=[ztemp typecast(img1(i:i+1),'int16')];
    end
    z1=[z1;ztemp];
    ztemp=[];
end
% error signal
z2=[];
ztemp=[];
for j=1:1:nWidth
    for i=(j-1)*2*nHeight+1:2:j*2*nHeight
        ztemp=[ztemp typecast(img2(i:i+1),'int16')];
    end
    z2=[z2;ztemp];
    ztemp=[];
end


%all data need to by multiplied by dfDataGain
z1=dfDataGain1*double(z1);
z2=dfDataGain2*double(z2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculations of scan size
x=linspace(0, dfXScanSizeum, nHeight);
y=linspace(0, dfYScanSizeum, nWidth)';

screen_size = get(0, 'ScreenSize');

f1=figure(1);
set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );


% making the directory where the profiles will be saved. Name of the
% directory is just the name of the file without .tiff

[s,mess,messid]=mkdir(strrep(path1,'.tiff',''));
[s,mess,messid]=mkdir(strrep(path2,'.tiff',''));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UnitX=native2unicode(uint8([181 109]),'ISO-8859-1');

i=1;
goodindex=[];
while (i<=nHeight+1)
    subplot(2,1,1);
    plot(x,z1(i,:))
    title([filenamelat '  line: ' num2str(i) ' / ' num2str(nHeight)]);
    xlabel(['x(' UnitX ')']);
    ylabel(['z(' UnitW1 ')']);
    subplot(2,1,2);
    plot(x,z2(i,:))
    title([strrep(filenamelat, 'Lateral Force', 'Error Signal') '  line: ' num2str(i) ' / ' num2str(nHeight)]);
    xlabel(['x(' UnitX ')']);
    ylabel(['z(' UnitW2 ')']);
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
            dlmwrite([path 'goodindex' filenamelat(20:22) '.txt'],goodindex,'\n');
            close all;
            return
%             up arrow exports the profile
        case 30
            goodindex=[goodindex;i];
            
            filename=[strrep(path1,'.tiff','') '\Line' num2str(i) '.txt'];
            header1={'x' 'z'};
            header2={UnitX UnitW1};
            headerTxt1=sprintf('%s\t',header1{:});
            headerTxt2=sprintf('%s\t',header2{:});
            headerTxt1(end)='';
            headerTxt2(end)='';
            dlmwrite(filename,headerTxt1,'');
            dlmwrite(filename,headerTxt2,'-append','delimiter','');
%             headers with units and names of the values
            dlmwrite(filename,[x' z1(i,:)'] ,'-append','delimiter','\t');
            filename=[strrep(path2,'.tiff','') '\Line' num2str(i) '.txt'];
            header1={'x' 'z'};
            header2={UnitX UnitW2};
            headerTxt1=sprintf('%s\t',header1{:});
            headerTxt2=sprintf('%s\t',header2{:});
            headerTxt1(end)='';
            headerTxt2(end)='';
            dlmwrite(filename,headerTxt1,'');
            dlmwrite(filename,headerTxt2,'-append','delimiter','');
%             headers with units and names of the values
            dlmwrite(filename,[x' z2(i,:)'] ,'-append','delimiter','\t');
            
    end
    else
    pause
    end
end



