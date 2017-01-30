function createTrainBinaryGraphFullObsPW(frames,clusters,label,classNumbers,HNoStates,i,path,pairwisePot,pairwiseLoss)

YNoStates = classNumbers;
framesNo = size(frames,1);%%tedade dade
PwWNo =  HNoStates*YNoStates;
potIndx = 1;

for k = 1 : PwWNo
    pairwiseRefTable(k) = potIndx;
    Sample.Potentials{potIndx}.IX = potIndx;
    potP = zeros(1,PwWNo);
    potP(k) = pairwisePot;
    Sample.Potentials{potIndx}.pot = potP;
    potIndx = potIndx + 1;
end

for n = 1 : YNoStates
    pwLossRefTable(n) = potIndx;
    Sample.Potentials{potIndx}.IX = potIndx;
    lossPw = zeros(1,PwWNo);
    for k = 1 : HNoStates
        for l = 1 : YNoStates
            if l ~= n
                samplePwIdx = (l-1)*HNoStates + k;
                lossPw(1,samplePwIdx) = pairwiseLoss;
            end
        end
    end
    Sample.Potentials{potIndx}.pot = lossPw;
    potIndx = potIndx + 1;
end

Sample.VariableCardinalities = HNoStates* ones(1,framesNo);
Sample.VariableCardinalities = [Sample.VariableCardinalities YNoStates];

Sample.Observation = [];
Sample.MachineIDs = [];
YIndex = framesNo +1;
tic
for j = 1 : framesNo
    pw_region_indx = j;
    Sample.Observation = [Sample.Observation  clusters(j)];
    Sample.MachineIDs = [Sample.MachineIDs  1];
    
    % % % % % % % % %         pairwise region             % % % % % % % % % %
    
    Sample.Regions{pw_region_indx}.c_r = 1;
    Sample.Regions{pw_region_indx}.VariableIndices = [j YIndex];
    Sample.Regions{pw_region_indx}.Parents = [];
    
    for k = 1 : HNoStates
        for l = 1 : YNoStates
            samplePwIdx = (l-1)*HNoStates + k;
            Sample.Regions{pw_region_indx}.Features{samplePwIdx}.r = samplePwIdx;
            %             if l == video.videoLabelNo
            Sample.Regions{pw_region_indx}.Features{samplePwIdx}.potIX = pairwiseRefTable(samplePwIdx);
            %             else
            %                 Sample.Regions{pw_region_indx}.Features{samplePwIdx}.potIX = zeroTable(2);
            %             end
        end
    end
    
    Sample.Regions{pw_region_indx}.LossIX = pwLossRefTable(label);
    
    
end
Sample.Observation = [Sample.Observation  label];
Sample.MachineIDs = [Sample.MachineIDs  1];

WriteOutputBinaryX(Sample,i,path);

disp(toc);
end