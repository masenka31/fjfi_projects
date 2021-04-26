function v = v_opt2(x,v_max,da,db)
    v_help = zeros(1,length(x));
        for k = 1:length(x)
            if x(k) < da
                v_help(k) = 0;
            elseif da <= x(k) || x(k) <= db
                a = v_max/(db-da);
                b = -da*a;
                v_help(k) = a*x(k) + b;
            else
                v_help(k) = v_max;
            end
        end
        v = v_help;
    end