function e = objFcn_PD(x0, data, tspan, plt)
    Si = x0(1);
    p2 = x0(2);
   
    set_param('iam_sim/BMM/Gain_Sip2', 'Gain', num2str(Si*p2))
    set_param('iam_sim/BMM/Gain_p2', 'Gain', num2str(p2))

    out = sim('iam_sim.slx');

    %gluc = interp1(out.G_est(:,1),out.G_est(:,2), tspan);
    gluc = out.G_est(:,2);
    data = interp1(tspan, data, out.G_est(:,1));
    ra_est = interp1(out.Ra_est(:,1),out.Ra_est(:,2), tspan);
    ra = interp1(out.Ra_est(:,1),out.Ra_est(:,3), tspan);

    e = sum((data - gluc).^2);% + sum((ra - ra_est).^2); 
    
    if plt==1    
        figure(10)
        plot(out.Ra_est(:,1), data, 'LineWidth', 2);hold on
        plot(out.Ra_est(:,1), gluc, '--', 'LineWidth', 2); hold off
        legend('Raw Data', 'Model');
        xlabel('time [min]'); ylabel('glycemia [mmol/L]');drawnow 
    end
