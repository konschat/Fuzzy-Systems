%% Criteria of Cluster Candidate Points

function check = criteria(P1,Pk,eps_high,eps_low,ra,centers,candidate)

   if(Pk>eps_high*P1)
       check=1;
   elseif(Pk<eps_low*P1)
       check=0;
   else
       dmin=min(dist(centers,candidate'));
       if((dmin/ra)+(Pk/P1) >= 1)
           check=1;
       else
           check=0;
       end
   end

end