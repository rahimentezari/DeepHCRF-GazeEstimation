% clear;
% 
% %%%load data%%%
% load('/home/deep/rahim/PGM/Final/stuffNeeded/allfeatures-parts234.mat')
% traindata=d(:,:,1:8003);
% testdata=d(:,:,192875:196184);
% 
% 
% %%%load labels%%%
% load('/home/deep/rahim/PGM/Final/stuffNeeded/alllabels-50class-1.mat')
% trainlabel=labels(1:8003,1);
% testlabel=labels(192875:196184,1);
% 
% 
% %%%%load clusters%%%
% load('/home/deep/rahim/PGM/Final/stuffNeeded/allfeatures-clusters-parts234.mat')
% traincluster=cluster(:,1:8003);
% testcluster=cluster(:,192875:196184);
% 
% 
% 
% 
% data = [];
% y = [];
% YNoStates = 50;
% HNoStates = 8;
% counter = 1;
% counter_true = 0;
% start = 0;
% last = 0;
% complete_data = [];
% 
% 
% 
% 
% 
% window=4000;
% 
% for i=1:size(traindata,3)
%     for i=1:window
% 
%     complete_data=traindata(:,:,i);
% 
%     disp(['label is: ', trainlabel(i,1)]);
% 
%     label = trainlabel(i,1);
%     createTrainBinaryGraphUnary_hcrf(label,complete_data,YNoStates,i,'/home/deep/rahim/PGM/Final/learn/data/train_unary/',traincluster(:,i),HNoStates);
%     createTrainBinaryGraphFullObsPW(complete_data,traincluster(:,i),label,YNoStates,HNoStates,i,'/home/deep/rahim/PGM/Final/learn/data/train_pw/',10,1);
%     createTrainBinaryGraphFullObsTpMin(complete_data,traincluster(:,i),label,YNoStates,HNoStates,i, '/home/deep/rahim/PGM/Final/learn/data/train_triple/',10,1);    
% 
%     end
% end
% 
% Params.CCCPIterations = 200;
% Params.epsilon = 1;
% Params.tol = 1e-14;
% Params.ReadBinary = 1;
% Params.CRFIterations = 1;
% Params.C = 0.0;
% Params.p = 1;
% Params.BetheCountingNumbers = 1;
% range.max = 100;
% range.min = -100;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RandomWeights( 0 ,HNoStates*size(complete_data,2),'/home/deep/rahim/PGM/Final/learn/data/wInit_unary1.wt',range);
% 
% Params.CCCPIterations = 50;
% command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_unary' , {' -y '}, num2str(Params.ReadBinary) ...
%     ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_unary.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%     {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%     num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol)...
%     ,{' -w /home/deep/rahim/PGM/Final/learn/data/wInit_unary1.wt'});
% 
% [status,cmdout] = system(command{1},'-echo');
% 
% w_unary1 = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_unary.wt');
% maxWU = max(w_unary1);
% w_unary1 = w_unary1 ./ abs(maxWU).* 100;
% writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_unary2.wt',w_unary1);
% 
% 
% Params.CCCPIterations = 400;
% command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_unary' , {' -y '}, num2str(Params.ReadBinary) ...
%     ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_unary.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%     {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%     num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol)...
%     ,{' -w /home/deep/rahim/PGM/Final/learn/data/wInit_unary2.wt'});
% 
% [status,cmdout] = system(command{1},'-echo');
% % break;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RandomWeights( 0 ,YNoStates*HNoStates,'/home/deep/rahim/PGM/Final/learn/data/wInit_pw1.wt',range);
% Params.CCCPIterations = 50;
% command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_pw' , {' -y '}, num2str(Params.ReadBinary) ...
%     ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_pw.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%     {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%     num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol),...
%     {' -w /home/deep/rahim/PGM/Final/learn/data/wInit_pw1.wt'});
% 
% [status,cmdout] = system(command{1},'-echo');
% 
% w_pw1 = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_pw.wt');
% maxWP = max(w_pw1);
% w_pw1 = w_pw1 ./ abs(maxWP).* 100;
% writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_pw2.wt',w_pw1);
% 
% 
% Params.CCCPIterations = 400;
% command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_pw' , {' -y '}, num2str(Params.ReadBinary) ...
%     ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_pw.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%     {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%     num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol),...
%     {' -w /home/deep/rahim/PGM/Final/learn/data/wInit_pw2.wt'});
% 
% [status,cmdout] = system(command{1},'-echo');
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% RandomWeights( 0 ,YNoStates*HNoStates*HNoStates,'/home/deep/rahim/PGM/Final/learn/data/wInit_triple1.wt',range);
% Params.CCCPIterations = 5;
% command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_triple' , {' -y '}, num2str(Params.ReadBinary) ...
%     ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_triple.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%     {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%     num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol),...
%     {' -w /home/deep/rahim/PGM/Final/learn/data/wInit_triple1.wt'});
% 
% [status,cmdout] = system(command{1},'-echo');
% 
% 
% w_tp1 = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_triple.wt');
% maxWT = max(w_tp1);
% w_tp1 = w_tp1 ./ abs(maxWT).* 100;
% writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_triple2.wt',w_tp1);
% 
% 
% Params.CCCPIterations = 30;
% command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_triple' , {' -y '}, num2str(Params.ReadBinary) ...
%     ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_triple.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%     {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%     num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol),...
%     {' -w /home/deep/rahim/PGM/Final/learn/data/wInit_triple2.wt'});
% 
% [status,cmdout] = system(command{1},'-echo');
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% w_unary = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_unary.wt');
% w_pw = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_pw.wt');
% w_triple = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_triple.wt');
% 
% w_concat = [w_unary' w_pw' w_triple'];
% maxWU = max(w_concat);
% w_concat = w_concat ./ abs(maxWU).* 100;
% writeWeights('/home/deep/rahim/PGM/Final/learn/data/weights.wt',w_concat);
% 
% 
% 





% for k=1:fix(size(traindata,3)/window)+1
    
%     delete('/home/deep/rahim/PGM/Final/learn/data/train_unary/*')
%     delete('/home/deep/rahim/PGM/Final/learn/data/train_pw/*')
%     delete('/home/deep/rahim/PGM/Final/learn/data/train_triple/*')
    
%     w_concat = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/weights.wt');
    
%     wInit_unary1=(w_concat(1:1872))';
%     writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_unary1.wt',wInit_unary1);
%     
%     wInit_pw1=(w_concat(1873:2272))';
%     writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_pw1.wt',wInit_pw1);
%     
%     wInit_triple1=(w_concat(2273:5472))';
%     writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_triple1.wt',wInit_triple1);
    
%     if i<=size(traindata,3)    
%         for i=k*window+1:(k+1)*window
%             if i<=size(traindata,3)
%                 complete_data=traindata(:,:,i);
%                 disp(['label is: ', trainlabel(i,1)]);
%                 label = trainlabel(i,1);
%                 createTrainBinaryGraphUnary_hcrf(label,complete_data,YNoStates,i,'/home/deep/rahim/PGM/Final/learn/data/train_unary/',traincluster(:,i),HNoStates);
%                 createTrainBinaryGraphFullObsPW(complete_data,traincluster(:,i),label,YNoStates,HNoStates,i,'/home/deep/rahim/PGM/Final/learn/data/train_pw/',10,1);
%                 createTrainBinaryGraphFullObsTpMin(complete_data,traincluster(:,i),label,YNoStates,HNoStates,i, '/home/deep/rahim/PGM/Final/learn/data/train_triple/',10,1);    
%             end
% 
%         end
    

    
        
%         Params.CCCPIterations = 50;
%         Params.C=20;
%         command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_unary1000' , {' -y '}, num2str(Params.ReadBinary) ...
%             ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_unary.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%             {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%             num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol)...
%             ,{' -w /home/deep/rahim/PGM/Final/learn/data/wInit_unary1.wt'});
% 
%         [status,cmdout] = system(command{1},'-echo');
% 
%         w_unary1 = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_unary.wt');
%         maxWU = max(w_unary1);
%         w_unary1 = w_unary1 ./ abs(maxWU).* 100;
%         writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_unary2.wt',w_unary1);
% 
% 
%         Params.CCCPIterations = 3000;
%         command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_unary1000' , {' -y '}, num2str(Params.ReadBinary) ...
%             ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_unary.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%             {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%             num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol)...
%             ,{' -w /home/deep/rahim/PGM/Final/learn/data/wInit_unary2.wt'});
% 
%         [status,cmdout] = system(command{1},'-echo');
        % break;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Params.CCCPIterations = 50;
