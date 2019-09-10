function [ vc] = fn_getvc(romsfn)

%Get vertical coordinate informations

vc.vt = ncread(romsfn,'Vtransform');
vc.vs = ncread(romsfn,'Vstretching');
vc.Cs_r = ncread(romsfn,'Cs_r');
vc.s_rho = ncread(romsfn,'s_rho');
vc.theta_s = ncread(romsfn,'theta_s');
vc.theta_b = ncread(romsfn,'theta_b');
vc.Tcline = ncread(romsfn,'Tcline');

end

