## LEADER ------------------------------------------------------------------
v1(t) = v0 .+ A .* sin.(B .* t)
x1(t) = v0 .* t .- A ./ B .* cos.(B .* t) .+ A / B .+ x0

# nějaké grafíky, jak vypadá rychlost, poloha v čase
tline = 1:0.1:100
vline = v1.(tline)
xline = x1.(tline)

t_vs_x = plot(tline, xline, xlabel="time [s]", ylabel="x [m]", label="x(t)")
x_vs_v = plot(xline, vline, xlabel="x [m]", ylabel="v [m/s]", label="v(x)")
t_vs_v = plot(tline, vline, xlabel="time [s]", ylabel="v [m/s]", label="v(t)")

## HEAVISIDE ---------------------------------------------------------------
function heaviside(x)
    if x > 0
        return 1
    else
        return 0
    end
end

## OPTIMÁLNÍ RYCHLOSTI -----------------------------------------------------
v_opt1(x) = v_max .* heaviside.(x .- d_safe)
v1p = plot(v_opt1,xlims=(0, 100),label=L"v_{opt}^1(x)",xlabel=L"\Delta x",ylabel="v",
    legend=:bottomright)

function v_opt2(x)
    if x < da
        return 0
    elseif da <= x <= db
        a = v_max / (db - da)
        b = -da * a
        return a * x + b
    else
        return v_max
    end
end

v2p = plot(v_opt2,xlims=(0, 100),label=L"v_{opt}^2(x)",xlabel=L"\Delta x",ylabel="v",
    legend=:bottomright)

v_opt3(x) = v_max / 2 * (tanh(x - d_safe) + tanh(d_safe))

v3p = plot(v_opt3,xlims=(0, 100),label=L"v_{opt}^2(x)",xlabel=L"\Delta x",ylabel="v",
    legend=:bottomright)

function v_opt4(x)
    if x < da
        return 0
    elseif da <= x <= db
        a = v_max / (db^2 - da^2)
        b = -da^2 * a
        return a * x^2 + b
    else
        return v_max
    end
end

v4p = plot(v_opt4,xlims=(0, 100),label=L"v_{opt}^2(x)",xlabel=L"\Delta x",ylabel="v",
    legend=:bottomright)


function vopt_new(x)
    if x < da
        return 0
    elseif da <= x <= db
        return aa * (x + bb)^4 + cc
    else
        return v_max
    end
end 
    
aa = -0.000428631
bb = -35.6058
cc = 25.4233


da = 20
db = 30
xp = 0:0.1:100
plot(xp,v_opt1.(xp),xlims=(0, 100),label=L"v_{opt}^1(x)",xlabel=L"\Delta x \; [m]",ylabel=L"v \; [m/s]",legend=:bottomright);
plot!(xp,v_opt2.(xp),label=L"v_{opt}^2(x)");
plot!(xp,vopt_new.(xp),label=L"v_{opt}^3(x)",xlims=(15, 35));
plot!(xp,v_opt3.(xp),label=L"v_{opt}^4(x)")
savefig("plots/opt_funkce.pdf")
#plot!(xp,vopt_new.(xp))

# ZRYCHLENÍ -----------------------------------------------------------------
# Sa stejné pro všechny auta
function zrychleni_stejne(v0, va)
    Sa .* (v0 .- va)
end
# Sa různé pro všechny auta
function zrychleni_ruzne(v0, va)
    Sav .* (v0 .- va)
end


## EULEROVA METODA ---------------------------------------------------------
# obecný předpis
function euler(x, v, a)
    v_new = v .+ h .* a
    v_new = relu.(v_new)
    x_new = x .+ h .* v
    return x_new, v_new
end