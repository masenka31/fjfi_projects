function [Skoky] = reseni_konfliktu_mezi_skoky(Skoky,souradnice_bodu,help_stop,pocet_bodu)
%%  DOKUMENTACE FCE RESENI_KONFLIKTU_MEZI_SKOKY
%   Reseni_konfliktu_mezi_skoky je fce, ktera rozhodne konfliktni skoky,
%   tzn. pokud maji nejake body skocit do stejne bunky skoci pouze jeden.
%   INPUTS:
%   Skoky           = zamyslene skoky
%   souradnice_bodu = souradnice bodu
%   help_stop       = indexy konfliktnich bodu mezi sebou
%   pocet_bodu      = pocet bodu 
%% KOD
if ~isempty(help_stop)  % Funguje jen v pripade, ze mame konflikt 
    delka               = size(help_stop,1);
    konflikt            = zeros(delka,1);   % Pole k ukladani  
    ind_konf            = 1;                % Index konfliktu
    ind_dup             = 1;                % Index duplicity
    problem_duplicity   = zeros(delka,1);   % Pole k ukladani bodu, ktere byly konfliktni
    % abychom skocili skocili do kazde bunky jenom jednou
    for w = 1:pocet_bodu
        if sum(problem_duplicity == w) == 0  % neskocil jsem uz do teto bunky     
            if sum(help_stop(:,1) == w) == 1 % Dva body maji mezi sebou konflikt
                r = rand;
                if r > 0.5
                    konflikt(ind_konf) = w;
                else
                    konflikt(ind_konf) = help_stop(find(help_stop(:,1) == w,2),2);
                end
                ind_konf = ind_konf + 1;
            elseif sum(help_stop(:,1) == w) == 2 % Tri body maji mezi sebou konflikt
                r = rand;
                if r > 2/3
                    konflikt(ind_konf) = w;
                    % reseni problemu vicero vitezu konfliktu
                    druha                       = find_nth(help_stop(:,1),w,1);           
                    problem_duplicity(ind_dup)  = help_stop(druha,2);
                    ind_dup                     = ind_dup + 1;
                    treti                       = find_nth(help_stop(:,1),w,2);           
                    problem_duplicity(ind_dup)  = help_stop(treti,2);
                    ind_dup                     = ind_dup + 1;
                elseif r > 1/3
                    druha                       = find_nth(help_stop(:,1),w,1);
                    konflikt(ind_konf)          = help_stop(druha,2);
                    % reseni problemu vicero vitezu konfliktu
                    problem_duplicity(ind_dup)  = help_stop(druha,2);
                    ind_dup                     = ind_dup + 1;
                    treti                       = find_nth(help_stop(:,1),w,2);           
                    problem_duplicity(ind_dup)  = help_stop(treti,2);
                    ind_dup                     = ind_dup + 1;
                else
                    treti                       = find_nth(help_stop(:,1),w,2);
                    konflikt(ind_konf)          = help_stop(treti,2);
                    % reseni problemu vicero vitezu konfliktu
                    druha                       = find_nth(help_stop(:,1),w,1);           
                    problem_duplicity(ind_dup)  = help_stop(druha,2);
                    ind_dup                     = ind_dup + 1;
                    problem_duplicity(ind_dup)  = help_stop(treti,2);
                    ind_dup                     = ind_dup + 1;
                end        
                ind_konf = ind_konf +1;
            elseif sum(help_stop(:,1) == w) == 3 % Ctyri body maji mezi sebou konflikt
                r = rand;
                if r > 3/4
                    konflikt(ind_konf) = w;
                    % reseni problemu vicero vitezu konfliktu
                    druha                       = find_nth(help_stop(:,1),w,1);           
                    problem_duplicity(ind_dup)  = help_stop(druha,2);
                    ind_dup                     = ind_dup + 1;
                    treti                       = find_nth(help_stop(:,1),w,2);           
                    problem_duplicity(ind_dup)  = help_stop(treti,2);
                    ind_dup                     = ind_dup + 1;
                    ctvrta                      = find_nth(help_stop(:,1),w,3);
                    konflikt(ind_konf)          = help_stop(ctvrta,2);
                    ind_dup                     = ind_dup + 1;
                elseif r > 2/4
                    druha                       = find_nth(help_stop(:,1),w,1);
                    konflikt(ind_konf)          = help_stop(druha,2);
                    % reseni problemu vicero vitezu konfliktu
                    problem_duplicity(ind_dup)  = help_stop(druha,2);
                    ind_dup                     = ind_dup + 1;
                    treti                       = find_nth(help_stop(:,1),w,2);           
                    problem_duplicity(ind_dup)  = help_stop(treti,2);
                    ind_dup                     = ind_dup + 1;
                    ctvrta                      = find_nth(help_stop(:,1),w,3);
                    konflikt(ind_konf)          = help_stop(ctvrta,2);
                    ind_dup                     = ind_dup + 1;
                elseif r > 1/4
                    treti                       = find_nth(help_stop(:,1),w,2);
                    konflikt(ind_konf)          = help_stop(treti,2);
                    % reseni problemu vicero vitezu konfliktu
                    druha                       = find_nth(help_stop(:,1),w,1);           
                    problem_duplicity(ind_dup)  = help_stop(druha,2);
                    ind_dup                     = ind_dup + 1;
                    problem_duplicity(ind_dup)  = help_stop(treti,2);
                    ind_dup                     = ind_dup + 1;
                    ctvrta                      = find_nth(help_stop(:,1),w,3);
                    konflikt(ind_konf)          = help_stop(ctvrta,2);
                    ind_dup                     = ind_dup + 1;
                else
                    ctvrta                      = find_nth(help_stop(:,1),w,3);
                    konflikt(ind_konf)          = help_stop(ctvrta,2);
                    % reseni problemu vicero vitezu konfliktu
                    druha                       = find_nth(help_stop(:,1),w,1);           
                    problem_duplicity(ind_dup)  = help_stop(druha,2);
                    ind_dup                     = ind_dup + 1;
                    treti                       = find_nth(help_stop(:,1),w,2);           
                    problem_duplicity(ind_dup)  = help_stop(treti,2);
                    ind_dup                     = ind_dup + 1;
                    konflikt(ind_konf)          = help_stop(ctvrta,2);
                    ind_dup                     = ind_dup + 1;
                end
                ind_konf = ind_konf + 1;
            end
            problem_duplicity = sort(problem_duplicity(problem_duplicity>w));
        end
    end
    konflikt = nonzeros(konflikt);
    konflikt = sort(konflikt);
    %konflikt - vektor obsahujici ty body, ktere "vyhraji" posun na konfliktni
    %bunku

    % Vsechny konfliktni Skoky
    if size(help_stop,1) == 1
        konf_skok = unique(help_stop)';
    else
        konf_skok = unique(help_stop);
    end
    % Neudelam skoky z C, ale jen skoky z vektoru konflikt


    konf_i1 = 1; % index uspesnych konfliktu
    konf_i2 = 1; % index vsech konfliktu
    for ii = 1:pocet_bodu
        if ii == konf_skok(konf_i2) && ii ~= konflikt(konf_i1)
            Skoky(ii,:) = souradnice_bodu(ii,:); % Bod ktery nevyhral zustane na svem miste
            konf_i2 = konf_i2 + 1;
            if size(konf_skok,1) < konf_i2 % 
                break;
            end
        elseif ii == konf_skok(konf_i2) && ii == konflikt(konf_i1)
            konf_i1 = konf_i1 + 1;
            konf_i2 = konf_i2 + 1;
            if size(konflikt,1) <= konf_i1
                konf_i1 = 1;
            end
            if size(konf_skok,1) < konf_i2 % 
                break;
            end
        end
    end
