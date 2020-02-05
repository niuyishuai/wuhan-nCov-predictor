clc;
clear;
close all;
%% ����
% �Խ�jsonAPI��ȡ����
data = importjsonAPI('https://view.inews.qq.com/g2/getOnsInfo?name=disease_h5');
data=jsondecode(data.data);
daycounts=data.chinaDayAddList;

%% ��������
n_days=size(daycounts,1);
date_lst=cell(n_days,1);
D_lst=zeros(n_days,4);
for i=1:n_days
    date_lst{i} = daycounts(i).date;
    D_lst(i,1)=str2num(daycounts(i).confirm);
    D_lst(i,2)=str2num(daycounts(i).suspect);
    D_lst(i,3)=str2num(daycounts(i).dead);
    D_lst(i,4)=str2num(daycounts(i).heal);
end

% ��ȡȷ������
x_data=1:n_days;
confirm_data=D_lst(:,1)';
suspect_data=D_lst(:,2)';
dead_data=D_lst(:,3)';
heal_data=D_lst(:,4)';

% ��ͼ
figure('Name','�人���͹�״���������仯����');
set(gcf,'position',[200 200 1000 600]);
subplot(2,1,1);
hold on;
plot(x_data,D_lst(:,1),'r-o','LineWidth',1.5);
plot(x_data,D_lst(:,2),'b-o','LineWidth',1.5);
set(gca,'XTick',1:1:n_days);
xlim([1 n_days]);
xlabel('ʱ��');
ylabel('����');
xticklabels(date_lst);
legend({'ȷ��','����'},'Location','northwest');
title('ȷ�� - ����');
hold off;

subplot(2,1,2);
hold on;
plot(x_data,D_lst(:,3),'k-o','LineWidth',1.5);
plot(x_data,D_lst(:,4),'g-o','LineWidth',1.5);
set(gca,'XTick',1:1:n_days);
xlim([1 n_days]);
xlabel('ʱ��');
ylabel('����');
xticklabels(date_lst);
legend({'����','����'},'Location','northwest');
title('���� - ����');
hold off;


%% Ԥ��
%% ��˹���Ԥ��
fprintf('--------------------------------\n');
fprintf('��˹���Ԥ������\n');
[gauss_confirm_predictor,~]=createFit(date_lst,confirm_data,'gauss','����ȷ������Ԥ�� (��˹���)');
fprintf('Ԥ������ȷ������:%d\n',round(gauss_confirm_predictor(n_days+1)));

[gauss_suspect_predictor,~]=createFit(date_lst,suspect_data,'gauss','������������Ԥ�� (��˹���)');
fprintf('Ԥ��������������:%d\n',round(gauss_suspect_predictor(n_days+1)));

[gauss_dead_predictor,~]=createFit(date_lst,dead_data,'gauss','������������Ԥ�� (��˹���)');
fprintf('Ԥ��������������:%d\n',round(gauss_dead_predictor(n_days+1)));

%% ָ�����Ԥ��
fprintf('--------------------------------\n');
fprintf('ָ�����Ԥ������\n');
[exp_confirm_predictor,~]=createFit(date_lst,confirm_data,'exp','����ȷ������Ԥ�� (ָ�����)');
fprintf('Ԥ������ȷ������:%d\n',round(exp_confirm_predictor(n_days+1)));

[exp_suspect_predictor,~]=createFit(date_lst,suspect_data,'exp','������������Ԥ�� (ָ�����)');
fprintf('Ԥ��������������:%d\n',round(exp_suspect_predictor(n_days+1)));

[exp_dead_predictor,~]=createFit(date_lst,dead_data,'exp','������������Ԥ�� (ָ�����)');
fprintf('Ԥ��������������:%d\n',round(exp_dead_predictor(n_days+1)));

%% ����ʽ���Ԥ��
fprintf('--------------------------------\n');
fprintf('����ʽ���Ԥ������\n');
[poly_confirm_predictor,~]=createFit(date_lst,confirm_data,'poly','ȷ������Ԥ�� (��ζ���ʽ���)');
fprintf('Ԥ������ȷ������:%d\n',round(poly_confirm_predictor(n_days+1)));

