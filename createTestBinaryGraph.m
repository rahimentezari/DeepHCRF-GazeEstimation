% function createTestBinaryGraph(video,classNumbers,HNoStates,i,path,triplePot,pairwisePot)
function createTestBinaryGraph(frames,classNumbers,i, path, HNoStates,triplePot, pairwisePot)

% this function will create HCRF graphical model for test phase.
% HCRF is created from three type factors :
% /phi(x_i,z_i)
% /phi(y,z_i)
% /phi(y,z_i,z_i+1)

YNoStates = classNumbers;
framesNo = size(frames,1);
featureDim = size(frames,2);
UnaryWNo = HNoStates*featureDim;
PwWNo =  HNoStates*YNoStates;
TripleWNo = HNoStates*HNoStates*YNoStates;

% pairwiseLoss = 10;
% tripleLoss = 20;

Sample.VariableCardinalities = HNoStates* ones(1,framesNo);
Sample.VariableCardinalities = [Sample.VariableCardinalities YNoStates];

Sample.Observation = [];
Sample.MachineIDs = [];
YIndex = framesNo +1;
% potIndx = 1;
tic
potIndx = 1;
zeroTable(1) = potIndx;
Sample.Potentials{potIndx}.IX = potIndx;
Sample.Potentials{potIndx}.pot = zeros(1,HNoStates);
potIndx = potIndx + 1;

zeroTable(2) = potIndx;
Sample.Potentials{potIndx}.IX = potIndx;
Sample.Potentials{potIndx}.pot = zeros(1,PwWNo);
potIndx = potIndx + 1;

zeroTable(3) = potIndx;
Sample.Potentials{potIndx}.IX = potIndx;
Sample.Potentials{potIndx}.pot = zeros(1,TripleWNo);
potIndx = potIndx + 1;

% for k = 1 : HNoStates
%     unaryRefTable(k) = potIndx;
%     Sample.Potentials{potIndx}.IX = potIndx;
%     potU = zeros(1,HNoStates);
%     potU(k) = clusterPot;
%     Sample.Potentials{potIndx}.pot = potU;
%     potIndx = potIndx + 1;
% end

for k = 1 : PwWNo
    pairwiseRefTable(k) = potIndx;
    Sample.Potentials{potIndx}.IX = potIndx;
    potP = zeros(1,PwWNo);
    potP(k) = pairwisePot;
    Sample.Potentials{potIndx}.pot = potP;
    potIndx = potIndx + 1;
end

% for n = 1 : YNoStates
%     pwLossRefTable(n) = potIndx;
%     Sample.Potentials{potIndx}.IX = potIndx;
%     lossPw = zeros(1,PwWNo);
%     for k = 1 : HNoStates
%         for l = 1 : YNoStates
%             if l ~= n
%                 samplePwIdx = (l-1)*HNoStates + k;
%                 lossPw(1,samplePwIdx) = pairwiseLoss;
%             end
%         end
%     end
%     Sample.Potentials{potIndx}.pot = lossPw;
%     potIndx = potIndx + 1;
% end

for k = 1 : TripleWNo
    tripleRefTable(k) = potIndx;
    Sample.Potentials{potIndx}.IX = potIndx;
    potT = zeros(1,TripleWNo);
    potT(k) = triplePot;
    Sample.Potentials{potIndx}.pot = potT;
    potIndx = potIndx + 1;
end

potIndx=1;
% for n = 1 : YNoStates
%     trLossRefTable(n) = potIndx;
%     Sample.Potentials{potIndx}.IX = potIndx;
%     lossTriple = zeros(1,TripleWNo);
%     for k = 1 : HNoStates
%         for l = 1 : HNoStates
%             for m = 1 : YNoStates
%                 if m ~= n
%                     sampleTripIdx = (m-1)*HNoStates*HNoStates + (l-1)*HNoStates +k;
%                     lossTriple(1,sampleTripIdx) = tripleLoss;
%                 end
%             end
%         end
%     end
%     Sample.Potentials{potIndx}.pot = lossTriple;
%     potIndx = potIndx + 1;
% end



