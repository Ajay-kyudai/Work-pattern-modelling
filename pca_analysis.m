clear all 

%% --------------- Importing the dataset -------------------------
% ---------------------------- Code ---------------------------
data = readtable('C:\Users\rte26\Desktop\machine5\pca_analysis.csv');
Var4=data(:,2);
data=data(:,4:10);
%________________________________________________________________
%________________________________________________________________

%%---------------Data Preprocessing -----------------------------

%% outlier detection
outlier=isoutlier(data,'mean');
data=filloutliers(data,'clip','mean');
data = table2array(data);
Var4=table2array(Var4);
% Applying Principal component analysis
[coeff,score,latent,tsquared,explained,mu] = pca(data);
Var1=score(:,1);
Var2 = score(:,2);
Var3 = score(:,3);
data_new = [Var1, Var2,Var3];
% Applying WCSS method to determine minimum number of clusters required
WCSS = [];
for k = 1:10
    sumd = 0;
    [idx,C,sumd] = kmeans(data_new,k);
    WCSS(k) = sum(sumd);
end
figure
plot(1:10, WCSS); 
opts = statset('Display','final');
% Applying k-means clustering
[idx,C] = kmeans(data_new,6,...
    'Replicates',5,'Options',opts);
UniqueCluster=unique(idx);
colors = brewermap(length(UniqueCluster),'Set1');
x=data_new(:,1);
y=data_new(:,2);
z=data_new(:,3);
data1=[Var1,Var2,Var3,Var4];
uniqueWorker=unique(Var4);
colors1=brewermap(length(uniqueWorker),'Set1');
%create animation
% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Draw scatter plot
% figure
view(3)
grid on
hold on

% Plot each group individually: 
for k = 1:length(UniqueCluster)
      % Get indices of this particular unique group:
      ind = idx==UniqueCluster(k); 

      % Plot only this group: 
      plot3(x(ind),y(ind),z(ind),'.','color',colors(k,:),'markersize',20); 

end
for i = 1:6
    plot3(C(i,1),C(i,2),C(i,3),'kx','MarkerSize',15,'LineWidth',3);
    
end
% for i=1:755
%     text(data_new(i,1),data_new(i,2),data_new(i,3),num2str(Var4(i)),'FontSize',7)
%     hold on
% end
grid(axes1,'on');
axis(axes1,'tight');
% Set the remaining axes properties
set(axes1,'DataAspectRatio',[1 1 1]); 
set(gca,'nextplot','replacechildren'); 
v = VideoWriter('test3.avi');
open(v);
for ii = 0:2.5:90
   view(axes1,[-37.5+ii 30]);    
    pause(0.2);
    frame = getframe(gcf);
   writeVideo(v,frame);
end
close(v);

% for k = 1:length(uniqueWorker)
%       % Get indices of this particular unique group:
%       ind = Var4==uniqueWorker(k); 
% 
%       % Plot only this group: 
%       plot3(x(ind),y(ind),z(ind),'.','color',colors1(k,:),'markersize',20); 
% 
% end
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Cluster 6')
xlabel('Principal axis 1');
ylabel('principal axis 2');
zlabel('principal axis 3');
figure
heatmap(coeff)


