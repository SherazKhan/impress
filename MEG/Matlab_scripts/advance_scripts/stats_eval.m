function [clussum_pos,clussum_neg,maskpos,maskneg]=stats_eval(Stats,maskpos,maskneg,Thresh)

clussum_pos=0;
if ~isempty(Stats.posclus) && Stats.posclus(1).pvalue <=Thresh
    
    
    for iclus=1:length(Stats.posclus)
        
        if Stats.posclus(iclus).pvalue<=Thresh
            clussum_pos=clussum_pos+Stats.posclus(iclus).clustermass;
            maskpos=maskpos+Stats.posclus(iclus).mask;
        end
    end
    
            
end

clussum_neg=0;
if ~isempty(Stats.negclus) && Stats.negclus(1).pvalue <=Thresh
    
    
    for iclus=1:length(Stats.negclus)
        
        if Stats.negclus(iclus).pvalue<=Thresh
            clussum_neg=clussum_neg+Stats.negclus(iclus).clustermass;
            maskneg=maskneg+Stats.negclus(iclus).mask;
        end
    end
            
end
