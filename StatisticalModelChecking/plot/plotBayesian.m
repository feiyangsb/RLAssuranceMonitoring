clear;


p = load('p.mat');
p = p.p_list;
c = load('gamma.mat');
c = c.gamma_list;


t = linspace(0,length(p)-1,length(p));



subplot(2,1,1);
plot(t, p, 'r');
xlim([0 360]);
ylim([0 1]);
ylabel('Estimation $$\hat{p}$$','Interpreter','Latex')

subplot(2,1,2);
plot(t, c, 'r');
xlim([0 360]);
ylim([0 1]);
ylabel('Confidence $$c$$','Interpreter','Latex');
xlabel('# of Samples');

% ylabel('TTC(s)');
sgtitle('Bayesian Interval Estimation (SIMULINK)')