function blocks=runs_to_blocks(conditionRegressor)

%this function transforms the condition regressor matrix into a matrix where each
%block (or active condition with the following rest block) will be given a
%number in the same format as the run selector. This is to create the cross
%validation indices based on blocks and not based on runs.
%adujsted for the haemodynamic lag



timePoints=length(conditionRegressor);
blocks=zeros(1,timePoints);
conditionVector=sum(conditionRegressor);
blockCount=0;
for i=1:timePoints
    if conditionVector(i)>0
        if conditionVector(i)>conditionVector(i-1)
            blockCount=blockCount+1;
        end
    end
    if blockCount==0
        blocks(i)=1;
    else
        blocks(i)=blockCount;
    end
end

end