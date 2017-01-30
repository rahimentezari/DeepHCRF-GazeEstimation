% CREATE_CBP_FILE
function file_name = create_cbp_file(Sample, sample_index, num_label, num_hidden, path) %num of variables is num of frames+1

num_unary = 0;
num_pairwise = 0;
num_triple = 0;
num_label_states = num_label;
num_hidden_states = num_hidden;

for j=1:size(Sample.Regions,2)
    switch size(Sample.Regions{1,j}.bel,1)
        case num_hidden_states
            num_unary = num_unary+1;
        case num_hidden_states*num_label_states
            num_pairwise = num_pairwise+1;
        case num_hidden_states*num_hidden_states*num_label_states
            num_triple = num_triple+1;
    end
end

disp(['number of unary, pairwise and triple potentials for sample' num2str(sample_index) ' is:'])
% if num_unary is n(containing hidden and label nodes), num_pairwise and
% num_triple should be n and n-1
% accordingly
disp(num_unary)
disp(num_pairwise)
disp(num_triple)

num_nodes = num_unary+1;%numel(var_cardinalities);% the arrays starts with hidden vars, the last element is y
% hidden_states=5;
% label_states = 2;
var_cardinalities = [num_hidden_states*ones(num_nodes-1,1); num_label_states];
accuracy = 8;
machineIDs = ones(1,num_nodes);
%create pairwise clique indices %here the IDs start from num_nodes, variable IDs start from
%zero
pw_cliques = zeros(num_pairwise, 4);
for i=1:num_pairwise %for each clique
    pw_cliques(i,:) = [2, i+num_nodes-2, i-1, num_nodes-1];% here IDs end with 2*num_nodes-3 = num_nodes-1 + num_unary -1=>indexing starts from 0,
end

triple_cliques = zeros(num_triple, 5);% the IDs start from 2*num_nodes-2
for i=1:num_triple %for each clique, num_nodes-1 triple cliques we have
    triple_cliques(i,:) = [3, i+2*num_nodes-3, i-1, i, num_nodes-1];
end

file_name = [path '/interaction' num2str(sample_index) '.cbp'];
fid = fopen(file_name,'wb');
fwrite(fid, accuracy, 'uint64');                                            %double or single precision accuracy; 
fwrite(fid, num_nodes, 'uint64');                                           %number of variables/nodes
fwrite(fid, var_cardinalities, 'uint64');                            %cardinality of variables
fwrite(fid, machineIDs(:), 'uint64'); %?                                      %machineID of variables
if(accuracy==4)                                                             %c_i
    fwrite(fid, ones(num_nodes,1), 'float32');
else
    fwrite(fid, ones(num_nodes,1), 'double');
end
num_cliques = num_pairwise + num_triple; %triple, pairwise cliques 
num_potentials = num_cliques + num_unary; % number of potentials of any kind ( unary, pairwise and triple)
fwrite(fid, num_potentials,'uint64');                               %number of potentials, i.e. factors of any kind
fwrite(fid,[ones(1,num_nodes-1);0:num_nodes-2;0:num_nodes-2],'uint64');       %node potential specification {Cliquesize=1; PotentialIX; VariableID} % no unary potential for label variable
fwrite(fid,pw_cliques.','uint64');                                             %clique potentials specification {Cliquesize; PotentialIX; VariableIDs}
fwrite(fid,triple_cliques.','uint64');


if(accuracy==4)                                                             %c_alpha for all clique potentials, i.e. those potentials with CliqueSize > 1
    fwrite(fid,ones(1,num_cliques),'float32');
else
    fwrite(fid,ones(1,num_cliques),'double');
end

for k=1:size(Sample.Regions,2)                                              %potentials, i.e. {PotentialIX, PotentialValues (note that format is different from UAI (Matlab format)!!!)...}
    fwrite(fid,k-1,'uint64');           %potentialIX
    if(accuracy==4)
        fwrite(fid,Sample.Regions{1,k}.bel,'float32');  %PotentialValues
    else
        fwrite(fid,Sample.Regions{1,k}.bel,'double');   %PotentialValues
    end
end

fclose(fid);