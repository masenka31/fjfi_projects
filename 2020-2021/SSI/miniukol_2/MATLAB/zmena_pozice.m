function [Skok, ind_odchodu] = zmena_pozice(puv_pozice,stat_pole,sousedi,k_s)
% Dva ruzne pripady, bud kdyz jsi u atraktoru nebo jinak
%%  DOKUMENTACE FCE ZMENA_POZICE
%   ZMENA_POZICE Vypocitava souradnice kam bunka skace a zda je u atraktoru
%   (u atraktoru = stat_pole(.,.) = 1)
%   INPUTS:
%   puv_pozice  = souradnice zkoumaneho bodu
%   stat_pole   = staticke pole predstavujici vzdalenost od atraktoru
%   k_s         = voleny parametr ovlivnujici "rychlost pohybu" bodu
%
%   OUTPUTS:
%   Skok        = souradnice pole kam chce bunka z puv_pozice skocit
%   ind_odchodu = 0/1, odchazim do atraktoru NE/ANO 
%
%% KOD
ind_odchodu = 0;    % predem nastavime index odchodu na negativni
    if stat_pole(puv_pozice(1),puv_pozice(2)) ~= 1  % pokud nestojim u atraktoru
        m       = size(sousedi,1);
        pravd   = zeros(m+1,1);
        for i = 1:m 
            hodnota     = stat_pole(sousedi(i,1),sousedi(i,2));
            pravd(i)    = (exp(-hodnota*k_s));
        end
        hodnota = stat_pole(puv_pozice(1,1),puv_pozice(1,2));
        pravd(m+1) = (exp(-hodnota*k_s));   % pravdepodobnost setrvani na pozici
        % vektor hodnota obsahuje vypoctene pravdepodobnosti ruznych zmen
        % pozice bodu

        norm_pravd = zeros(m+1,1);
        norm_pravd(:) = pravd(:)./(sum(pravd(:)));  % normalizace
        ru = rand;                                  % uniformly generate random number from (0,1)     
        e = 1;
        cum_pravd = cumsum(norm_pravd);
        for i = 1:m+1
            if ru < cum_pravd(i)
                e = i; 
                break; 
            end
        end
        sousedi = [sousedi; puv_pozice]; % musime rozsirit o puvodni policko
        % e-ta hodnota uskutecni nas skok
        Skok = sousedi(e,:);
    elseif stat_pole(puv_pozice(1),puv_pozice(2)) == 1 % stojime u atraktoru
        m       = size(sousedi,1);
        pravd   = zeros(m+2,1);
        for i = 1:m
            hodnota = stat_pole(sousedi(i,1),sousedi(i,2));
            pravd(i) = (exp(-hodnota*k_s));
        end
        hodnota         = stat_pole(puv_pozice(1,1),puv_pozice(1,2));
        pravd(m+1)      = (exp(-hodnota*k_s));      % pravdepodobnost setrvani na pozici
        pravd(m+2)      = 1;                        % pravdepodobnost "skoku" do atraktoru
        norm_pravd      = zeros(m+2,1);
        norm_pravd(:)   = pravd(:)./(sum(pravd(:)));% normalizace
        ru = rand;                                  % uniformly generate random number from (0,1)     
        e = 1;
        cum_pravd = cumsum(norm_pravd);
        for i = 1:m+2
            if ru < cum_pravd(i)
                e = i; 
                break; 
            end
        end
        atraktor = [0 0];   % takto oznacime atraktor
        sousedi = [sousedi; puv_pozice;atraktor]; % Musime rozsirit o puvodni policko a atraktor
        % e-ta hodnota uskutecni nas skok
        if e == m+2
            ind_odchodu = 1;
        end
        Skok = sousedi(e,:);
    end   
end