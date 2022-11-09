clear all; clc; close all

addpath('/project/3022039.01/linked_ICA/linkedICA_v2/tools/CCA_Iva')

LICApath = '/project/3022035.03/LEAP_long/data/flica_output';
outpath= '/project/3022035.03/LEAP_long/stats/CCA';

%% select model and read subject course
model = {'VBM_DWI_congrads','VBM_DWI'};
model_select = 1;

courses = '/subjectCoursesOut.txt';

subcourses = load(strcat(LICApath,'/',model{model_select},'/', courses));
% subcourses = -subcourses;

%exclude ICs
% excl_indx = [1,2,5,6,25,43,52,65]; %1,2,5 site related comps
%excl_indx = [6,25,43,52,65];
%subcourses(:,excl_indx) = [];
%the IC number would change, refer to corresponding list for the original
%index

% brain_cca = zscore(subcourses);
brain_cca = transpose(subcourses);

%% read and clean behavioural data

clin_set = {'ADOS', 'SRS_SSP_RBS_VABS', 'VABS', 'SRS_SSP_RBS', 'ADOS_VABS'};
clin_select = 5;
clini = load(strcat(outpath,'/CCA_',clin_set{clin_select},'.txt'));

%remove missing data
a = size(clini,2)-6;
beh_cca = clini;

for i = 1:a
    I = find(beh_cca(:,6+i) == 999);
    beh_cca(I,:) = [];
    brain_cca(I,:) = [];
end

%normalising age and IQ
beh_cca = [beh_cca(:,1:4),zscore(beh_cca(:,5:6)),beh_cca(:,7:end)];
% 1 subjectID;2 group;3 sex;4 site; 5 ageyrs;6 fsiq;

%round to integer of scales
% beh_cca = [beh_cca(:,1:6), round(beh_cca(:,7:end))];

%asd group
I = find(beh_cca(:,2) == 2);
beh_asd = beh_cca(I,:);
brain_asd = brain_cca(I,:);

%% prepare for CCA
asd = 0; % perform within asd group
if asd == 1
    X = zscore(beh_asd(:,7:end));
    Y = brain_asd; 
    confounds_brain = [beh_asd(:,[3 5 6]),dummyvar(beh_asd(:,4))];
%     confounds_brain = beh_asd(:,3:5);%remove site related comps    
    site = grp2idx(beh_asd(:,4));
else
    X = zscore(beh_cca(:,7:end));
    Y = zscore(brain_cca);
    confounds_brain = [beh_cca(:,[3 5 6]),dummyvar(beh_cca(:,4))];
%     confounds_brain = beh_cca(:,3:5);%remove site related comps 
    site = grp2idx(beh_cca(:,4));
end

%%check in the winkler's script, disable center, zscore by myself
%doesn't work, if center + zscore

%% run CCA
% [pfwer,r,A,B,U,V] = cca_site_perm(Y,X,10000,confounds_brain,[],[],true,site);
[pfwer,r,A,B,U,V] = cca_site_perm(Y,X,10000,confounds_brain,[],[],true,site); %disable withinsite perm

% %behavior loadings up to the 3d CV
% [loadings_beh(1,:), ploadings_beh(1,:)] = corr(V(:,1),X);
% [loadings_beh(2,:), ploadings_beh(2,:)] = corr(V(:,2),X);
% [loadings_beh(3,:), ploadings_beh(3,:)] = corr(V(:,3),X);
% 
% 
% %brain loadings up to the 3d CV
% [loadings_brain(1,:), ploadings_brain(1,:)] = corr(U(:,1),Y);
% [loadings_brain(2,:), ploadings_brain(2,:)] = corr(U(:,2),Y);
% [loadings_brain(3,:), ploadings_brain(3,:)] = corr(U(:,3),Y);



%%%HAUFE   modify

