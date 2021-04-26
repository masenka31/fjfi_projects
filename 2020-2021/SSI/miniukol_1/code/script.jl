## PACKAGES and FUNCTIONS
using Plots, StatsPlots
using Distributions
using Flux
using LaTeXStrings

## GLOBAL VARIABLES ---------------------------------------------------------
Sa = 1.5
Sav = rand(Uniform(1,5),9)
v_max = 25
d_safe = 25
da = d_safe-5
db = da*2
v0 = 15
A = 10
B = 0.5

## INICIALIZACE
n = 50                                      # počet vozidel
Δ = 5                                       # počáteční rozestup mezi vozidly
x0 = 0#Δ * (n - 1)
X = zeros(n) #reverse(Float64.(collect(0:Δ:x0)))
V = zeros(n)                               # vektor počátečních rychlostí - zvoleno 0
V[1] = v1(0)                                # přepočet pro v1 (závisí na funkci v1)
t0 = 0                                      # počátek času
h = 0.05                                    # časový krok
iter = 2000
xmax = x1(h*iter)
ymax = v0 + A
XX = X                                      # ukládání poloh
VV = V                                      # ukládání rychlostí
include("funkce.jl")

# volba funkce optimální rychlosti
v_opt = v_opt3

# volba zrychlení: rozdílné nebo stejné
rozdilne_zrychleni = false
if rozdilne_zrychleni
    zrychleni = zrychleni_ruzne
else
    zrychleni = zrychleni_stejne
end

# graf nebo animace?
animace = true
if animace
    animation = @animate for i in 1:iter
        global t1 = t0 + h

        # v t0 to bude vypadat takto
        Δ_x = diff(hcat(X[2:end], X[1:end - 1]), dims=2)
        vopt = v_opt.(Δ_x)
        a_α = zrychleni(vopt, V[2:end])

        # přechod k t1
        Xn, Vn = euler(X[2:end], V[2:end], a_α)
        global X[2:end] = Xn
        global V[2:end] = Vn
        global X[1] = x1(t1)
        global V[1] = v1(t1)

        # posunutí času a uložení výsledků
        global t0 = t1
        global XX = hcat(XX,X)
        global VV = hcat(VV,V)
        bplot = bar(X,V,bar_width=0.2,xlims = (0,xmax+10),ylims=(0,ymax+2),label="",
        xlabel="x [m]", ylabel="v [m/s]", size=(600,300));
        splot = scatter(X,zeros(n),size=(600,300),label="",ylims=(-0.1,0.1),xlims=(0,xmax+10));
        plot(layout=(2,1),bplot, splot, size=(600,600))
    end
    gif(animation, "gifs/$(v_opt)_Sa_$(Sa)_A=$(A)_B=$(B)_dsafe=$(d_safe)_vmax=($v_max).gif")
else
    for i in 1:iter
        scatter(X, ones(10), zcolor=1:10)
        global t1 = t0 + h

        # v t0 to bude vypadat takto
        Δ_x = diff(hcat(X[2:end], X[1:end - 1]), dims=2)
        vopt = v_opt.(Δ_x)
        a_α = zrychleni(vopt, V[2:end])

        # přechod k t1
        Xn, Vn = euler(X[2:end], V[2:end], a_α)
        global X[2:end] = Xn
        global V[2:end] = Vn
        global X[1] = x1(t1)
        global V[1] = v1(t1)

        # posunutí času a uložení výsledků
        global t0 = t1
        global XX = hcat(XX,X)
        global VV = hcat(VV,V)
    end
    plot(XX',label="",size=(800,600),xlabel="iter",ylabel="x")
end

id = 3
plot(0:0.05:h*iter,XX',size=(800,600),xlabel="t [s]",ylabel="x [m]",label="")
savefig("plots/trajektorie_$id.pdf")
0.05*1000