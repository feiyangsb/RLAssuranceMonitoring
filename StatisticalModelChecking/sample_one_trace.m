clear t
clear result

sampleCommand = "Sample";
t = tcpip('localhost', 3389, 'NetworkRole', 'client', 'InputBufferSize', 3000);
fopen(t)

fwrite(t, sampleCommand);
while(1)
    if (t.BytesAvailable ~= 0)
        number_data = fread(t,1,'single');
        while (t.BytesAvailable ~= number_data*4)
            t.BytesAvailable;
        end
        result = fread(t, t.BytesAvailable/4, 'single');
        distance = result(1:length(result)/4);
        velocity = result(length(result)/4+1:length(result)/4 * 2);
        acceleration = result(length(result)/4*2+1:length(result)/4 * 3);
        ttc_r = result(length(result)/4*3+1:length(result)/4 * 4);
        break;
    end
end

for i=1:length(distance)
    %TTC(i) = calculateTTC(Dist(i), Vel(i), Acc(i));
    TTC_r(i) = calculateTTC_r(distance(i), velocity(i), acceleration(i));
end
fclose(t)
