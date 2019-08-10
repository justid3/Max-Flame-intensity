function Tg = radcorrect(Tj,Dj,Nu)
% Input Nusselt number or,
% Default Nu=2
% Tj can be colum or row vector of junction temperatures
it = 4; % iterations

if exist('Nu','var')==0
    Nu=2;
end

% Stefan-Boltzman
sigma = 5.6704e-08; %[W/m^2K^2]
% Stefan-Boltzman constant

% Constant term
C = sigma*Dj/Nu; % Constant term for calulation simplicity

N=numel(Tj); %get number of elements in Tj
% pre-allocate
T = zeros(N,it);

for j=1:N
    T(j,1)=Tj(j); %initialize T
end

% emissivity of surface of thermocouple junction
% s-type similar composition to r-type
% eps_PtRh(:,1) = 0.1357 * log(T(:,1)) - 0.7887; % 10% Rhodium wire
% eps_Pt(:,1) = 0.136 * log(T(:,1)) - 0.8047; % emissivity of platinum
% eps(:,1) = (eps_PtRh(:,1) + eps_Pt(:,1))./2; %arithmetic mean
% eps = sqrt(eps_PtRh*eps_Pt); %geometric mean
%
% from Shaddix Review:
eps = -0.1 + 3.24e-4*Tj - 1.25e-7*Tj.^2 + 2.18e-11*Tj.^3;

for n = 2:it
    k = (55.4*T(:,n-1) + 1228.9)/10^6; %thermal conductivity of air
    T(:,n) = Tj + C*eps.*Tj.^4./transpose(k);
end

Tg = T(:,it);
