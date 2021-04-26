## GLOBAL VARIABLES ---------------------------------------------------------
n = 50                                     # počet vozidel
Sa = 4
Sav = rand(Uniform(1,5),n-1)
v_max = 25
d_safe = 25
da = d_safe
db = da*2
v0 = 15
A = 10
B = 0.5

## INICIALIZACE
Δ = 5                                       # počáteční rozestup mezi vozidly
x0 = Δ * (n - 1)
X = reverse(Float64.(collect(0:Δ:x0)))
V = zeros(n)                               # vektor počátečních rychlostí - zvoleno 0
V[1] = v1(0)                                # přepočet pro v1 (závisí na funkci v1)
t0 = 0                                      # počátek času
h = 0.01                                    # časový krok
iter = 2000
xmax = x1(h*iter)
ymax = v0 + A
XX = X                                      # ukládání poloh
VV = V                                      # ukládání rychlostí

D = 200 # poloha detektoru
TIME = []

# volba funkce optimální rychlosti
v_opt = v_opt3

# volba zrychlení: rozdílné nebo stejné
rozdilne_zrychleni = false
if rozdilne_zrychleni
    zrychleni = zrychleni_ruzne
else
    zrychleni = zrychleni_stejne
end

index = 1

while X[end] < 300
    global t1 = t0 + h

    # v t0 to bude vypadat takto
    Δ_x = diff(hcat(X[2:end], X[1:end - 1]), dims=2)
    prumer_x = mean(Δ_x)
    Δ_v = abs.(diff(hcat(V[2:end], V[1:end - 1]), dims=2))
    prumer_t = mean(Δ_x ./ Δ_v)

    if index <=n
        if X[index] > D
            global TIME = vcat(TIME, t0)
            global index = index + 1
        end
    end

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

Δt = diff(hcat(TIME[1:end - 1],TIME[2:end]), dims=2)
_Δt_ = mean(Δt)

tok = 1/_Δt_