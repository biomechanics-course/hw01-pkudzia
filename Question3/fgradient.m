function dfdx = fgradient(f, x0, dx)
% FGRADIENT   Computes Jacobian (partial derivative or gradient) of function
%
% dfdx = fgradient(@f, x0 [, dx])
%
%   Uses finite differences to compute partial derivative of function f
%   evaluated at vector x0. Optional argument dx specifies finite difference
%   step. Note that argument f should typically be entered as a
%   function handle, e.g. @f.
%
%   When dx is not given or empty, a default of 1e-6 is used.

  if nargin < 3 || isempty(dx)
    dx = 1e-6;
  end
  
  df = zeros(1,length(x0)); % store row vector for gradient
  
  f0 = f(x0);
  for i = 1:length(x0)
    xperturbed = x0;
    xperturbed(i) = xperturbed(i) + dx;
    df(1,i) = f(xperturbed) - f0;
  end
  dfdx = df / dx;
  
end