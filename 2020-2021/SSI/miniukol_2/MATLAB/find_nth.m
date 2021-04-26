function nth = find_nth(vector, number, n)
%   funkce hledajici index n-teho vyskytu cisla ve vektoru 
%   INPUTS:
%   vector  = vektor ve kterem hledame
%   number  = cislo ktere hledame ve vektoru
%   n       = poradi cisla number ve vektoru
    help = (vector(:) == number);
    help = cumsum(help);
    nth = min(find(help == n));
end
