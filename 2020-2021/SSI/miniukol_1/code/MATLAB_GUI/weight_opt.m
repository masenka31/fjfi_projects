function w = weight_opt(delta_x,delta_v)
    % INPUT:
    %   delta_x...vzdalenosti mezi vozidly
    %   delta_v...rozdily mezi rychlostmi vozidel
    % OUTPUT:
    %   w...vaha optimalni rychlosti
        B = 5;
        C = 1/2;
        w = 1/2 .* (1 + tanh(B .* (delta_v ./ delta_x + C)));
    end