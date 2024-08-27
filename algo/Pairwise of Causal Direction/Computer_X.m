function XX= Computer_X(XX,U_K,Pa,Cov)
for i=U_K
    XX(i,:)=XX(i,:) - Cov(i,Pa)/Cov(Pa,Pa)*XX(Pa,:);
end

end

