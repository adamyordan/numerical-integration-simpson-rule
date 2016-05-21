function y = adapt_simp ( f, a, b, TOL )

%ADAPT_SIMP    approximate the definite integral of an arbitrary function
%              to within a specified error tolerance using adaptive 
%              quadrature based on Simpson's rule
%
%     calling sequences:
%             y = adapt_simp ( 'f', a, b, TOL )
%             adapt_simp ( 'f', a, b, TOL )
%
%     inputs:
%             f       string containing name of m-file defining integrand
%             a       lower limit of integration
%             b       upper limit of integration
%             TOL     absolute error convergence tolerance
%
%     output:
%             y       approximate value of the definite integral of f(x)
%                     over the interval a < x < b
%
%     NOTE:
%             if ADAPT_SIMP is called with no output arguments, the  
%             approximate value of the definite integral of f(x) over 
%             the interval a < x < b will be displayed, together with
%             the estimate for the error in the approximation and the 
%             total number of function evaluations used
%

fa = feval ( f, a );
fc = feval ( f, (a+b)/2 );
fb = feval ( f, b );
sab = (b-a)*(fa + 4*fc + fb)/6;
[approx eest nfunc] = as ( sab, fa, fc, fb, f, a, b, TOL );

if ( nargout == 0 )
   s = sprintf ( '\t\t approximate value of integral: \t %.12f \n', approx );
   s = sprintf ( '%s \t\t error estimate: \t\t\t\t\t %.4e \n', s, eest );
   s = sprintf ( '%s \t\t number of function evaluations: \t %d \n', s, nfunc+3 );
   disp ( s )
else
   y = approx; 
end;
return

function [app, est, nf] = as ( sab, fa, fc, fb, f, a, b, TOL )

c = (a+b)/2;
fd = feval ( f, (a+c)/2 );
fe = feval ( f, (c+b)/2 );
sac = (c-a)*(fa + 4*fd + fc)/6;
scb = (b-c)*(fc + 4*fe + fb)/6;

errest = abs ( sab - sac - scb );
if ( errest < (10.0*TOL) )
   app = sac+scb;
   est = errest / 10.0;
   nf = 2;
   return;
else
   [a1 e1 n1] = as ( sac, fa, fd, fc, f, a, c, TOL/2.0 );
   [a2 e2 n2] = as ( scb, fc, fe, fb, f, c, b, TOL/2.0 );
   app = a1 + a2;
   est = e1 + e2;
   nf = n1 + n2 + 2;
   return;
end;