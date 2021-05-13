function results = pg_eff_net_lin_stability(model)
% PG_EFF_NET_LIN_STABILITY computes the linear stability using the
% effective network model.
%
%  results = PG_EFF_NET_LIN_STABILITY(model)
%
% The structure 'model' should be from one generated by the function
% pg_eff_net.
%
% See also pg_eff_net.

% Last modified by Takashi Nishikawa on 10/1/2014

% Extract the parameters of the model.
Y = model.Y;
delta = angle(model.E);
E_abs = abs(model.E);
Y_abs = abs(model.Y);
Y_ang = angle(model.Y);
H = model.H;
omega_R = model.omega_R;
b = model.D./(2*model.H); 
G = real(Y);
B = imag(Y);
n = size(Y,1);
P = zeros(n);

% Compute the matrix P.
for i = 1:n
    for k = [1:i-1,i+1:n]
        dik = delta(i) - delta(k);
        P(i,k) = - E_abs(i)*E_abs(k)/(2*H(i))*(B(i,k)*cos(dik) - G(i,k)*sin(dik));
    end
end
for i = 1:n
    P(i,i) = - sum(P(i,[1:i-1,i+1:n]));
end
P = omega_R*P;
results.P = P;



%%% P2? linearization different
% for i = 1:n
%     for k = [1:n]
%     %for k = [1:i-1,i+1:n]
%         dik = delta(i) - delta(k);
%         P2(i,k) = E_abs(i) * E_abs(k) * Y_abs(i,k) / (2 * H(i)) * sin(dik - Y_alp(i,k));
%     end
%     %P2(i,i) = model.Pi(i) - E_abs(i) * E_abs(i) * G(i,i);
% end
% for i = 1:n
%    P2(i,i) = - sum(P2(i,[1:i-1,i+1:n]));
% end
% 
% P2 = omega_R * P2;
% results.P2 = P2;

% Compute the Jacobian matrix J.
J = [zeros(n), eye(n); -P, -diag(b)];
results.J = J;

% alpha2:
ev_P = eig(P);
[~,ix] = min(abs(ev_P));
ev_P(ix) = [];
results.is_alpha_real = ( max(abs(imag(ev_P))) < 1e-6 );
if ~results.is_alpha_real
    results.max_abs_imag_ev_P = max(abs(imag(ev_P)));
end
results.alpha2 = min(real(ev_P));
if (abs(results.alpha2) < 1e-6) 
    results.alpha2 = 0.0;
end
results.ev_P = ev_P;

% Maximum Lyapunov exponent:
ev_J = eig(J);
[~,ix] = min(abs(ev_J));
ev_J(ix) = [];

results.max_lyap = max(real(ev_J));
results.ev_J = ev_J;

% compute lmax at bopt, if exists
results.max_lyap2 = nan;
if results.alpha2 >= 0.0
    %fprintf('alpha_2 = %f\n', results.alpha2);
    b2 = ones(n,1) * 2 * sqrt(results.alpha2);
    J = [zeros(n), eye(n); -P, -diag(b2)];
    
    ev_J = eig(J);
    [~,ix] = min(abs(ev_J));
    ev_J(ix) = [];

    results.max_lyap2 = max(real(ev_J));
end
