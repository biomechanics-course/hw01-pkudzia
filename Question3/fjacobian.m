function [dfdx,df] = fjacobian(f, x0, dx)
% FGRADIENT   Computes Jacobian (partial derivative or gradient) of function
%
% dfdx = fgradient(@f, x0,[ dx])
%
%   Uses finite differences to compute partial derivative of function f
%   evaluated at vector x0. Optional argument dx specifies finite difference
%   step. Note that argument f should typically be entered as a
%   function handle, e.g. @f.
%

  if nargin < 3 || isempty(dx) % Checks number of inputs 
    dx = 1e-6; % If change in x doesnt excist then use this value
  end
  
  f0 = f(x0); 
  % inputs are 3 outputs are 2 so there should be a 2x3 matrix that comes out
  df = zeros(length(f0),length(x0));  % store row vector for gradient
  
  for i = 1:length(x0) % run # of intial conditions and perturb each out
    xperturbed = x0;
    xperturbed(i) = xperturbed(i) + dx;
    df(:,i) = f(xperturbed) - f0; % determine 
  end
  
  dfdx = df / dx;
  
  

  
  
  
end