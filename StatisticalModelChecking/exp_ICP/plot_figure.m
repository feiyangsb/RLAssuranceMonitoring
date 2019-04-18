clear;
filename = 'icp.csv';
data = csvread(filename); 

a = data(:,1);
a_90 = data(:,2);
a_90_bot = a - a_90;
a_90_bot(a_90_bot<0.0) = 0.0;
a_90_upper = a + a_90;
a_90_upper(a_90_bot>1.0) = 1.0;

a_95 = data(:,3);
a_95_bot = a - a_95;
a_95_bot(a_95_bot<0.0) = 0.0;
a_95_upper = a + a_95;
a_95_upper(a_95_bot>1.0) = 1.0;

a_99 = data(:,4);
a_99_bot = a - a_99;
a_99_bot(a_99_bot<0.0) = 0.0;
a_99_upper = a + a_99;
a_99_upper(a_99_bot>1.0) = 1.0;

d = data(:,5);
v = data(:,6);


t = linspace(0,159,160)/20;
fig1 = figure(1);
set(fig1, 'defaultAxesColorOrder', [[1,0,0]; [0,0,1]]);
yyaxis left
plot(t, d);
ylim([0 100]);
ylabel('Dist(m)')
hold on
yyaxis right
plot(t, v);
hold off
ylim([0 40]);
ylabel('Vel(m/s)')
xlabel('Time(s)')
legend("Distance", "Velocity")

fig2 = figure(2);


p0 = plot(t, a, 'k');
hold on
p1 = plot(t, a_90_bot,'b--');
p2 = plot(t, a_90_upper,'b--');
p3 = plot(t, a_95_bot,'r--');
p4 = plot(t, a_95_upper,'r--');
p5 = plot(t, a_99_bot,'m--');
p6 = plot(t, a_99_upper,'m--');
legend([p0,p2,p4,p6], 'Prediction', '90% Confidence Interval', '90% Confidence Interval', '90% Confidence Interval')
ylim([0 1.0]);
ylabel('Brake Signal')
xlabel('Time(s)')