end

% PUVODNI KOD Z MAINU NAHRAZEN TOUTO FCI
% if ~isempty(help_stop)
%     delka = size(help_stop,1);
%     konflikt = zeros(delka,1);
%     ind_konf = 1;
%     problem_duplicity = zeros(delka,1);
%     ind_dup = 1;
%     for w = 1:pocet_bodu
%         if sum(problem_duplicity == w) == 0
%             if sum(help_stop(:,1) == w) == 1 % Dva body maji mezi sebou konflikt
%                 r = rand;
%                 if r > 0.5
%                     konflikt(ind_konf) = w;
%                 else
%                     konflikt(ind_konf) = help_stop(find(help_stop(:,1) == w,2),2);
%                 end
%                 ind_konf = ind_konf + 1;
%             elseif sum(help_stop(:,1) == w) == 2 % Tri body maji mezi sebou konflikt
%                 r = rand;
%                 if r > 2/3
%                     konflikt(ind_konf) = w;
%                     % reseni problemu vicero vitezu konfliktu
%                     druha = find_nth(help_stop(:,1),w,1);           
%                     problem_duplicity(ind_dup) = help_stop(druha,2);
%                     ind_dup = ind_dup + 1;
%                     treti = find_nth(help_stop(:,1),w,2);           
%                     problem_duplicity(ind_dup) = help_stop(treti,2);
%                     ind_dup = ind_dup + 1;
%                 elseif r > 1/3
%                     druha = find_nth(help_stop(:,1),w,1);
%                     konflikt(ind_konf) = help_stop(druha,2);
%                     % reseni problemu vicero vitezu konfliktu
%                     problem_duplicity(ind_dup) = help_stop(druha,2);
%                     ind_dup = ind_dup + 1;
%                     treti = find_nth(help_stop(:,1),w,2);           
%                     problem_duplicity(ind_dup) = help_stop(treti,2);
%                     ind_dup = ind_dup + 1;
%                 else
%                     treti = find_nth(help_stop(:,1),w,2);
%                     konflikt(ind_konf) = help_stop(treti,2);
%                     % reseni problemu vicero vitezu konfliktu
%                     druha = find_nth(help_stop(:,1),w,1);           
%                     problem_duplicity(ind_dup) = help_stop(druha,2);
%                     ind_dup = ind_dup + 1;
%                     problem_duplicity(ind_dup) = help_stop(treti,2);
%                     ind_dup = ind_dup + 1;
%                 end        
%                 ind_konf = ind_konf +1;
%             elseif sum(help_stop(:,1) == w) == 3 % Ctyri body maji mezi sebou konflikt
%                 r = rand;
%                 if r > 3/4
%                     konflikt(ind_konf) = w;
%                     % reseni problemu vicero vitezu konfliktu
%                     druha = find_nth(help_stop(:,1),w,1);           
%                     problem_duplicity(ind_dup) = help_stop(druha,2);
%                     ind_dup = ind_dup + 1;
%                     treti = find_nth(help_stop(:,1),w,2);           
%                     problem_duplicity(ind_dup) = help_stop(treti,2);
%                     ind_dup = ind_dup + 1;
%                     ctvrta = find_nth(help_stop(:,1),w,3);
%                     konflikt(ind_konf) = help_stop(ctvrta,2);
%                     ind_dup = ind_dup + 1;
%                 elseif r > 2/4
%                     druha = find_nth(help_stop(:,1),w,1);
%                     konflikt(ind_konf) = help_stop(druha,2);
%                     % reseni problemu vicero vitezu konfliktu
%                     problem_duplicity(ind_dup) = help_stop(druha,2);
%                     ind_dup = ind_dup + 1;
%                     treti = find_nth(help_stop(:,1),w,2);           
%                     problem_duplicity(ind_dup) = help_stop(treti,2);
%                     ind_dup = ind_dup + 1;
%                     ctvrta = find_nth(help_stop(:,1),w,3);
%                     konflikt(ind_konf) = help_stop(ctvrta,2);
%                     ind_dup = ind_dup + 1;
%                 elseif r > 1/4
%                     treti = find_nth(help_stop(:,1),w,2);
%                     konflikt(ind_konf) = help_stop(treti,2);
%                     % reseni problemu vicero vitezu konfliktu
%                     druha = find_nth(help_stop(:,1),w,1);           
%                     problem_duplicity(ind_dup) = help_stop(druha,2);
%                     ind_dup = ind_dup + 1;
%                     problem_duplicity(ind_dup) = help_stop(treti,2);
%                     ind_dup = ind_dup + 1;
%                     ctvrta = find_nth(help_stop(:,1),w,3);
%                     konflikt(ind_konf) = help_stop(ctvrta,2);
%                     ind_dup = ind_dup + 1;
%                 else
%                     ctvrta = find_nth(help_stop(:,1),w,3);
%                     konflikt(ind_konf) = help_stop(ctvrta,2);
%                     % reseni problemu vicero vitezu konfliktu
%                     druha = find_nth(help_stop(:,1),w,1);           
%                     problem_duplicity(ind_dup) = help_stop(druha,2);
%                     ind_dup = ind_dup + 1;
%                     treti = find_nth(help_stop(:,1),w,2);           
%                     problem_duplicity(ind_dup) = help_stop(treti,2);
%                     ind_dup = ind_dup + 1;
%                     konflikt(ind_konf) = help_stop(ctvrta,2);
%                     ind_dup = ind_dup + 1;
%                 end
%                 ind_konf = ind_konf + 1;
%             end
%             problem_duplicity = sort(problem_duplicity(problem_duplicity>w));
%         end
%     end
%     konflikt = nonzeros(konflikt);
%     konflikt = sort(konflikt);
%     %konflikt - vektor obsahujici ty body, ktere "vyhraji" posun na konfliktni
%     %bunku
% 
%     % Vsechny konfliktni Skoky
%     konf_skok = unique(help_stop);
%     % Neudelam skoky z C, ale jen skoky z vektoru konflikt
% 
%     konf_i1 = 1; % index uspesnych konfliktu
%     konf_i2 = 1; % index vsech konfliktu
%     for ii = 1:pocet_bodu
%         if ii == konf_skok(konf_i2) && ii ~= konflikt(konf_i1)
%             Skoky(ii,:) = souradnice_bodu(ii,:); % Bod ktery nevyhral zustane na svem miste
%             konf_i2 = konf_i2 + 1;
%             if size(konf_skok,1) < konf_i2 % 
%                 break;
%             end
%         elseif ii == konf_skok(konf_i2) && ii == konflikt(konf_i1)
%             konf_i1 = konf_i1 + 1;
%             konf_i2 = konf_i2 + 1;
%             if size(konflikt,1) <= konf_i1
%                 konf_i1 = 1;
%             end
%         end 
%     end
% end