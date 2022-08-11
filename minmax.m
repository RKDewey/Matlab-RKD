function y = minmax(x)
%
% MINMAX      find the minimum and maximum of a vector or a matrix
%             Robust with respect to NaN.
y=[min(min(x)) max(max(x))];
%