include("funkce.jl")
include("matice_P_funkce.jl")

##################################################
###### INICIALIZACE POLÍ, ČÁSTIC A PŘEKÁŽEK ######
##################################################

n = 5
C = CartesianIndex(1,1)   # souřadnice částice
A = (6,5)  # souřadnice atraktoru

pole_bezcastic = zeros(5,5)
pole_bezcastic[souradnice_prekazek] .= 1
pole_bezcastic[5,5] = 1

################################################################
###### Výpočet matice přechodu a střední doby do absorpce ######
################################################################

# vybírám políčko 9 neboli stav (4,2)

# výpočet teoretické hustoty v buňce
function teoreticka_hustota(tmax, ks)
    staticke_pole = zeros(n, n)
    pole = zeros(n, n)
    
    # vytvoření překážek a přidání do polí
    souradnice_prekazek = CartesianIndex(3,2)
    souradnice_prekazek = vcat(souradnice_prekazek,CartesianIndex(3,3))
    souradnice_prekazek = vcat(souradnice_prekazek,CartesianIndex(2,3))
    staticke_pole[souradnice_prekazek] .= -1
    pole[souradnice_prekazek] .= -1
    
    # přidání částice
    pole[C] = 1
    
    # výpočet statického pole a plot, jak to vypadá
    spocitej_S(staticke_pole, A)
        
    P = matice_prechodu(pole_bezcastic, staticke_pole, ks)
    heatmap(reverse(P,dims=1),aspect_ratio=:equal,size=(500,500))

    q0 = zeros(25)
    q0[1] = 1

    q = deepcopy(q0')
    for t in 1:tmax
        q = q * P
    end
    # vrátí průměrnou hustotu buňky
    return q[9]
end

# simulace hustoty v buňce
function simulace_hustoty(tmax, ks, iter)
    hustota_bunky = []
    @showprogress 1 "Simulace t=$tmax: " for i in 1:iter    
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

        # výpočet statického pole a plot, jak to vypadá
        spocitej_S(staticke_pole, A)
        p0 = deepcopy(pole)

        for t in 1:tmax
            if sum(pole) != -3
                plot_pole1(pole,A,ks)
                p0 = p0 .+ pole
            else
                p0[5,5] += 1
            end
        end
        hustota_pole = p0 ./ tmax
        hb = hustota_pole[4,2]
        hustota_bunky = vcat(hustota_bunky,hb)
    end
    # vrátí průměrnou hustotu vybrané buňky za čas tmax
    return mean(hustota_bunky)
end

###################################################
###### Provedení simulace, plot, uložení dat ######
###################################################

ks = 0
tvec = 1:50
@time h_teor = [teoreticka_hustota(t, ks) for t in tvec]
@time h_sim = [simulace_hustoty(t, ks, 50) for t in tvec]

@save "data/h_teor_ks=$ks.bson" h_teor
@save "data/h_sim_ks=$ks.bson" h_sim

plot(h_teor,marker=:square,markersize=2,color=:blue,label="teorie",ylims=(-0.009,1))
plot!(h_sim,marker=:circle,markersize=3,color=:green,label="simulace",xlabel=L"t",ylabel=L"p")

savefig("plots/hustota_ks=$ks.pdf")