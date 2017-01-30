function createTrainBinaryGraphUnary_hcrf(label, video,classNumbers,i,path,clusters,Hstates)

HNoStates = Hstates;
% HNoStates = 8;
% label = video.label;

YNoStates = classNumbers;
% YNoStates = 100;
% framesNo = size(video,1);%size(video.joint_locations,3);
framesNo = 3;%size(video.joint_locations,3);
% featureDim = size(video.joint_locations,2)*3;%*2;
% featureDim = 54;%*2; for 6 joints and distances



featureDim = size(video,2);%3*15*2;
% featureDim = 90;%3*(15+15);%both persons
UnaryWNo = HNoStates*featureDim;
potIndx = 1;
Sample.VariableCardinalities = HNoStates* ones(1,framesNo);
Sample.Observation = [];
Sample.MachineIDs = [];


data =  video;


tic
for j = 1 : framesNo
    
    Sample.Observation = [Sample.Observation  clusters(j)];
    Sample.MachineIDs = [Sample.MachineIDs  1];
% % % % % % % % % % % %      /phi(x_i,z_i)       % % % % % % % % % % % % % % % %     

    Sample.Regions{j}.c_r = 1;
    Sample.Regions{j}.VariableIndices = [j];
    Sample.Regions{j}.Parents = [];
    potu = zeros(HNoStates, HNoStates*featureDim);
    for potuRowIndex = 1 : HNoStates
        potuColBeginIndex = (potuRowIndex-1)*featureDim+1;
        potuColEndIndex = (potuRowIndex-1)*featureDim+featureDim;
%         temp = data(:,[2,3,6,9,12,15],j);
        temp = data(j,:);
        potu(potuRowIndex,potuColBeginIndex:potuColEndIndex) = temp(:);
    end
    potu = potu';
    for k  = 1 : UnaryWNo
        Sample.Regions{j}.Features{k}.r = k;
        Sample.Regions{j}.Features{k}.potIX = potIndx;
        Sample.Potentials{potIndx}.IX = potIndx;
        Sample.Potentials{potIndx}.pot = potu(k,:);
        potIndx = potIndx + 1;
    end
        
    Sample.Regions{j}.LossIX = potIndx;
    Sample.Potentials{potIndx}.IX = potIndx;
    Sample.Potentials{potIndx}.pot = (zeros(1,HNoStates));
    potIndx = potIndx + 1;
    
end

disp(num2str(Sample.Observation))

WriteOutputBinaryX(Sample,i,path);
toc
end