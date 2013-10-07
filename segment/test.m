for i=1:length(CoinVal)
    idx = ismember(coi(:,2), CoinVal(i));
    idx = find(idx);
    if isempty(idx)
        eval(['coin_array.' CoinName{i} '=0;']);
    else
        eval(['coin_array.' CoinName{i} '=coi(idx,1);']);
    end;
end;