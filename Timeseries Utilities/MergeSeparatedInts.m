function [ newints,mergedidx ] = MergeSeparatedInts( ints,minseparation )
%[ ints ] = MergeSeparatedInts( ints,minseparation ) merges close or
%overlapping intervals with a minimum separation.
%
%INPUT
%   ints            (n_ints x 2) matrix of interval start and end times
%   minseparation   merge ints separated by less than or equal to min
%
%OUTPUT
%   ints            (n_newints x 2) start and end times of merged intervals
%                   -sorted
%   mergedidx       {n_newints} indices of which old intervals were merged
%                   into each new interval
%% Test
% ints = [0 3;2 4; 6 10; 10.5 13;  20 30; 19 21];
% minseparation = 0.5;


%%
%Sort Ints by their end times so all intervals end before the
%next interval ends
[~,sort_ints] = sort(ints(:,2));
newints = ints(sort_ints,:);
mergedidx = num2cell(sort_ints);

%Find ints that start before a minimum separation after the end of the 
%previous interval
intseparation = newints(2:end,1)-newints(1:end-1,2);
smallsep = find(intseparation<=minseparation);

for s = flipud(smallsep)'   %Go backwards from last ints to first ones
    newints(s,2) = newints(s+1,2);  %Take the later end time between the ints
    newints(s,1) = min(newints(s+1,1),newints(s,1)); %Take the earlier start time between the ints
    newints(s+1,:) = [];       %Remove the merged interval
    mergedidx{s} = [mergedidx{s} mergedidx{s+1}];
    mergedidx(s+1) = [];
end

end

