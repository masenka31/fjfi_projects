## INICIALIZACE SKRIPTU A SIMULAČNÍCH KONSTANT
include("funkce.jl")
sim_time = []
ks = 0

## INICIALIZACE POLÍ, ČÁSTIC A PŘEKÁŽEK
n = 15
C = (1,10)   # souřadnice částice
A = (n+1,8)  # souřadnice atraktoru

staticke_pole = zeros(n, n)
pole = zeros(n, n)

# přidání částic
pole[1,1:n] .= 1

# výpočet statického pole a plot, jak to vypadá
spocitej_S(staticke_pole, A)
plot_grid(pole, A)
# heatmap
# heatmap(staticke_pole',axis=([],false),aspect_ratio=:equal,title="Heatmapa vzdálenosti od atraktoru")
# savefig("plots/stat_pole_bezprekazek.pdf")

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
gif(animation, "gifs/animace_bezprekazek_ks=$ks.gif", fps=5)

hustotaT = hustota ./ 1000
heatmap(hustotaT',axis=([],false),aspect_ratio=:equal,color=:jet)
savefig("plots/heatmap_bezprekazek_ks=$ks.pdf")