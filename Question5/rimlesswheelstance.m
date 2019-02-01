function [xe,te,xs,ts,energies] = rimlesswheelstance(x0, parms)
% RIMLESSWHEELSTANCE    Rimless wheel simulation
%
%   xe = rimlesswheelstance(x0 [, parms])
% 
% Given initial state x0, performs a stance phase simulation of the 
% rimless wheel, which has dynamics of a linearized inverted pendulum.
% x0 = [theta(0); thetadot(0)], initial angle and angular velocity of
% stance leg (measured counter-clockwise from vertical).
%
% Returns xe final state, te end time (detected as event), and
% arrays xs and ts containing state and times over multiple time steps.
%
% Default model parameters are chosen: alpha = 0.3 (half inter-leg angle),
% rgyr = 0 (radius of gyration), gamma = 0.04 (downward ground slope),
% tmax = 5 (max runtime).
% Other parameters may be used by optionally including structure
% parms with fields alpha, rgyr, gamma, tmax.

if nargin == 0 % set default initial state if none given
    x0 = [0.3; -0.4];
end
    
if nargin == 1 % set default parameters
    parms = struct('alpha', 0.3, 'rgyr', 0, 'gamma', 0.04, 'tmax', 5);
end % otherwise parms may be specified as argument

% Parameters
alpha = parms.alpha;  % Half inter-leg angle
rgyr = parms.rgyr;    % Radius of gyration
gamma = parms.gamma;  % Downward ground slope
tmax = parms.tmax;    % Maximum simulation time

% state vector: x = [theta; thetadot]

% these statements are necessary in order to set event handling:
% ode45 will stop the integration when the event occurs
options = odeset('events', @eventrw);


% [t,sol_opt] = ode45(@(t,x) jump_sim(t,x,parms,eq), tspan,int_cond,Opt)
% integrate using ode45 and the state-derivative function
tspan = linspace (0, tmax,1000);
odesol= ode45(@(t,x) frimlesswheel(t,x,parms),tspan,x0, options);% ADD CODE HERE TO DO SIMULATION

ts = odesol.x'; % time vector (as a column)
xs = odesol.y'; % states array (states as rows, time as column);

te = odesol.xe;
xe = odesol.ye;

% BE SURE TO CALCULATE ENERGY
[Total,KE,PE] = energyrw(ts, xs,parms);

energies.Total = Total;
energies.KE = KE;
energies.PE = PE;


% end of rimlesswheelstance; local functions follow
 
%  figure(1);
%  hold on;
%  plot(ts,xs(:,1));
%  figure(2);
%  hold on;
%  plot(ts, xs(:,2));
%  figure(3);
%  hold on;
%  plot(ts,energies);
%  figure(4);
%  hold on;
%  plot(xs(:,1), xs(:,2),'--')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xdot = frimlesswheel(t,x,parms)
% state-derivative function for rimless wheel
% state is x = [theta; thetadot]
% equation: thetadotdot - sigma2*sin(theta-gamma) = 0

alpha = parms.alpha;  % Half inter-leg angle
rgyr = parms.rgyr;    % Radius of gyration
gamma = parms.gamma;  % Downward ground slope

sigma2 = 1/(1+rgyr*rgyr); % sigma squared

theta = x(1);
thetadot = x(2);

thetadotdot = sigma2*sin(theta-gamma); 

xdot = [thetadot; thetadotdot];

end % frimlesswheel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [value, isterminal, direction] = eventrw(t, x)
% returns event function for rimless wheel simulation

% Here is how event checking works:  
% At each integration step, ode45 checks to see if an
% event function passes through zero (in this case, we need
% the function to go through zero when the foot hits the
% ground).  It finds the value of the event function by calling
% eventrw, which is responsible for returning the value of the 
% event function in variable value.  isterminal should contain
% a 1 to signify that the integration should stop (otherwise it
% will keep going after value goes through zero).  Finally,
% direction should specify whether to look for event function
% going through zero with positive or negative slope, or either.
alpha = 0.3;  % Half inter-leg angle
% we want to stop the simulation when theta = -alpha
% or when (theta + alpha) is zero
value = x(1) + alpha; % should contain the event value
isterminal = 1;  % tells ode45 to stop when event occurs
direction = -1;   % tells ode45 to look for negative crossing

end % eventrw

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [energy,KE,PE] = energyrw(t, x,parms)
% returns the energy of the system at a given state
% state can also be given as an array

alpha = parms.alpha;  % Half inter-leg angle
rgyr = parms.rgyr;    % Radius of gyration
gamma = parms.gamma;  % Downward ground slope

KE = 0.5*(1+rgyr*rgyr)*x(:,2).^2;
PE = cos(x(:,1)-gamma);
energy = KE + PE;

end % energyrw

end % outer function

