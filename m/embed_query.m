% import model
kill
cd('/home/kln/projects/human_futures/mdl')
wd = '/home/kln/projects/human_futures';
mdl = csvread('embed_mdl.csv');
vocab = csv2cell('embed_vocab.csv','fromfile');
kw = unique(csv2cell('kw_vocab.csv','fromfile'));

% build distance matrix for each term
D = pdist(mdl,'cosine');
Dm = squareform(D,'tomatrix');

%% ## query model for specific term

% n minimum distances
n = 10;
kw_cell = cell(n,length(kw)); % store results
for j = 1:length(kw)
query = kw(j);
q_idx = strmatch(query,vocab,'exact'); %#ok<MATCH3>
p = Dm(q_idx,:);

[x,i] = sort(p,'ascend');
idx = i(1+1:n+1);% +1 to avoid diagonal
%disp('----------')
%disp(query)
%disp('----------')
for ii = 1:length(idx)
    disp(vocab(idx(ii)))
    kw_cell(ii,j) = vocab(idx(ii));
end

end
% export results
kw_table = cell2table(kw_cell, 'VariableNames', kw);
cd ..
%writetable(kw_table,'results/kw_embed.csv','WriteVariableNames',true)
dd =  strcat(cd,'/data');
cd(dd)
% save('embed_kw_cell.mat','kw_cell','kw')


