d = dir('./brake_data/*.csv');
n = length(d);
for i = 1:n
    data = csvread(fullfile('./brake_data',d(i).name));
    v = data(:,2);
    v_out(i) = v(2)*3.6;
    time(i) = (length(find(v>=0))-4)/15; 
end

mdl = LinearModel.fit(v_out, time);
x = linspace(0,120,120);
y = 0.022045*x;
step = y/0.15;

subplot(2,1,1);
plot(v_out, time, 'ro');
hold on
plot(x,y,'b');
ylabel('Time(S)')
subplot(2,1,2)
plot(x,step,'b')
ylabel('Steps')
xlabel('Vel(km/h)')
sgtitle('Braking Time')