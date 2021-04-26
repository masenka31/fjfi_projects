function v = v_opt4(x,v_max,da,db)
        v_help = zeros(1,length(x));
        aa = -0.000428631;
        bb = -35.6058;
        cc = 25.4233;
        for k = 1:length(x)
            if x(k) < da
                v_help(k) = 0;
            elseif da <= x(k) || x(k) <= db
                %a = v_max/(db^4-da^4);
                %b = -da^4*a;
                %v_help(k) = a*x(k)^4 + b;
                v_help(k) = aa * (x(k) + bb)^4 + cc;
            else
                v_help(k) = v_max;
            end
        end
        v = v_help;
    end