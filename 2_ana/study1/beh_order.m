function beh_order(dec,outfolder)
% descriptive function for plotting behaviour
% MKW 2022
%%

n = numel(dec);


for is = 1:n
   tp       = gfM(dec{is}.dec,{'S-TimePos','Pa-TimePos','O1-TimePos','O2-TimePos'});
   decno    = gfM(dec{is}.dec,'decNo');                                         % each trial has two decisions, so do analysis for only first one to get each sequence once
   matraw{is}=tp(decno==1,:);
   mat{is}  = sortrows(matraw{is});
end


% error check - are all mat identical?
for is = 2:n
    ok = mat{is}(:)-mat{1}(:);
    if sum(abs(ok)) ~= 0, disp('ERROR'); keyboard; end
end

exportCsv([outfolder 'beh_order_' date], mat{1}, {'Timepos1','Timepos2','Timepos3','Timepos4'}); % players codded as 1=self, 2=partner, 3=O1, 4=O2  

end

