function [normdata,intmean,intstd] = NormToInt(data,int,sf,normtype)
%ZScoreToInt(data,int,sf) z-scores the data to the mean and standard
%deviation of the data in intervals int
%
%INPUTS
%   data    [Nt x Ndim]  
%   int     [Nints x 2] reference interval onsets and offset times within  
%           which to Z score the data to
%   sf      (optional) sampling frequency of the data. default 1
%   normtype 'mean' or 'Z'
%
%DLevenstein Summer 2016
%%
if isa(int,'intervalSet')
    int = [Start(int,'s'), End(int,'s')];
end


numints = length(int(:,1));
if ~exist('sf','var')
    sf = 1;
end


int = round(int*sf);

int_data = [];
for ii = 1:numints
    int_data = [int_data; data(int(ii,1):int(ii,2),:)];
end

intmean = nanmean(int_data);
intstd = nanstd(int_data);

switch normtype
    case 'Z'
        normdata = (data-repmat(intmean,length(data(:,1)),1))./repmat(intstd,length(data(:,1)),1);
    case 'mean'
        normdata = data./intmean;
    otherwise
        display('normtype should be ''Z'' or ''mean''')
end


end

