% ���������������������и��Ľű����
% �����Ȼ�����Ҫ���и������
close all;
load('exp_2d_cut_by_lines.mat');
narr=[8 10 12];
for k=1:length(narr)
    n=narr(k);
figure(k);hold on; title(strcat('n=',num2str(n)));
for i=1:size(lines1,1)
   X=[vert_2d(lines1(i,1),1) vert_2d(lines1(i,2),1)];
   Y=[vert_2d(lines1(i,1),2) vert_2d(lines1(i,2),2)];
   plot(X,Y,'b');
end

% �����������
% ������һ���Է�͹����������

% �������������Ȳ���

% �����ܳ���
v=vert_2d;    % �������ǲ��Ե�mat�����
lines=lines1;
lvec_arr=vert_2d(lines(:,2),:)-vert_2d(lines(:,1),:);
len_of_contour = sum(sqrt(sum(lvec_arr.^2,2)));   % �����ܳ��ȣ��Ժ�����


[v_phi,v1c]=progress_v2_circle_mesh_cut(v,lines,n);

for i=1:n
   X=[v_phi(i,1)  v_phi(mod(i,n)+1,1)];
   Y=[v_phi(i,2)  v_phi(mod(i,n)+1,2)]; % �����mod ��Ϊ����β����
   plot(X,Y,'r');
end
end