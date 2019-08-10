function [F,D,P,T] = extract(csvFile,fuel,dilutionRatio,inletTemp)
%Specialized extraction function
%   csvFile is a string with file name
%   fuel is string array with fuel name
%   dilution ratio is fraction between 0 and 1
%   inletTemp is target inlet temp of IFGR
dataPerFlame=16; %maximum number of temperature measurements 80/5

if (numel(fuel)~=numel(dilutionRatio))||(numel(fuel)~=numel(inletTemp))
    error('Input Data Not Equal Length');
end

dataTable=readtable(csvFile);
dataNames=string(dataTable.Properties.VariableNames);
% Titles of csv file must match
nDr=find(dataNames=='Dilution');
nInletT=find(dataNames=='InletTemp');
nPos=find(dataNames=='Position');
nT=find(dataNames=='MeasuredTempK');

dataArray=table2array([dataTable(:,nDr) dataTable(:,nInletT) dataTable(:,nPos) dataTable(:,nT)]); % dilution, inlet temp, position, temps
fuels=table2cell(dataTable(:,1));
strFuels=string(fuels);
dataLength=numel(dataArray(:,1));

F=strings(numel(dilutionRatio),dataPerFlame);
D=nan(numel(dilutionRatio),dataPerFlame);
P=nan(numel(dilutionRatio),dataPerFlame);
T=nan(numel(dilutionRatio),dataPerFlame);

for k=1:numel(dilutionRatio)
    i=1;
    for n=1:dataLength
        if dataArray(n,2)==inletTemp(k)
            if strFuels(n)==fuel(k)
                if dataArray(n,1)==dilutionRatio(k)
                    F(k,i)=fuel(k);
                    D(k,i)=dilutionRatio(k);
                    P(k,i)=dataArray(n,3);
                    T(k,i)=dataArray(n,4);
                    i=i+1;
                end
            end
        end
    end
end
end

