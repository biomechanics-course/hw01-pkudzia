% Unit test for finite difference fgradient function
% using Matlab's unit testing framework.
% To execute tests, execute runtests('testfgradient')

% define anonymous functions use for jacobian testing
samplefunction0 = @(x) x(1)^2+x(2)*x(3);           % scalar function of 3x1 x
samplefunction1 = @(x) [x(1)^3; x(1)^2+x(2)*x(3)]; % 2x1 function, 3x1 x
samplefunction2 = @(x) [tan(x(1))*x(2); sin(x(1))+x(2); cos(x(2))]; % 3x1 function, 2x1 x
% (anonymous functions allow simple functions to be defined in-line)

% define the analytical jacobians to compare against
analyticaljacobian0 = @(x) [2*x(1) x(3) x(2)];
analyticaljacobian1 = @(x) [3*x(1)^2 0 0; 2*x(1) x(3) x(2)];
analyticaljacobian2 = @(x) [x(2)*sec(x(1))^2 tan(x(1)); cos(x(1)) 1; 0 -sin(x(2))];

% define points to evaluate Jacobian about
x0 = [1 2 3];
x1 = [1 2 3];
x2 = [1 2];

abstol = 1e-5; % a rough absolute tolerance for finite differencing
% All of the variables above are shared between the test cells below.

%% Test 0: Gradient of function 0
% assuming the finite differencing step size is small, the error in
% finite differencing should not be very large.
jacobian0 = fgradient(samplefunction0, x0); % take derivative about x0
assert(isequal(size(jacobian0), [1 3]), 'Jacobian 0 wrong size')
assert(max(max(abs(jacobian0 - analyticaljacobian0(x0)))) < abstol, ...
  'Numerical Jacobian 0 not very accurate')

% assert prints out an error message if the condition is not true
% Testing framework is helpful for test-driven development