function [P,pocet_s] = najdi_sousedy(pole,ind)
%%  DOKUMENTACE FCE NAJDI_SOUSEDY
%   NAJDI_SOUSEDY Hleda sousedni policka bodu souradnic [ind(1),ind(2)],
%   sousedni znamena ze spolu sousedi hranou, nikoliv rohem
%   INPUTS:
%   pole    = oznacuje pole ve kterem se nachazi bunka
%   ind     = souradnice bodu pro ktereho hledame sousedy
%   OUTPUTS:
%   P       = souradnice sousednich bodu, chybejici reprezentovano [0 0]
%   pocet_s = znaci pocet sousedu

    hranice1 = size(pole,1); % na vysku
    hranice2 = size(pole,2); % na sirku
    pocet = 0;
    help = [];
    if ind(1) > 1 
        pocet = pocet + 1;
        A = [ind(1)-1,ind(2)];
        help = [A];
    end
    if ind(1) < hranice1 
        pocet = pocet + 1;
        B = [ind(1)+1,ind(2)];
        help = [help;B];
    end
    if ind(2) > 1 
        pocet = pocet + 1;
        C = [ind(1),ind(2)-1];
        help = [help;C];
    end
    
    if ind(2) < hranice2 
        pocet = pocet + 1;
        D = [ind(1),ind(2)+1];
        help = [help;D];
    end
    
    if (pocet < 3)      % nejmene lze mit jen 2 sousedy (roh pole)
        help = [help;0 0;0 0];
    elseif (pocet < 4)  % kraj pole
        help = [help;0 0];
    end
    pocet_s = pocet;
    
    P = help;
end