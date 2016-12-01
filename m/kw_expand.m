kill
dd = '/home/kln/projects/human_futures/data';
cd(dd)
load('embed_kw_cell.mat');
cd ..
% import and clean original kw matrix
kw_org = csv2cell('keywords.csv','fromfile');
for i = 1:size(kw_org,2)
    kw_org(:,i) = regexprep(regexprep(lower(kw_org(:,i)),' ',''),'_.*','');
end
%% reformat embedding cell
[m,n] = size(kw_cell);
[kw_embed, tmp] = deal({});
for i = 1:n
   %i = 22 
   ii = strmatch(kw(i),kw_org(:,3),'exact');
   %disp('---')
   %disp(i)
   %disp(length(ii))
   
   kw_org(ii,:); 
   kw_embed = [kw_embed;repmat(kw_org(ii,:),11,1)];
   tmp = [tmp; repmat([kw(i); kw_cell(1:end,i)],length(ii),1)];
   %ii = strmatch(kw(i),kw_org(:,3));
   %kw_org(ii,:)
end
%%
colnames = {'origin','class','seeded_kw','seed','embed_kw'};
kw_embed = [kw_embed tmp];
cd(dd)
cell2csv('kw_embed_list.csv', kw_embed);