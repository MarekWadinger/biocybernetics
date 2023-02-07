function e = objectiveFcn(x0, data, tspan, plt)
    p2 = x0(1);
    Si = x0(2);
    Sg = x0(3);
    G0 = x0(4);
    X0 = x0(5);
    Ib = x0(6);
    Gb = x0(7);
    
    set_param('bmm_sim/BMM/Gain_Sg', 'Gain', num2str(Sg));
    set_param('bmm_sim/BMM/Gain_Sip2', 'Gain', num2str(Si*p2))
    set_param('bmm_sim/BMM/Gain_p2', 'Gain', num2str(p2))
    set_param('bmm_sim/BMM/Integrator_G', 'InitialCondition', num2str(G0))
    set_param('bmm_sim/BMM/Integrator_X', 'InitialCondition', num2str(X0))
    set_param('bmm_sim/Ib', 'Value', num2str(Ib))
    set_param('bmm_sim/Gb', 'Value', num2str(Gb))

    out = sim('bmm_sim.slx');

    gluc = interp1(out.OutData(:,1),out.OutData(:,2), tspan);

    e = sum((data - gluc).^2); 
    if plt==1    
        figure(10)
        plot(tspan, [data, gluc], 'o-', 'LineWidth', 2); 
        legend('Raw Data', 'Model');
        xlabel('time [min]'); ylabel('glycemia [mmol/L]');drawnow 
    end
end