function v = v_opt3(x,v_max,d_safe)
        v = v_max / 2 .* (tanh(x - d_safe) + tanh(d_safe));
    end