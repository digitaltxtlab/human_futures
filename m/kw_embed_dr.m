% # dimensionality reduction of embeddings for keywords

% import model
kill
cd('/home/kln/projects/human_futures/mdl')
wd = '/home/kln/projects/human_futures';
dd = '/home/kln/projects/human_futures/data';
mdl = csvread('embed_mdl.csv');
vocab = csv2cell('embed_vocab.csv','fromfile');
kw = unique(csv2cell('kw_vocab.csv','fromfile'));

% import all keywords with call informationdd = '/home/kln/projects/human_futures/data';
cd(dd)
kw_embed = csv2cell('kw_embed_list.csv','fromfile');
cd(wd)
% build matrix and distance matrix for kw embeddings only
kw_mat = zeros(size(kw_embed,1),size(mdl,2));
for i = 1:size(kw_embed,1)
    idx = strmatch(kw_embed(i,end),vocab,'exact');
    kw_mat(i,:) = mdl(idx,:);
end
kw_dist_mat = squareform(pdist(kw_mat,'cosine'),'tomatrix');

%% ##DR
rng(1234)
no_dims = round(intrinsic_dim(kw_mat, 'MLE'));
disp(['MLE estimate of intrinsic dimensionality: ' num2str(no_dims)]);
% pca
[mappedX, mapping] = compute_mapping(kw_mat, 'PCA', no_dims);
figure(1), scatter(mappedX(:,1), mappedX(:,2), 5); title('Result of PCA');
hold on
text(mappedX(:,1), mappedX(:,2),kw_embed(:,2))
% t-SNE
[mappedX, mapping] = compute_mapping(kw_mat, 'tSNE');
[u,~,c] = unique(kw_embed(:,2));
figure(3), 
subplot(2,1,1),
scatter(mappedX(:,1), mappedX(:,2), 50,c,'filled');

%hold on; text(mappedX(:,1), mappedX(:,2),kw_embed(:,2))
subplot(2,1,2),
gscatter(mappedX(:,1),mappedX(:,2),kw_embed(:,1))
% ignore wordnet synonyms

%
i = strcmp(kw_embed(:,1),'main');
f = figure(1);
h = gscatter(mappedX(i,1),mappedX(i,2),kw_embed(i,2));
for j = 1:length(h); h(j).Marker = 'o'; h(j).MarkerFaceColor = h(j).Color; end
axis off
figSize(f,15,30)
plotCorrect
legend boxoff


    
	