[poly_suspect_predictor,~]=createFit(date_lst,suspect_data,'poly','��������Ԥ�� (��ζ���ʽ���)');
fprintf('Ԥ��������������:%d\n',round(poly_suspect_predictor(n_days+1)));

[poly_dead_predictor,~]=createFit(date_lst,dead_data,'poly','��������Ԥ�� (��ζ���ʽ���)');
fprintf('Ԥ��������������:%d\n',round(poly_dead_predictor(n_days+1)));

%% Smooth Splitting���Ԥ��
fprintf('--------------------------------\n');
fprintf('Smooth Splitting���Ԥ������\n');
[smoothsplit_confirm_predictor,~]=createFit(date_lst,confirm_data,'smoothsplit','����ȷ������Ԥ�� (smoothsplit)');
fprintf('Ԥ������ȷ������:%d\n',round(smoothsplit_confirm_predictor(n_days+1)));

[smoothsplit_suspect_predictor,~]=createFit(date_lst,suspect_data,'smoothsplit','������������Ԥ�� (smoothsplit)');
fprintf('Ԥ��������������:%d\n',round(smoothsplit_suspect_predictor(n_days+1)));

[smoothsplit_dead_predictor,~]=createFit(date_lst,dead_data,'smoothsplit','������������Ԥ�� (smoothsplit)');
fprintf('Ԥ��������������:%d\n',round(smoothsplit_dead_predictor(n_days+1)));

%% ������Ԥ��
fprintf('--------------------------------\n');
fprintf('������Ԥ������\n');
[NN_confirm_predictor,~]=createNNFit(x_data,confirm_data,5,5);
fprintf('Ԥ������ȷ������:%d\n',round(NN_confirm_predictor(n_days+1)));

[NN_suspect_predictor,~]=createNNFit(x_data,suspect_data,5,5);
fprintf('Ԥ��������������:%d\n',round(NN_suspect_predictor(n_days+1)));

[NN_dead_predictor,~]=createNNFit(x_data,dead_data,5,5);
fprintf('Ԥ��������������:%d\n',round(NN_dead_predictor(n_days+1)));

%% ����Ԥ�����б�
lst_confirm_predictors={gauss_confirm_predictor,poly_confirm_predictor,NN_confirm_predictor,smoothsplit_confirm_predictor};
lst_suspect_predictors={gauss_suspect_predictor,poly_suspect_predictor,NN_suspect_predictor,smoothsplit_suspect_predictor};
lst_dead_predictors={gauss_dead_predictor,poly_dead_predictor,NN_dead_predictor,smoothsplit_dead_predictor};

%% ���ַ�ʽƽ��Ԥ����
fprintf('--------------------------------\n');
fprintf('ƽ��Ԥ������\n');
fprintf('Ԥ������ȷ������:%d\n',meanprediction(lst_confirm_predictors,n_days+1));
fprintf('Ԥ��������������:%d\n',meanprediction(lst_suspect_predictors,n_days+1));
fprintf('Ԥ��������������:%d\n',meanprediction(lst_dead_predictors,n_days+1));

%% ����Ԥ��(һ��)
% ȷ��
nterms=n_days+7; % ������
curterm=n_days; %��ǰ��
predictornames = {'��˹���','����ʽ���','������','SmoothSplitting'}; %Ԥ��������
label='����ȷ���Ⱦһ������Ԥ��'; % ��ǩ
longtermpredictions(nterms,curterm,lst_confirm_predictors,predictornames,label);

% ����
predictornames = {'��˹���','����ʽ���','������','SmoothSplitting'}; %Ԥ��������
label='�������Ƹ�Ⱦһ������Ԥ��'; % ��ǩ
longtermpredictions(nterms,curterm,lst_suspect_predictors,predictornames,label);

% ����
predictornames = {'��˹���','����ʽ���','������','SmoothSplitting'}; %Ԥ��������
label='��������һ������Ԥ��'; % ��ǩ
longtermpredictions(nterms,curterm,lst_dead_predictors,predictornames,label);