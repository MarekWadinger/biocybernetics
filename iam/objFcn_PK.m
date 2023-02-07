function e = objFcn_PK(x0, data, tspan, vb, plt)
    Vin = 100;          % [mL/kg]
    gamma = 5*10e-4;    % []

    Ti = x0(1);         % [min]
    ki = x0(2);         % [1/min]
    Vi = x0(3);         % [mL/kg]
    
    S10 = Ti*vb;                % [µIU/kg]
    S20 = S10;                  % [µIU/kg] 
    I0 = 1/(ki*Vi*Ti)*S20;      % [µIU/mL]

    set_param('iam_sim/IAM/Gain_Ti', 'Gain', num2str(1/Ti));
    set_param('iam_sim/IAM/Gain1_Ti', 'Gain', num2str(1/Ti));
    set_param('iam_sim/IAM/Gain_ki', 'Gain', num2str(ki));
    set_param('iam_sim/IAM/Gain_Vi', 'Gain', num2str(1/Vi));
    set_param('iam_sim/IAM/Integrator_S1', ...
          'InitialCondition', num2str(S10));
    set_param('iam_sim/IAM/Integrator_S2', ...
          'InitialCondition', num2str(S20));
    set_param('iam_sim/IAM/Integrator_I', ...
          'InitialCondition', num2str(I0));

    out = sim('iam_sim.slx');

    i_est = interp1(out.I_est(:,1), out.I_est(:,2), tspan);
    %i_est = out.I_est(:,2);
    %data = interp1(tspan, data, out.I_est(:,1));

    e = sum((data - i_est).^2) + gamma*(Vin-Vi)^2; 

    if plt==1    
        figure(10)
        %plot(out.I_est(:,1), [data, i_est], 'o-', 'LineWidth', 2); 
        plot(tspan, [data, i_est], 'o-', 'LineWidth', 2); 
        legend('Raw Data', 'Model');
        xlabel('time [min]'); ylabel('insulin [mmol/L]');drawnow 
        figure(11)
        stem(tspan, i_est - data, 'o-', 'LineWidth', 2); 
        xlabel('time [min]'); ylabel('error');drawnow 
    end
