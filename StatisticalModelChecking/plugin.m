
delta = 0.01; %half interval size
c = 0.99; %interval coefficient
alpha = 1;
beta = 1;
n = 0;
x = 0;
p_list = [];
gamma_list = [];

sampleCommand = "Sample";
t = tcpip('localhost', 3389, 'NetworkRole', 'client', 'InputBufferSize', 3000);
fopen(t)

while(1)
    %Sampling
    fwrite(t, sampleCommand);
    disp("Sampling new trace...");
    %waiting for result
    while(1)
        if (t.BytesAvailable ~= 0)
            number_data = fread(t,1,'single');
            while (t.BytesAvailable ~= number_data*4)
                t.BytesAvailable;
            end
            result = fread(t, t.BytesAvailable/4, 'single');
            length(result)
            distance = result(1:length(result)/4);
            velocity = result(length(result)/4+1:length(result)/4 * 2);
            acceleration = result(length(result)/4*2+1:length(result)/4 * 3);
            ttc_r = result(length(result)/4*3+1:length(result)/4 * 4);
            break;
        end
    end
    if (all(ttc_r < 2.0)) %satisfying the specification
        x=x+1;
    end
    n=n+1;
    
    p = (x+alpha)/(n+alpha+beta);
    t0 = max(0, p-delta);
    t1 = min(1, p+delta);
    p_list(end+1) = p;
    pd = makedist('Beta','a',alpha+x,'b',beta+n-x);
    gamma = cdf(pd,t1) - cdf(pd,t0);
    gamma_list(end+1) = gamma;
    INFO = ['# of Episode: ', num2str(n), '; # of Satisfying: ', num2str(x), '; Probability: ', num2str(p), '; Confidence(%): ', num2str(gamma)];
    disp(INFO)
    if (gamma >= c)
        break;
    end
end
fclose(t)