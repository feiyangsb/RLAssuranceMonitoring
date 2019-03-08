clear;


d = load('distance_simulink.mat');
d = d.distance;
v = load('velocity_simulink.mat');
v = v.velocity*3.6;
a = load('acceleration_simulink.mat');
a = a.acceleration;
ttc_inverse = load('ttc_inverse_simulink.mat');
ttc_inverse = ttc_inverse.ttc_r;

t = linspace(0,length(d)-1,length(d))/15;



subplot(4,1,2);
plot(t, v, 'r');
ylim([0 110]);
ylabel('Vel(km/h)')

subplot(4,1,1);
plot(t, d, 'r');
ylim([0 100]);
ylabel('Dist(m)');

subplot(4,1,3);
plot(t, a, 'r');
ylim([-15 5]);
ylabel('Acc(m/s^{2})');

subplot(4,1,4);
plot(t, ttc_inverse, 'r');
ylim([0 1]);
ylabel('TTC^{-1}(s^{-1})');
xlabel('Time(s)');

% ylabel('TTC(s)');
sgtitle('RL Braking System (SIMULINK)')