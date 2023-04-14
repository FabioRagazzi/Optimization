function [bphi] = KorenMlim(a,b)
% KorenMlim Summary of this function goes here
% INPUT
% a ->
% b ->
% OUTPUT
% bphi ->
aa = a.*a;
ab = a.*b;
sixth = 1/6;
bphi = b;

indici = (aa-2.5*ab)<=0;
bphi(indici) = sixth * (b(indici) + 2*a(indici));

indici = (aa-0.25*ab)<=0;
bphi(indici) = a(indici);

bphi(ab<=0) = 0;
end
