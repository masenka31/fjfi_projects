%% intro
clc;
clear variables;
clear all;
% parametry TASEPu

%% Generovani 2D mrizky
L = 10;

tau_tau_inic = zeros(L);

%% Nahodne vygenerovani bodu
%pocet_bodu = floor(L*L/10);
% pocet_bodu = 50; 
% q = 1;
% souradnice_bodu = zeros(pocet_bodu,2);
% while q < pocet_bodu+1
%     souradnice_bodu(q,1) = randi(L);
%     souradnice_bodu(q,2) = randi(L);
%     for i = 1:q
%         if souradnice_bodu(q,1) == souradnice_bodu(i,1) && souradnice_bodu(q,2) == souradnice_bodu(i,2) 
%             souradnice_bodu(q,1) = randi(L);
%             souradnice_bodu(q,2) = randi(L);
%             i = 1;
%         end
%     end
%     q = q + 1;
% end
rng(5);

tau_tau_inic = floor(randi(7,L)/7);

pocet_bodu_inic = sum(sum(tau_tau_inic));

souradnice_bodu_inic = zeros(pocet_bodu_inic,2);
[a,b] = find(tau_tau_inic == 1);
for j = 1:pocet_bodu_inic
    souradnice_bodu_inic(j,1) = a(j);
    souradnice_bodu_inic(j,2) = b(j);
end

%Umisteni do tau_tau
% for j = 1:pocet_bodu
%     tau_tau(souradnice_bodu(j,1),souradnice_bodu(j,2)) = 1;
% end

%% Generovani statickeho pole
stat_pole = zeros(L);           % vzdalenosti od atraktoru do zdi okolo pole dame hodnotu inf 
stat_pole(floor(L/2),1) = 1;    % posledni bod od atraktoru/vychodu
number_neigh = 0;
vz = 1;
prvni = [floor(L/2),1];

for i = 1:2*L-1
    [ind1, ind2]    = find(stat_pole == vz); 
    ind             = [ind1, ind2]; 
    vel_ind         = size(ind,1);
    pocet_sousedu   = zeros(1,vel_ind); 
    for k = 1:vel_ind
        [P,pocet_sousedu(k)] = najdi_sousedy(stat_pole,ind(k,:)); % Zde to nefunguje jak ma      
        for o = 1:pocet_sousedu(k)
            if (stat_pole(P(o,1),P(o,2)) == 0)
                stat_pole(P(o,1),P(o,2)) = vz + 1;
            %elseif stat_pole(P(1,k,1),P(1,k,2)) ~= 0   
            end
        end
    end
    vz = vz +1;
end
%% Realizace pohybu

iter        = 1;
num_iter    = 100;
casy_behem_iteraci = zeros(1,num_iter);
while iter < num_iter
    tau_tau             = tau_tau_inic;
    pocet_bodu          = pocet_bodu_inic;
    souradnice_bodu     = souradnice_bodu_inic;
    k_S = 2;
    % vypocet pravdepodobnosti pohybu
    Skoky = zeros(pocet_bodu,2);
    qnmax = 1000;


    % X = zeros(qnmax, L, L);
    qn              = 1;
    cum_ind_odchodu = 0;
    cas             = 1;

    
    while qn < qnmax
        for k = 1:pocet_bodu
            [Skoky(k,:),cum_ind_odchodu] = generovani_skoku(tau_tau,souradnice_bodu(k,:),stat_pole,cum_ind_odchodu,k_S);
        end
        % Poresit konflikty ve skocich 
        help_stop = [];
        for w = 1:pocet_bodu-1
            for r = w+1:pocet_bodu
                if Skoky(w,1) == Skoky(r,1) && Skoky(w,2) == Skoky(r,2) && w ~= r
                    % fce kdy nahodne vyberu tu co necham a tu co se vazne posune
                    help_stop = [help_stop; w r]; % ukladam indexy, ktere se nepohnou mezi sebou
                    % ulozit vsechny problemove kroky 
                end
            end
        end

        [Skoky] = reseni_konfliktu_mezi_skoky(Skoky,souradnice_bodu,help_stop,pocet_bodu);

        if cum_ind_odchodu == 1
            a = size(Skoky,1) - 1;
            help_skoky = zeros(a,2);
        else
            help_skoky = Skoky;
        end
        if max(cumsum(Skoky(:,1) == 0)) ~= 0 || max(cumsum(Skoky(:,2) == 0)) ~= 0
            [ind01] = find(Skoky(:,1) == 0);
            pom1 = Skoky(Skoky(:,1)>0,1); 
            pom2 = Skoky(Skoky(:,1)>0,2);
            Skoky = [pom1 pom2];
        end
%         Skoky       = nonzeros(Skoky); % Odstraní pøípadný nulový prvek FUNGUJE SPATNE
%         ind_range   = size(Skoky,1)/2;
%         for k = 1:ind_range
%             help_skoky(k,1) = Skoky(k);
%             help_skoky(k,2) = Skoky(k+ind_range);
%         end
%         Skoky           = help_skoky;
        souradnice_bodu = Skoky;
        tau_tau         = zeros(L);
        %Umisteni do tau_tau
        akt_pocet_bodu  = size(souradnice_bodu,1);
        if cum_ind_odchodu == 1
            tau_tau(prvni(1),prvni(2)) = 0;
        end

        for j = 1:akt_pocet_bodu
            tau_tau(souradnice_bodu(j,1),souradnice_bodu(j,2)) = 1;
        end

            % objevi se na novych pozicich
        %     n = n + 1;
        %     X(n, :, :) = tau_tau;
        %     
        %     plotState(X(n, :, :),L,L);
        %     pause(0.5);

        % tau_tau
        % pause(0.5);
        qn              = qn + 1;
        cum_ind_odchodu = 0;
        pocet_bodu      = akt_pocet_bodu;
        cas             = cas + 1;
        if akt_pocet_bodu == 0
            qn = qnmax;
        end
    end
    casy_behem_iteraci(iter) = cas;
    iter    = iter + 1;
end
% Okoli bunky
% |x1 - x2| + |y1 - y2|



%% simulace


% function d = dist(b1, b2)
%     x1 = b1(1);
%     y1 = b1(2);
%     x2 = b2(1);
%     y2 = b2(2);
%     d = abs(x1 - x2) + abs(y1 - y2);
% end

% function a = neumann_okoli(b1, b2)
%     a = (dist(b1, b2) == 1);
% end






