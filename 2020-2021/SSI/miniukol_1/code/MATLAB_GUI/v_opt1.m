function v = v_opt1(x, v_max, d_safe)
    m = length(x);
    v_help = zeros(1,m);
    for j = 1:m
        v_help(j) = v_max * heaviside(x(j) - d_safe);
    end
    v = v_help;
    end
