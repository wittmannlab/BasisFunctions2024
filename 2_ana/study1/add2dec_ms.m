function [ dec] = add2dec_ms(beh,dorun)
%  calculate variables of interest
%
% INPUT:        - dec: "s.beh{is}" field, is data from 1 subject
% PARAMETER:    - dorun: defines what to do
%                   1. Calculate Opponents are Or and Oi for trial types 1-4; define new meta-trialtype (1-3: SvsOr, PvsOr, S+PvsOs)
%                   2. Reaction times in decision 
%%


dec = beh.dec;



%----------------------------------------------------------------------------------------------------------------
%% 1. Calculate Opponents are Or and Oi for trial types 1-4; define new meta-trialtype (1-3: SvsOr, PvsOr, S+PvsOs)
%----------------------------------------------------------------------------------------------------------------
addmat=[];names={};

if dorun(1)==1
   
   ps  = get_from_mat(dec,{'S','P','O1','O2'});
   tt  = get_from_mat(dec,{'decTypeAge'});
   nt  = numel(tt); % trial nr
   
   % variables to calculate:
   OrOi   = nan(nt,2);
   ttnew = nan(nt,1);
      
   % 1 vs 3       --> cond1
   % 1 vs 4       --> cond2
   % 2 vs 3       --> cond3
   % 2 vs 4       --> cond4
   % 1/2 vs 3/4   --> cond5
   
   % self trials recode
   OrOi(tt==1,:) = ps(tt==1,[3 4]);   
   OrOi(tt==2,:) = ps(tt==2,[4 3]);   
   
   % partner trials recode
   OrOi(tt==3,:) = ps(tt==3,[3 4]);   
   OrOi(tt==4,:) = ps(tt==4,[4 3]);     
   
   ttnew(tt==1) = 1;
   ttnew(tt==2) = 1; % 1 is self trials
   ttnew(tt==3) = 2;
   ttnew(tt==4) = 2; % 2 is partner trials
   ttnew(tt==5) = 3; % 3 is group trials
   
   % save:
   addmat = [OrOi ttnew];
   names  = {'Or','Oi','TT3'};
   
   % put in general matrix, replace if necessary:
   for in=1:numel(names)
      if ismember(names{in},dec.names)
         ind               = find(ismember(dec.names,names{in}));
         dec.mat(:,ind)    = addmat(:,in);
      else
         dec.mat(:,end+1)  = addmat(:,in);
         dec.names{end+1}  = names{in};
      end
   end
end




%----------------------------------------------------------------------------------------------------------------
%% 2. Reaction times in decision 
%----------------------------------------------------------------------------------------------------------------
addmat=[];names={};  
if dorun(2)==1

   deconrt= get_from_mat(dec,{'decOn' ,'response_time' });
   addmat = deconrt(:,2) - deconrt(:,1);
   names = {'rt'}; 
   
   % put in general matrix, replace if necessary:
   for in=1:numel(names)
      if ismember(names{in},dec.names)
         ind               = find(ismember(dec.names,names{in}));
         dec.mat(:,ind)    = addmat(:,in);
      else
         dec.mat(:,end+1)  = addmat(:,in);
         dec.names{end+1}  = names{in};
      end
   end
end

%----------------------------------------------------------------------------------------------------------------
%% 3. calculate correct choice
%----------------------------------------------------------------------------------------------------------------

if dorun(3)==1
   
   ps          = get_from_mat(dec,{'vd','outcome'});
   outcome     = ps(:,2);
   vd          = ps(:,1);
   
   optiout     = max(vd,0);
   addmat      = (outcome==optiout); 
   names       = {'corchoice'};  
   
   % put in general matrix, replace if necessary:
   for in=1:numel(names)
      if ismember(names{in},dec.names)
         ind               = find(ismember(dec.names,names{in}));
         dec.mat(:,ind)    = addmat(:,in);
      else
         dec.mat(:,end+1)  = addmat(:,in);
         dec.names{end+1}  = names{in};
      end
   end
end


end