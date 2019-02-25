clear;

%filename1 = 'RL.csv';
filename2 = './data/1.csv';
data = load('simulink.mat');
data1 = csvread(filename2,0,0,[0,0,120,3]); 

v1 = data.ans.Data(:,2)*3.6;
v2 = data1(:,1) * 3.6;

d1 = data.ans.Data(:,1);
d2 = data1(:,2);

a1 = data.ans.Data(:,3);
a2 = data1(:,3);


% a = data(:,3);
% ttc = data(:, end);
t = linspace(0,120,121)/15;
% 
% for i = 1:length(ttc)
%     if ttc(i) == 1000
%         ttc(i) = -5;
%     end
% end

subplot(3,1,2);
plot(t, v1, 'r');
hold on
plot(t, v2, 'b');
hold off
ylim([0 110]);
ylabel('Vel(km/h)')
legend('NN', 'True')

subplot(3,1,1);
plot(t, d1, 'r');
hold on
plot(t, d2, 'b');
hold off
ylim([0 100]);
ylabel('Dist(m)');
legend('NN', 'True')

subplot(3,1,3);
plot(t, a1, 'r');
hold on
plot(t, a2, 'b');
hold off
ylim([-15 5]);
ylabel('Acc(m)');
legend('NN', 'True')


% ylabel('TTC(s)');
sgtitle('CARLA Dynamics Model')