%hauffe %flip sign is coornidating with brain map
%brain
selected_filters = 1; 
hauffe_brain = cov(Y) * A(:,selected_filters) * (cov( (A(:,selected_filters)'*Y')')^-1);
% hauffe_brain = -hauffe_brain;

[brain_sort_cca indx_cca_brain] = sort(abs(hauffe_brain(:,1)),'descend');
indx_cca_brain(1:10,1)

%behavior
hauffe_beh = cov(X) * B(:,selected_filters) * (cov((B(:,selected_filters)'*X')')^-1);
% hauffe_beh = -hauffe_beh;

[beh_sort_cca indx_cca_beh] = sort(abs(hauffe_beh(:,1)),'descend');
indx_cca_beh(:,1)

r = r(:,selected_filters);

%plot of beh loadings
figure ;gcf;
% color = [uint8(147),uint8(147),uint8(145);uint8(166),uint8(166),uint8(168);uint8(175),uint8(176),uint8(178);uint8(191),uint8(191),uint8(191);uint8(224),uint8(229),uint8(223)];
% color = [uint8(130),uint8(57),uint8(53);uint8(137),uint8(190),uint8(178);uint8(222),uint8(156),uint8(83);uint8(201),uint8(186),uint8(131);uint8(222),uint8(211),uint8(140)];
% color = [0.21875,0.34375,0.34375;0.21875,0.34375,0.34375;0.479166666666667,0.562500000000000,0.562500000000000;0.739583333333333,0.781250000000000,0.781250000000000;0.739583333333333,0.781250000000000,0.781250000000000];
% color_yz = round(linspace(51,204,6));
% color = [uint8(255),uint8(color_yz(:,1)),uint8(color_yz(:,1));...
%          uint8(255),uint8(color_yz(:,2)),uint8(color_yz(:,2));...
%          uint8(255),uint8(color_yz(:,3)),uint8(color_yz(:,3));...
%          uint8(255),uint8(color_yz(:,4)),uint8(color_yz(:,4));...
%          uint8(255),uint8(color_yz(:,5)),uint8(color_yz(:,5))];
% color = [uint8(color_yz(:,1)),uint8(color_yz(:,1)),uint8(255);...
%          uint8(color_yz(:,2)),uint8(color_yz(:,2)),uint8(255);...
%          uint8(color_yz(:,3)),uint8(color_yz(:,3)),uint8(255);...
%          uint8(color_yz(:,4)),uint8(color_yz(:,4)),uint8(255);...
%          uint8(color_yz(:,5)),uint8(color_yz(:,5)),uint8(255)];
% color = [uint8(color_yz(:,1)),uint8(255),uint8(255);...
%          uint8(color_yz(:,2)),uint8(255),uint8(255);...
%          uint8(color_yz(:,3)),uint8(255),uint8(255);...
%          uint8(color_yz(:,4)),uint8(255),uint8(255);...
%          uint8(color_yz(:,5)),uint8(255),uint8(255)];
% color_1 = linspace(0.4,0.8,5)';
% color = [color_1,color_1,color_1];
% color = bone(5);
color = brewermap(30,'Blues');
color = flipud(color);
color = [color(10,:);color(15,:);color(20,:);color(25,:);color(30,:)];
[B_sort,I] = sort(abs(hauffe_beh),'descend');
xlim([0,size(X,2)+1]);
ylim([-1,1]);
hold on
for i = 1:size(X,2);
    color4(I(i,:),:) = color(i,:);
    gra = bar(I(i,:),hauffe_beh(I(i,:),:),'FaceColor',color4(I(i,:),:),'EdgeColor','k');
    hold on
    gra.BarWidth = 0.5;
end
grid on
set(gca,'Color');
set(gca,'XColor',[0 0 0],'YColor',[0 0 0]);
% view([-270,90]);


%plot of CCA

%coding the figure with scale scores
scale_select = 3;

% color = brewermap(size(X,1),'Greens');
aa = unique(X(:,scale_select));
color_1 = brewermap(size(aa,1),'Blues');
color_1 = flipud(color_1);
% color_indx = (218-191)/(size(X,1)-1);
% color = 191:color_indx:218;
color = zeros(size(X,1),3);
% for i = 1:13
for i = 1:size(aa,1)
    I = find(X(:,scale_select) == aa(i));
    color(I,:) = repmat(color_1(i,:),size(I,1),1);
end

% [sorta,Ia] = sort(X(:,scale_select));
% for i = 1:size(X,1)
%     a = Ia(i);
%     V_sort(i,:) = V(a,selected_filters);
%     U_sort(i,:) = U(a,selected_filters); 
% end
V_sort = V(:,selected_filters);
U_sort = U(:,selected_filters);



figure
xmin = -6;
xmax = 6;
ymin = -6;
ymax = 6;
sca_plot = scatter(U_sort,V_sort,100,color,'o','filled');
%title(['The ',num2str(selected_filters),' CCA mode scatter plots of subject courses variate versus ',clini_end{clini_selct},' variate'],'FontSize',10,'FontWeight','normal');
sca_plot.MarkerEdgeColor = 'k';
xlabel('CCA mode: subject courses');
ylabel(['CCA mode: ',clin_set{clin_select}]);
xlim([xmin,xmax]);
ylim([ymin,ymax]);
grid on
% set(gca,'Color','k')
% set(gca,'XColor',[1 1 1],'YColor',[1 1 1]);