%         Params.C=40;
%         command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_pw1000' , {' -y '}, num2str(Params.ReadBinary) ...
%             ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_pw.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%             {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%             num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol),...
%             {' -w /home/deep/rahim/PGM/Final/learn/data/wInit_pw1.wt'});
% 
%         [status,cmdout] = system(command{1},'-echo');
% 
%         w_pw1 = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_pw.wt');
%         maxWP = max(w_pw1);
%         w_pw1 = w_pw1 ./ abs(maxWP).* 100;
%         writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_pw2.wt',w_pw1);
% 
% 
%         Params.CCCPIterations = 7000;
%         command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_pw1000' , {' -y '}, num2str(Params.ReadBinary) ...
%             ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_pw.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%             {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%             num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol),...
%             {' -w /home/deep/rahim/PGM/Final/learn/data/wInit_pw2.wt'});
% 
%         [status,cmdout] = system(command{1},'-echo');
% 
%         % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%         
%         Params.CCCPIterations = 50;
%         Params.C=100;
%         command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_triple1000' , {' -y '}, num2str(Params.ReadBinary) ...
%             ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_triple.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%             {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%             num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol),...
%             {' -w /home/deep/rahim/PGM/Final/learn/data/wInit_triple1.wt'});
% 
%         [status,cmdout] = system(command{1},'-echo');
% 
% 
%         w_tp1 = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_triple.wt');
%         maxWT = max(w_tp1);
%         w_tp1 = w_tp1 ./ abs(maxWT).* 100;
%         writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_triple2.wt',w_tp1);
% 
% 
%         Params.CCCPIterations = 500;
%         command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -d '} , '/home/deep/rahim/PGM/Final/learn/data/train_triple1000' , {' -y '}, num2str(Params.ReadBinary) ...
%             ,{' -l '},{'/home/deep/rahim/PGM/Final/learn/data/wInit_triple.wt'} , {' -e '} ,num2str(Params.epsilon) ,...
%             {' -i '} , num2str(Params.CCCPIterations) , {' -j '} ,num2str(Params.CRFIterations),{' -c '},num2str(Params.C),{' -b '},...
%             num2str(Params.BetheCountingNumbers),{' -p '},num2str(Params.p),{' -s '},num2str(Params.tol),...
%             {' -w /home/deep/rahim/PGM/Final/learn/data/wInit_triple2.wt'});
% 
%         [status,cmdout] = system(command{1},'-echo');
% 
% 
%         w_unary = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_unary.wt');
%         w_pw = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_pw.wt');
%         w_triple = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/wInit_triple.wt');
% 
%         w_concat = [w_unary' w_pw' w_triple'];
%         maxWU = max(w_concat);
%         w_concat = w_concat ./ abs(maxWU).* 100;
%         % writeWeights('/home/deep/rahim/PGM/Final/learn/data/wInit_concat.wt',w_concat);
%         writeWeights('/home/deep/rahim/PGM/Final/learn/data/weights.wt',w_concat); 
% 
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Test%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
complete_data = [];
testdata2=testdata(:,:,1:10);
testlabel2=testlabel(1:10,:);
for i=1:size(testdata2,3)
    complete_data=testdata(:,:,i);
    disp(['test number is: ', i]);
    label = testlabel2(i,1);
    createTestBinaryGraph(complete_data,YNoStates,i,'/home/deep/rahim/PGM/Final/learn/data/test/',HNoStates, 10, 10);
end

Params.Task = 2;
    command = strcat({'/home/deep/rahim/PGM/Final/dSP_5.2/prog_dLSP'},{' -t '} , num2str(Params.Task),{' -d '}, '/home/deep/rahim/PGM/Final/learn/data/test/', ...
        {' -w '}, {'/home/deep/rahim/PGM/Final/learn/data/weights.wt'}...
        , {' -l '}  , {'/home/deep/rahim/PGM/Final/learn/data/pred.prd'}, {' -y '}, num2str(Params.ReadBinary));
    [status,cmdout] = system(command{1},'-echo');
    results = ReadOutput('/home/deep/rahim/PGM/Final/learn/data/pred.prd');
    for j = 1:size(results,2)
        counter = counter + 1;
        file_name = create_cbp_file(results{1,j}, j, YNoStates, HNoStates, '/home/deep/rahim/PGM/Final/learn/data/test/');
        % delete('LocalBeliefs.txt');
        
        delete('/home/deep/rahim/PGM/Final/learn/data/LocalBeliefs.txt')%??
        [status,cmdout] = system(['mpiexec -n 3 /home/deep/rahim/PGM/Final/dcBP/dcBP -f ', file_name, ' -o /home/deep/rahim/PGM/Final/learn/data/LocalBeliefs.txt', ' -e 0.3 -c 10 -s 10']);
        %     [status,cmdout] = system(['mpiexec -n 2 /home/deep/rahim/PGM/Final/dcBP/dcBP -f ', file_name, ' -e 0.3 -c 10 -s 10']);
        fid = fopen('/home/deep/rahim/PGM/Final/learn/data/LocalBeliefs.txt','rb');
        %     fid = fopen('/home/deep/rahim/PGM/Final/dcBP/LocalBeliefs.txt','rb');
        locBel = fread(fid,inf,'double');
        YLocBel = locBel(end-YNoStates+1:end,1);
        
        %disp('local beliefs are:')
        %locBel'
        
        [v Midx] = max(YLocBel);
        
        %%%%%%%%%%%%%%%%%%%%%
        framesNo = (length(locBel)-YNoStates)/(HNoStates);
        for k = 1 : framesNo
            zBel(k,:) = locBel((k-1)*HNoStates+1:k*HNoStates);
        end
        
        [v mx] = max(zBel');
        clear zBel;
        disp('Value of hidden variables:')
        disp(num2str(mx))
        
        %%%%%%%%%%%%%%%%%%%%%
        
        % disp(locBel(end-YNoStates+1:end,1));
        str = sprintf('The max prob is = %d',Midx);
        if Midx == i
            counter_true = counter_true + 1;
        end
        i
        disp(str);
        disp('the Y belifs are : ');
        disp(YLocBel');
        % disp(str);
        fclose(fid);
    end