for j = 1 : framesNo
    
    pw_region_indx = j+framesNo;
    tripleRegionIndex = j + framesNo*2 ;
    
    Sample.Observation = [Sample.Observation  0];
    Sample.MachineIDs = [Sample.MachineIDs  1];
    
    if(j == 1)
        Sample.Regions{j}.Parents = [pw_region_indx tripleRegionIndex + 1];
        Sample.Regions{pw_region_indx}.Parents = [tripleRegionIndex+1];
    else if (j == framesNo)
            Sample.Regions{j}.Parents = [pw_region_indx tripleRegionIndex] ;
            Sample.Regions{pw_region_indx}.Parents = [tripleRegionIndex];
        else
            Sample.Regions{j}.Parents = [pw_region_indx tripleRegionIndex tripleRegionIndex+1];
            Sample.Regions{pw_region_indx}.Parents = [tripleRegionIndex tripleRegionIndex+1];
        end
    end
    
    
    % % % % % % % % % % % %      /phi(x_i,z_i)       % % % % % % % % % % % % % % % %
    
    Sample.Regions{j}.c_r = 1;
    Sample.Regions{j}.VariableIndices = [j];
    potu = zeros(HNoStates, HNoStates*featureDim);
    for potuRowIndex = 1 : HNoStates
        potuColBeginIndex = (potuRowIndex-1)*featureDim+1;
        potuColEndIndex = (potuRowIndex-1)*featureDim+featureDim;
        potu(potuRowIndex,potuColBeginIndex:potuColEndIndex)=frames(j,:);
    end
    potu = potu';
    for k  = 1 : UnaryWNo
        Sample.Regions{j}.Features{k}.r = k;
        Sample.Regions{j}.Features{k}.potIX = potIndx;
        Sample.Potentials{potIndx}.IX = potIndx;
        Sample.Potentials{potIndx}.pot = potu(k,:);
        potIndx = potIndx + 1;
        
    end
    
    % define prior weight
    
    
    
    Sample.Regions{j}.LossIX = potIndx;
    Sample.Potentials{potIndx}.IX = potIndx;
    Sample.Potentials{potIndx}.pot = (zeros(1,HNoStates));
    potIndx = potIndx + 1;
    %
    
    % % % % % % % % %         pairwise region             % % % % % % % % % %
    
    
    Sample.Regions{pw_region_indx}.c_r = 1;
    Sample.Regions{pw_region_indx}.VariableIndices = [j YIndex];
    %     pot_pw = zeros(HNoStates*YNoStates, HNoStates,YNoStates);
    
    for k = 1 : HNoStates
        for l = 1 : YNoStates
            samplePwIdx = (l-1)*HNoStates + k;
            Sample.Regions{pw_region_indx}.Features{samplePwIdx}.r = samplePwIdx+UnaryWNo;
            %             if l == video.videoLabelNo
            Sample.Regions{pw_region_indx}.Features{samplePwIdx}.potIX = pairwiseRefTable(samplePwIdx);
            %             else
            %                 Sample.Regions{pw_region_indx}.Features{samplePwIdx}.potIX = zeroTable(2);
            %             end
        end
    end
    %     for k  = 1 : PwWNo
    %         Sample.Regions{pw_region_indx}.Features{k}.r = k+UnaryWNo;
    %         Sample.Regions{pw_region_indx}.Features{k}.potIX = pairwiseRefTable();
    % %         Sample.Potentials{potIndx}.IX = potIndx;
    % %         vec = pot_pw(k,:,:);
    % %
    % %         Sample.Potentials{potIndx}.pot = reshape(vec,[1,size(vec,1)*size(vec,2)*size(vec,3)]);
    % %         potIndx = potIndx + 1;
    %     end
    
    Sample.Regions{pw_region_indx}.LossIX = zeroTable(2);
    %     Sample.Potentials{potIndx}.IX = potIndx;
    %     lossPw = zeros(1,PwWNo);
    %
    %     for k = 1 : HNoStates
    %         for l = 1 : YNoStates
    %             if l ~= video.videoLabelNo
    %                 samplePwIdx = (l-1)*HNoStates + k;
    %                 lossPw(1,samplePwIdx) = pairwiseLoss;
    %             end
    %         end
    %     end
    %     Sample.Potentials{potIndx}.pot = lossPw;
    %     potIndx = potIndx + 1;
    
    
