function createTrainBinaryGraphFullObsTpMin(frames,clusters,label,classNumbers,HNoStates,i,path,triplePot,tripleLoss)

YNoStates = classNumbers;
framesNo = size(frames,1);

TripleWNo = HNoStates*HNoStates*YNoStates;
potIndx = 1;

for k = 1 : TripleWNo
    tripleRefTable(k) = potIndx;
    Sample.Potentials{potIndx}.IX = potIndx;
    potT = zeros(1,TripleWNo);
    potT(k) = triplePot;
    Sample.Potentials{potIndx}.pot = potT;
    potIndx = potIndx + 1;
end

for n = 1 : YNoStates
    trLossRefTable(n) = potIndx;
    Sample.Potentials{potIndx}.IX = potIndx;
    lossTriple = zeros(1,TripleWNo);
    for k = 1 : HNoStates
        for l = 1 : HNoStates
            for m = 1 : YNoStates
                if m ~= n
                    sampleTripIdx = (m-1)*HNoStates*HNoStates + (l-1)*HNoStates +k;
                    lossTriple(1,sampleTripIdx) = tripleLoss;
                end
            end
        end
    end
    Sample.Potentials{potIndx}.pot = lossTriple;
    potIndx = potIndx + 1;
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
Sample.VariableCardinalities = HNoStates* ones(1,framesNo);
Sample.VariableCardinalities = [Sample.VariableCardinalities YNoStates];

Sample.Observation = [];
Sample.MachineIDs = [];
YIndex = framesNo +1;

tic
for j = 2 : framesNo+1
    
%     pw_region_indx = j+framesNo;
    tripleRegionIndex = j-1;
    
    Sample.Observation = [Sample.Observation  clusters(j-1)];
    Sample.MachineIDs = [Sample.MachineIDs  1];
    
%     if j==4
%         continue;
%     end
    % % % % % % % % %         triple region             % % % % % % % % % %
    
    Sample.Regions{tripleRegionIndex}.Parents = [];
    Sample.Regions{tripleRegionIndex}.c_r = 1;
    if j<4
        Sample.Regions{tripleRegionIndex}.VariableIndices = [j-1 j YIndex];
    elseif j == 4
        Sample.Regions{tripleRegionIndex}.VariableIndices = [j-1 1 YIndex];
    end
    %     pot_triple = zeros(HNoStates*HNoStates*YNoStates,HNoStates,HNoStates,YNoStates);
    tpCounter = 1;
    for k = 1 : HNoStates
        for l = 1 : HNoStates
            for m = 1 : YNoStates
                                
                
%                                 if m == label
                                                    sampleTripIdx = (m-1)*HNoStates*HNoStates + (l-1)*HNoStates +k;
                                                    Sample.Regions{tripleRegionIndex}.Features{tpCounter}.r = sampleTripIdx;
                                                    Sample.Regions{tripleRegionIndex}.Features{tpCounter}.potIX = tripleRefTable(sampleTripIdx);
                                                    tpCounter =tpCounter+1;
%                                 else

%                                 end
            end
        end
    end

    Sample.Regions{tripleRegionIndex}.LossIX = trLossRefTable(label);
    
    
    
    
end
Sample.Observation = [Sample.Observation  label];
Sample.MachineIDs = [Sample.MachineIDs  1];

WriteOutputBinaryX(Sample,i,path);

disp(toc);
end