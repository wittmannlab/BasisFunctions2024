function s = findMatchedTrials_ms(s)
% identifies trial types that are identical across group and no-group schedules
% MKW, 2023



%%%---------------------------------------------------------------------------------------------------------------------------------
% 1. find out conditions:
for is = 1:numel(s.beh)
   groupVer(is) = s.beh{is}.ver.group;
   selfVer(is)  = s.beh{is}.ver.self;
end

indSelfGroup  = find(selfVer==1&groupVer==1);
indPartGroup  = find(selfVer==0&groupVer==1);
indSelfNo     = find(selfVer==1&groupVer==0);
indPartNo     = find(selfVer==0&groupVer==0);


%%%---------------------------------------------------------------------------------------------------------------------------------
% 2. take the self version of the schedule, then check first grhe group and then apply the result to the no-group condition
%%%%%%%%%%%%%% for group
for i = 1:numel(indSelfGroup)
    idx = indSelfGroup(i);
    
    tt3 = gfM(s.beh{idx}.dec,'TT3');
    
    ttmatched = tt3; 
    ttmatched(tt3==3)=NaN;

    s.beh{idx}.dec.mat(:,end+1) = ttmatched;
    s.beh{idx}.dec.names{end+1} = 'ttsame';  
end

% for no-group
for i = 1:numel(indSelfNo)
    idx = indSelfNo(i);
    
    s.beh{idx}.dec.mat(:,end+1) = ttmatched;
    s.beh{idx}.dec.names{end+1} = 'ttsame';  
end
%%%---------------------------------------------------------------------------------------------------------------------------------
% 3. now the same for partner
%%%%%%%%%%%%%% for group
for i = 1:numel(indPartGroup)
    idx = indPartGroup(i);
    
    tt3 = gfM(s.beh{idx}.dec,'TT3');
    
    ttmatched = tt3; 
    ttmatched(tt3==3)=NaN;

    s.beh{idx}.dec.mat(:,end+1) = ttmatched;
    s.beh{idx}.dec.names{end+1} = 'ttsame';  
end

% apply same to other schedule
for i = 1:numel(indPartNo)
    idx = indPartNo(i);
    
    s.beh{idx}.dec.mat(:,end+1) = ttmatched;
    s.beh{idx}.dec.names{end+1} = 'ttsame';  
end








end