%     if j==1
%         continue;
%     end
    % % % % % % % % %         triple region             % % % % % % % % % %
    
    Sample.Regions{tripleRegionIndex}.Parents = [];
    Sample.Regions{tripleRegionIndex}.c_r = 1;
    if j<framesNo
        Sample.Regions{tripleRegionIndex}.VariableIndices = [j j+1 YIndex];
    elseif j == framesNo
        Sample.Regions{tripleRegionIndex}.VariableIndices = [j 1 YIndex];
    end
    %     pot_triple = zeros(HNoStates*HNoStates*YNoStates,HNoStates,HNoStates,YNoStates);
    
    for k = 1 : HNoStates
        for l = 1 : HNoStates
            for m = 1 : YNoStates
                sampleTripIdx = (m-1)*HNoStates*HNoStates + (l-1)*HNoStates +k;
                Sample.Regions{tripleRegionIndex}.Features{sampleTripIdx}.r = sampleTripIdx+UnaryWNo+PwWNo;
                
                %                 if m == video.videoLabelNo
                Sample.Regions{tripleRegionIndex}.Features{sampleTripIdx}.potIX = tripleRefTable(sampleTripIdx);
                %                 else
                % %                     pot_triple(sampleTripIdx,k,l,m) = triplePot;
                % Sample.Regions{tripleRegionIndex}.Features{sampleTripIdx}.potIX = zeroTable(3);
                %                 end
            end
        end
    end
    %     pot_triple = pot_triple';
    %     for k  = 1 : TripleWNo
    %
    %         Sample.Potentials{potIndx}.IX = potIndx;
    %         vec = pot_triple(k,:,:,:);
    %         Sample.Potentials{potIndx}.pot = reshape(vec,[1,size(vec,1)*size(vec,2)*size(vec,3)*size(vec,4)]);
    %         potIndx = potIndx + 1;
    %     end
    
    Sample.Regions{tripleRegionIndex}.LossIX = zeroTable(3);
    
    
    
end


% YRegionIndex = 3*framesNo;
% Sample.Regions{YRegionIndex}.Parents = [];
% for k = framesNo+3 : 2*framesNo-1
%     Sample.Regions{YRegionIndex}.Parents = [Sample.Regions{YRegionIndex}.Parents k];
% end
% Sample.Regions{YRegionIndex}.c_r = 1;
% Sample.Regions{YRegionIndex}.VariableIndices = [YIndex];
% pot_Y = 1000*ones(YNoStates,1);
% Sample.Regions{YRegionIndex}.Features{1}.r = TripleWNo+UnaryWNo+PwWNo+1;
% Sample.Regions{YRegionIndex}.Features{1}.potIX = potIndx;
% Sample.Potentials{potIndx}.IX = potIndx;
% Sample.Potentials{potIndx}.pot = pot_Y;
% potIndx = potIndx + 1;
% Sample.Regions{YRegionIndex}.LossIX = potIndx;
% Sample.Potentials{potIndx}.IX = potIndx;
% lossY = zeros(YNoStates,1);
% Sample.Potentials{potIndx}.pot = lossY;
% potIndx = potIndx + 1;


Sample.Observation = [Sample.Observation  0];
Sample.MachineIDs = [Sample.MachineIDs  1];

WriteOutputBinaryX(Sample,i,path);
disp(toc);
end