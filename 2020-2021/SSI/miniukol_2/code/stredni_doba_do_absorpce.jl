include("funkce.jl")
include("matice_P_funkce.jl")

##################################################
###### INICIALIZACE POLÍ, ČÁSTIC A PŘEKÁŽEK ######
##################################################

n = 5
C = CartesianIndex(1,1)   # souřadnice částice
A = (6,5)  # souřadnice atraktoru

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
plot_grid(pole, A)

pole_bezcastic = zeros(5,5)
pole_bezcastic[souradnice_prekazek] .= 1
pole_bezcastic[5,5] = 1

################################################################
###### Výpočet matice přechodu a střední doby do absorpce ######
################################################################

ks = 0.5
P = matice_prechodu(pole_bezcastic, staticke_pole, ks)
heatmap(reverse(P,dims=1),aspect_ratio=:equal,size=(500,500))
P_new = reshape_P(P)

heatmap(reverse(P_new,dims=1),aspect_ratio=:equal,size=(500,500))
mat_vec, mat_mat = mean_abs_time(P_new)

Et = mat_vec[1]
heatmap(mat_mat,aspect_ratio=:equal,size=(500,500))

##############################################################################
###### Výpočet matice přechodu a střední doby do absorpce pro různá k_S ######
##############################################################################


using ProgressMeter
ks_vec = vcat([0.001,0.005,0.01,.05],0.1:0.1:3)
Et_vec = meanT.(ks_vec)

# Nafitování dat exponencielou
using LsqFit
xdata = ks_vec
ydata = Et_vec

@. model(x,p) = p[1] + p[2]*exp(-p[3]*x)
p0 = [21.0, 0.5, 1.0]
fit = LsqFit.curve_fit(model,xdata,ydata,p0)
p = coef(fit)
f(x) = p[1] + p[2]*exp(-p[3]*x)

plot(
    ks_vec,Et_vec,marker=:square,color=:blue,
    xlabel=L"k_S",ylabel=L"\mathbb{E}[t_e]",
    label=L"\mathrm{teorie}",
    legendfontsize=11, markersize=2.5,
    xlims=(-0.2,3.5),ylims=(0,100)
)
scatter!(ks_vec,mat',label=L"\mathrm{simulace}",color=:green,markersize=3)
plot!(xline,f.(xline),label=L"y = 11.2 + 84\exp(-3.9x)", linewidth=2,color=:green)