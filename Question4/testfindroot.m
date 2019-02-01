% testfindroot

% Here is a function to find the root of
desiredroots1 = [4, -1, -8]; % the roots of the function, where we
% intend for the positive root at +4 to be found.
polywithroots1 = poly(desiredroots1); % coefficients of a corresponding polynomial

% The function handle is constructed from the coefficients here:
fhandle1 = @(x) polyval(polywithroots1, x); % a function with a handle
% the function above maybe called with fhandle(x), and has the desired
% roots. It also a function handle, meaning it can be sent to another
% function without needing the @f.

x = -10:0.1:10; % take a look at the function
plot(x, fhandle1(x)); 
xlabel('x'); ylabel('fhandle1'); title('Function with multiple roots');

abstol = 1e-5; % a tolerance to test for root finding; make sure this is
% greater than the tolerance used by findroot

% Here is another function that can cause trouble for findroot.
% This has a root at zero, but will not converge
fhandle2 = @(x) x.^(1/3); 

fhandle3 = @(x) [(x(1)-1); x(2).^3+1]; % roots at [1; -1]
%% Test case 1
x0 = 4.1;
findroot(fhandle1, x0)

%% Test case 2 "wrong" root

x0 = -5e6; % CHANGE this to a different number to cause wrong root found
assert( abs(findroot(fhandle1, x0)  - desiredroots1(1)) >= abstol, ...
    'Findroot found an unintended root');
assert( abs(findroot(fhandle1, x0)  - desiredroots1(2)) < abstol, ...
    'Findroot does not satisfy tolerance');

%% Test case 3 No convergence
% ADD a test findroot does not find correct root for fhandle2 
x0 = 0;
intendedrootCase3 = 0; 
assert ( abs(findroot(fhandle2,x0)-intendedrootCase3) >=abstol,...
    'Findroot found an incorrect root');
findroot(fhandle2,x0)
%% Test case 4 Vector function
% ADD a test that demonstrates that vector fhandle3 does yield
% correct root

x0 =[1,-1]; %% ADD info here
assert( sqrt(sum(findroot(fhandle3, x0) - [1; -1]).^2)/2 < abstol, ...
    'Vector Findroot does not satisfy tolerance')
