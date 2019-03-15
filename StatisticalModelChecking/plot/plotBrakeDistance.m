clear;
filename = "../brake_distance.csv";
data = csvread(filename);

Velocity = data(:,1)*3.6;
Brake_distance = data(:,2);

plot(Velocity, Brake_distance, 'r');
xlim([0,110])
ylim([0,50])
xlabel('Speed(km/h)')
ylabel('Braking Dist(m)')
sgtitle('Braking Distance')