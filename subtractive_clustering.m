%% Subtractive Clustering

function [centers,sigmas] = subtractive_clustering(data,ra,bounds,quash_factor,eps_high,eps_low)

    centers=[];
    
    %Confine Data to Unit Hypercube
    if(isempty(bounds))
        xmin=min(data,[],1);
        xmax=max(data,[],1);
    else
        xmin=bounds(1,:);
        xmax=bounds(2,:);
    end
    xmin=repmat(xmin,[length(data) 1]);
    xmax=repmat(xmax,[length(data) 1]);
    data=(data-xmin)./(xmax-xmin);
    
    %Perform Subtractive Clustering
    alpha=4/(ra^2);
    P=Potential(data,centers,alpha);
    [P1_star,idx]=max(P);
    centers=[centers;data(idx,:)];
    rb=quash_factor*ra;
    beta=4/(rb^2);
    for i=2:length(data)
        P=P-P1_star*Potential(data,centers,beta);
        count=0;
        while(count<length(P)-1)
            [Pk_star,idx]=max(P);
            candidate=data(idx,:);
            check=criteria(P1_star,Pk_star,eps_high,eps_low,ra,centers,candidate);
            if(check==1)
                centers=[centers;candidate];
                break;
            elseif(check==0)
                break;
            else
                P(idx)=0;
                continue;
            end
        end
        if(check==0)
            break;
        end
    end
    
    if(isempty(bounds))
        sigmas=repmat(1/(sqrt(2)*sqrt(alpha)),[1 size(data,2)]);
    else
        centers=centers.*repmat((bounds(2,:)-bounds(1,:)),[size(centers,1) 1])+repmat(bounds(1,:),[size(centers,1) 1]);
        sigmas=ra*(bounds(2,:)-bounds(1,:))/sqrt(8);
    end
    
end