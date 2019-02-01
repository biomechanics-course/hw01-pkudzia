clear; close all;
%% 
x0 = [0.3; -0.4] ; % [theta(0); thetadot(0)]

% Returns xe final state, te end time (detected as event), and
% arrays xs and ts containing state and times over multiple time steps.
 parms = struct('alpha', 0.3, 'rgyr', 0, 'gamma', 0.04, 'tmax', 5);
 
[xe,te,xs,ts,energies] =rimlesswheelstance(x0, parms);

 figure(1);
 hold on;
 subplot(1,4,1)
 plot(ts,xs(:,1));
 xlabel('time(s)')
 ylabel('Angle(\theta)')
 title('Angle(\theta)')

 subplot(1,4,2)
 hold on;
 plot(ts, xs(:,2));
 xlabel('time(s)')
 ylabel('Angle(\theta Dot)')
  title('Angle(\theta dot)')
 
  subplot(1,4,3)
 hold on;
 plot(ts,energies.Total);
 plot(ts,energies.PE);
 plot(ts,energies.KE);
 xlabel('time(s)')
 ylabel('Energy')
 legend('Total','PE','KE')
 title('Energy')

subplot(1,4,4)
 hold on;
 plot(xs(:,1), xs(:,2),'-r','LineWidth',4)
 dx = diff(xs(:,1));
dy = diff(xs(:,2));
 quiver(xs(1:end-1,1),xs(1:end-1,2),dx,dy,0,'LineWidth',2)
 xlabel('Angle(\theta)')
 ylabel('Angle(\thetadot)')