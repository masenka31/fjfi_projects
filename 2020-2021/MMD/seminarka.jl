#######################
### Načtení balíčků ###
#######################

# konflikt mezi verzemi nepravděpodobný
# using DrWatson
using DataFrames
using Plots
using SpecialFunctions
using StatsBase
# using LaTeXStrings
using Distributions
using ProgressMeter
using HypothesisTests

# načtení funkcí ze skriptu funkce.jl
# třeba modifikovat pro vlastní spuštění
include("C:\\Users\\masen\\Desktop\\package_testing\\scripts\\MMD\\funkce.jl")

#####################################################
### Vizualizace GIG rozdělení, náhodné generování ###
#####################################################

### vizualizace
# parametry GIGu a pomocná funkce
α = 0
β = 1.65
GIG(x) = gig(x, α, β)

# graf distribuce
xline = -1:0.02:5
yline = GIG(xline)
plot(xline, yline)
# plot!(xline, yline)

### náhodné generování
# parametry, váhy
xline = 0:0.0001:5
w = GIG(xline)
ww = ProbabilityWeights(w)

# jednochuchá funkce pro generování n vzorků
# generuje vektor, proto pro n = 1 bereme první prvek, abychom dostali číslo
gig_rand(n) = n == 1 ? sample(xline, ww, n)[1] : sample(xline, ww, n)

# ukázka toho, že generované vzorky odpovídají rozdělení
x = 0:0.02:5
y = GIG(x)
s = gig_rand(100000)
histogram(s,normalized=true, label="generované vzorky");
plot!(x,y,lw=3, label="g(x), α = 0, β = 1.65")

######################
###### Simulace ######
######################

# x - rozestupy vozidel na hlavní komunikaci
# y - rozestupy všech vozidel (společně s těmi, které se připojily z vedlejší komunikace)

# funkce, která přidá prvek y do vektoru x na pozici i+1
push_in(x, y, i) = vcat(x[1:i], y, x[i+1:end])

### simulace 1) ---------------------------------------------------------------
proc, X, Y = simulate(20,p1)
i_mm = findall(x -> x == minimum(proc) || x == maximum(proc),proc)
proc[i_mm]

x1,y1 = X[i_mm[1]], Y[i_mm[1]]
ApproximateTwoSampleKSTest(x1,y1)

histogram(x1,opacity=0.5,normalized=true,nbins=70,xlims=(-0.2,4),label="x");
histogram!(y1, opacity=0.5,normalized=true,nbins=70,label="x'")

x2,y2 = X[i_mm[2]], Y[i_mm[2]]
ApproximateTwoSampleKSTest(x2,y2)

histogram(x2,opacity=0.5,normalized=true,nbins=70,xlims=(-0.2,4),label="x");
histogram!(y2, opacity=0.5,normalized=true,nbins=70,label="x'")

#### simulace 2) ---------------------------------------------------------------
proc, X, Y = simulate(20,p2)
i_mm = findall(x -> x == minimum(proc) || x == maximum(proc),proc)
proc[i_mm]

x1,y1 = X[i_mm[1]], Y[i_mm[1]]
ApproximateTwoSampleKSTest(x1,y1)

histogram(x1,opacity=0.5,normalized=true,nbins=70,xlims=(-0.2,4),label="x");
histogram!(y1, opacity=0.5,normalized=true,nbins=70,label="x'")

x2,y2 = X[i_mm[2]], Y[i_mm[2]]
ApproximateTwoSampleKSTest(x2,y2)

histogram(x2,opacity=0.5,normalized=true,nbins=70,xlims=(-0.2,4),label="x");
histogram!(y2, opacity=0.5,normalized=true,nbins=70,label="x'")

# simulace 3) -------------------------------------------------------------------

proc, X, Y = simulate(20,p3)
i_mm = findall(x -> x == minimum(proc) || x == maximum(proc),proc)
proc[i_mm]

x1,y1 = X[i_mm[1]], Y[i_mm[1]]
ApproximateTwoSampleKSTest(x1,y1)

histogram(x1,opacity=0.5,normalized=true,nbins=70,xlims=(-0.2,4),label="x");
histogram!(y1, opacity=0.5,normalized=true,nbins=70,label="x'")

x2,y2 = X[i_mm[2]], Y[i_mm[2]]
ApproximateTwoSampleKSTest(x2,y2)

histogram(x2,opacity=0.5,normalized=true,nbins=70,xlims=(-0.2,4),label="x");
histogram!(y2, opacity=0.5,normalized=true,nbins=70,label="x'")

# -------------------------------------------------------------------------------

####################################
### Ilustrace rozestupů (Obr. 1) ###
####################################

pred_x = [0,3,4,5,10,11,13,17]

scatter(pred_x, zeros(length(pred_x)), axis=([], false), label="",
        aspect_ratio=:equal, markersize=10, markerstrokewidth=10,
        size=(600,100))
scatter!([6],[0], markersize=10, size=(600,100), label="", markerstrokewidth=10)