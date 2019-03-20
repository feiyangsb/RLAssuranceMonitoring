%%Sample the initial distance and velocity
d0 = 110;
state_space_handle = getSimulinkBlockHandle('braking_distance/Discrete State-Space',true);
for i = 10:110  
    v0 = i/3.6;
    a0 = 0;
    S0 = [d0, v0, a0];
    set_param(state_space_handle,'InitialCondition',mat2str(S0));
    sim('braking_distance');
    Dist = states.data(:,1);
    braking_dist = 110 - Dist(end)
end