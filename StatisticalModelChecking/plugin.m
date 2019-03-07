
delta = 0.01; %half interval size
c = 0.99; %interval coefficient
alpha = 100;
beta = 1;
n = 0;
x = 0;

sampleCommand = "Sample";
t = tcpip('localhost', 3389, 'NetworkRole', 'client');
fopen(t)

while(1)
    %Sampling
    fwrite(t, sampleCommand);
    disp("Sampling new trace...");
    %waiting for result
    while(1)
        if (t.BytesAvailable ~= 0)
            result = fread(t, t.BytesAvailable);
            result = convertCharsToStrings(char(result));
            break;
        end
    end
    if (result == "Yes") %satisfying the specification
        x=x+1;
    end
    n=n+1;
    
    p = (x+alpha)/(n+alpha+beta);
    t0 = max(0, p-delta);
    t1 = min(1, p+delta);
    
    pd = makedist('Beta','a',alpha+x,'b',beta+n-x);
    gamma = cdf(pd,t1) - cdf(pd,t0)
    if (gamma >= c)
        break;
    end
end
fclose(t)