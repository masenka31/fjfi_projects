## INICIALIZACE SKRIPTU A SIMULAČNÍCH KONSTANT
# ] activate "C:\\Users\\masen\\Disk Google\\SCHOOL\\2020-2021\\SSI\\miniukol_1\\SSI"
# ; cd code
include("funkce.jl")

function simulate(iter,ks)
    ## INICIALIZACE POLÍ, ČÁSTIC A PŘEKÁŽEK
    n = 10
    C = (1,10)   # souřadnice částice
    A = (11,5)  # souřadnice atraktoru
    sim_time = []

    for sim in 1:iter
        ## INICIALIZACE POLÍ, ČÁSTIC A PŘEKÁŽEK
        n = 15
        A = (n+1,8)  # souřadnice atraktoru

        staticke_pole = zeros(n, n)
        pole = zeros(n, n)

        # vytvoření překážek a přidání do polí
        souradnice_prekazek = CartesianIndex.(4,11:n)
        souradnice_prekazek = vcat(souradnice_prekazek,CartesianIndex.(4,1:5))
        souradnice_prekazek = vcat(souradnice_prekazek,CartesianIndex.(9,4:12))
        staticke_pole[souradnice_prekazek] .= -1
        pole[souradnice_prekazek] .= -1

        # přidání částic
        pole[1,n] = 1

        # výpočet statického pole a plot, jak to vypadá
        spocitej_S(staticke_pole, A)
        k = 0
        for i in 1:300
            plot_pole1(pole,A,ks)
            if sum(pole .== 1) == 0
                if k == 0
                    sim_time = vcat(sim_time,i)
                    #println(sim_time)
                    break
                end
            end
        end

    end
    return sim_time
end



time_by_ks = zeros(30,1)
@time for ks in collect(0.5:0.1:3)
    vec = simulate(30,ks)
    global time_by_ks = hcat(time_by_ks,vec)
end

mn = mean(time_by_ks[:,2:end],dims=1)
scatter(collect(0.5:0.1:3),mn',xlabel=L"k_S",ylabel=L"\mathbb{E}[t_e]",xlims=(0,4),ylims=(0,100),label="")

using BSON: @save, @load
@save  "data/mean_t_15x15.bson" mn
@load "data/mean_t_15x15.bson" mn

# fitting Least squares curve to data
using LsqFit
xdata = collect(0.5:0.1:3)
ydata = collect(mn')[:]

@. model(x,p) = p[1] + p[2]*exp(-p[3]*x)
p0 = [21.0, 0.5, 1.0]
fit = LsqFit.curve_fit(model,xdata,ydata,p0)
p = coef(fit)
f(x) = p[1] + p[2]*exp(-p[3]*x)

xline = 0.1:0.05:4
plot(label="")
scatter(collect(0.5:0.1:3),mn',xlabel=L"k_S",ylabel=L"\mathbb{E}[t_e]",xlims=(0,4),ylims=(0,100),label="")
plot(xline,f.(xline),label=L"30.4 + 247.2 \cdot \exp(-2.5x)",linewidth=2,legendfontsize=11)
scatter!(collect(0.5:0.1:3),mn',xlabel=L"k_S",ylabel=L"\mathbb{E}[t_e]",xlims=(0,4),ylims=(0,100),label="")