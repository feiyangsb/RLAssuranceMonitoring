function [Dist, Vel, Acc, TTC_r] = Sample()
    dt = 1/15;
    clear d0
    clear v0
    clear S0
    clear Dist
    clear Vel
    clear Acc
    clear TTC_r
    clear TTC
    clear collision
    clear x

    %%Sample the initial distance and velocity
    d0 = normrnd(100, 5);
    v0 = (80+ 30*rand)/3.6;
    S0 = [d0, v0];

    %%Create the state space for braking system
    state_space_handle = getSimulinkBlockHandle('RL_CARLA_BRAKE_SYSTEM/Discrete State-Space',true);
    set_param(state_space_handle,'InitialCondition',mat2str(S0));
    sim('RL_CARLA_BRAKE_SYSTEM');

    Dist = States.data(:,1);
    Vel = States.data(:,2);
    for i=1:length(Vel)-1
        Acc(i) = (Vel(i+1) - Vel(i))/dt; 
    end
    Acc = Acc.';
    Dist = Dist(2:end-1);
    Vel = Vel(2:end-1);
    Acc = Acc(1:end-1);

    if (all(collision.data==0))
        for i=1:length(Acc)
            TTC(i) = calculateTTC(Dist(i), Vel(i), Acc(i));
            TTC_r(i) = calculateTTC_r(Dist(i), Vel(i), Acc(i));
        end
        if (all(TTC_r < 2.0))
            x = 1;
        else
            x = 0;
        end
    else
        x = 0;
    end
end