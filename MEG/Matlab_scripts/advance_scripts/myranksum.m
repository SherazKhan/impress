function [zval] = myranksum(x,y)

x = x(:);
y = y(:);
nx = numel(x);
ny = numel(y);
if nx <= ny
   smsample = x;
   lgsample = y;
   ns = nx;
   signFlag=1;
else
   smsample = y;
   lgsample = x;
   ns = ny;
   signFlag=-1;
end

[ranks, tieadj] = tiedrank([smsample; lgsample]);
xrank = ranks(1:ns);
w = sum(xrank);

wmean = ns*(nx + ny + 1)/2;

   tiescor = 2 * tieadj / ((nx+ny) * (nx+ny-1));
   wvar  = nx*ny*((nx + ny + 1) - tiescor)/12;
   wc = w - wmean;
   zval = signFlag*((wc - 0.5 * sign(wc))/sqrt(wvar));
  % p=normpdf(-zval);