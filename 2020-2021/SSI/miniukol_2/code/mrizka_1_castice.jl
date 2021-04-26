## INICIALIZACE SKRIPTU A SIMULAČNÍCH KONSTANT
include("funkce.jl")
sim_time = []
ks = 1

## INICIALIZACE POLÍ, ČÁSTIC A PŘEKÁŽEK
n = 15
C = (1,10)   # souřadnice částice
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
plot_grid(pole, A)
heatmap(staticke_pole',axis=([],false),aspect_ratio=:equal,title="Heatmapa vzdálenosti od atraktoru")

hustota = zeros(n,n)

k = 0
animation = @animate for i in 1:1000
    plot_pole(pole, A,ks)
    global hustota = hustota .+ (pole .== 1)
    if sum(pole .== 1) == 0
        if k == 0
            global sim_time = vcat(sim_time,i)
            println("Simulation time: $(sim_time[end])")
        end
        global k += 1
        if k == 10
            break
        end
    end
end
gif(animation, "gifs/animace_1castice_ks=$ks.gif", fps=5)