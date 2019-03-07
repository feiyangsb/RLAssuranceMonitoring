t = tcpip('0.0.0.0', 3389, 'NetworkRole', 'server', 'OutputBufferSize', 3000);
fopen(t);
data_send = [];
while(1)
    if (t.BytesAvailable~=0) % read data from client
        command = fread(t, t.BytesAvailable);
        command = convertCharsToStrings(char(command));
        if (command == "Sample")
            %starting sample a new trace
            [Dist, Vel, Acc, TTC_r] = Sample();
            data_send = [Dist' Vel' Acc' TTC_r];
            length(data_send)
            data_send = [length(data_send) data_send];
            fwrite(t, data_send, 'single');
        end
    end
end
fclose(t);