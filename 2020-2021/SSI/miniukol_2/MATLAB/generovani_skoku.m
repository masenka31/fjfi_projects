function [Skoky,cum_ind_odchodu] = generovani_skoku(tau_tau,souradnice_bodu,stat_pole,cum_ind_odchodu,k_S)
%%  DOKUMENTACE FCE GENEROVANI_SKOKU
%   Generovani_skoku je fce, ktera na zaklade umisteni bodu v poli, statickeho pole a parametru 
%   provede simulaci skoku bodu. Zaroven nam zaznamenava kolik bodu odejde do atraktoru.
%   INPUTS:
%   tau_tau         = pole 0 a 1 oznacujici kde jsou obsazene bunky a kde nikoliv 
%   souradnice_bodu = souradnice bodu
%   stat_pole       = staticke pole modelu
%   cum_ind_odchodu = index kumulujuci pocet bodu odeslych do atraktoru
%   k_S             = voleny parametr modelu
%   OUTPUTS:
%   Skoky           = provedeny skok studovaneho bodu
%   cum_ind_odchodu = aktualizvany index kumulujuci pocet bodu odeslych do atraktoru
%% KOD
    [P,pocet_sousedu] = najdi_sousedy(tau_tau,souradnice_bodu); % najde souradnice sousednich bunek a pocet sousedu
    % P jsou souradnice kam by mohli skocit
    mist_kam_jit = 1;
    poradi_kam_jde = [];
    for o = 1:pocet_sousedu
        if (tau_tau(P(o,1),P(o,2)) == 0) % Neni uz tam bod?
            mist_kam_jit    = mist_kam_jit + 1;
            poradi_kam_jde  = [poradi_kam_jde,o]; % muzu jit do tech bodu ze sousednich, ktere mi oznacilo o
        end
    end
    % Mam souradnice poli sousedu kam muzu skocit v P
    n               = size(poradi_kam_jde,2);
    kam_lze_skocit  = zeros(n,2);
    for j = 1:n
        help_j = poradi_kam_jde(j);
        kam_lze_skocit(j,:) = P(help_j,:);
    end

    [Skoky,ind_odchodu] = zmena_pozice(souradnice_bodu,stat_pole,kam_lze_skocit,k_S);
    cum_ind_odchodu     = cum_ind_odchodu + ind_odchodu;
end

%     PUVODNI KOD V MAIN
%     [P,pocet_sousedu(k)] = najdi_sousedy(tau_tau,souradnice_bodu(k,:)); % Pro k-ty bod najde souradnice sousednich bunek
%     % P jsou souradnice kam by mohli skocit
%     mist_kam_jit = 1;
%     poradi_kam_jde = [];
%     for o = 1:pocet_sousedu(k)
%         if (tau_tau(P(o,1),P(o,2)) == 0) % Neni uz tam bod?
%             mist_kam_jit = mist_kam_jit + 1;
%             poradi_kam_jde = [poradi_kam_jde,o]; % muzu jit do tech bodu ze sousednich, ktere mi oznacilo o
%         %elseif stat_pole(P(1,k,1),P(1,k,2)) ~= 0   
%         end
%     end
%     % Mam souradnice poli sousedu kam muzu skocit v P
%     n = size(poradi_kam_jde,2);
%     kam_lze_skocit = zeros(n,2);
%     for j = 1:n
%         help_j = poradi_kam_jde(j);
%         kam_lze_skocit(j,:) = P(help_j,:);
%     end
%     
%     [Skoky(k,:),ind_odchodu] = zmena_pozice(souradnice_bodu(k,:),stat_pole,kam_lze_skocit,k_S);
%     cum_ind_odchodu = cum_ind_odchodu + ind_odchodu;
%     %stop = 1;



