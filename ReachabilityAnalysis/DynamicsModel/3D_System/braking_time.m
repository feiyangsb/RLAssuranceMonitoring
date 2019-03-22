d = dir('./brake_data/*.csv');
n = length(d);
for i = 1:n
    data = csvread(fullfile('./brake_data',d(i).name));
    v = data(:,2);
    v_out(i) = v(2)*3.6;
    time(i) = (length(find(v>=0))-4)/15; 
end
plot(v_out, time, 'ro');
mdl = LinearModel.fit(v_out, time);
hold on
x = linspace(0,120,120);
y = 0.022045*x;
plot(x,y,'b');
xlabel('Vel(km/h)')
ylabel('Time(S)')
sgtitle('Braking Time')