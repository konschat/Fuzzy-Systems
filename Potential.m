%% Potential of Cluster Candidate Points

function P = Potential(data,centers,expon)

    if(isempty(centers))
        x1=sum(data.^2,2);
        x1=repmat(x1,[1 length(data)]);
        x2=x1';
        x12=data*data';
        dist=x1+x2-2*x12;
        P=exp(-expon*dist);
        P=sum(P,2);
    else
        x1=sum(data.^2,2);
        center=centers(end,:);
        center=repmat(center,[length(data) 1]);
        x2=sum(center.^2,2);
        x12=data*center';
        dist=x1+x2-2*x12(:,1);
        P=exp(-expon*dist);
    end

end