## INICIALIZACE SKRIPTU A SIMULAČNÍCH KONSTANT
# ] activate "C:\\Users\\masen\\Disk Google\\SCHOOL\\2020-2021\\SSI\\miniukol_1\\SSI"
# ; cd code
include("funkce.jl")

function simulate(iter,ks)
    ## INICIALIZACE POLÍ, ČÁSTIC A PŘEKÁŽEK
    n = 5
    C = CartesianIndex(1,1)   # souřadnice částice
    A = (6,5)  # souřadnice atraktoru
    sim_time = []

    for sim in 1:iter
        staticke_pole = zeros(n, n)
        pole = zeros(n, n)

        # vytvoření překážek a přidání do polí
        souradnice_prekazek = CartesianIndex(3,2)
        souradnice_prekazek = vcat(souradnice_prekazek,CartesianIndex(3,3))
        souradnice_prekazek = vcat(souradnice_prekazek,CartesianIndex(2,3))
        staticke_pole[souradnice_prekazek] .= -1
        pole[souradnice_prekazek] .= -1

        # přidání částic
        pole[C] = 1

        # výpočet statického pole
        spocitej_S(staticke_pole, A)

        i = 0
        while sum(pole .== 1) != 0
            plot_pole1(pole,A,ks)
            i += 1
            if sum(pole .== 1) == 0
                sim_time = vcat(sim_time,i)
                #println(i)
                break
            end
        end

    end
    return sim_time
end

using ProgressMeter
ks_vec = vcat([0.001,0.005,0.01,.05],0.1:0.1:3)
time_by_ks = zeros(30,1)
@showprogress 1 "ks: " for ks in ks_vec
    vec = simulate(30,ks)
    global time_by_ks = hcat(time_by_ks,vec)
end

T = time_by_ks[:,2:end]
mat = mean(T,dims=1)
scatter(ks_vec,mat')

# uložení dat
using BSON: @save, @load
@save  "data/mean_t_5x5.bson" mat
@load "data/mean_t_5x5.bson" mat

# Nafitování dat exponencielou
using LsqFit
xdata = ks_vec
ydata = collect(mat')[:]

@. model(x,p) = p[1] + p[2]*exp(-p[3]*x)
p0 = [21.0, 0.5, 1.0]
fit = LsqFit.curve_fit(model,xdata,ydata,p0)
p = coef(fit)
f(x) = p[1] + p[2]*exp(-p[3]*x)

using LaTeXStrings
xline = 0:0.05:4
plot(xline,f.(xline),label=L"11.2 + 84 \cdot \exp(-3.9x)",linewidth=2,legendfontsize=11)
scatter!(ks_vec,mat',xlabel=L"k_S",ylabel=L"\mathbb{E}[t_e]",xlims=(0,4),ylims=(0,100),label="")