TOK = []
RYCHLOST = []

# volba funkce optimální rychlosti
v_opt = vopt_new

# volba zrychlení: rozdílné nebo stejné
rozdilne_zrychleni = false
if rozdilne_zrychleni
    zrychleni = zrychleni_ruzne
else
    zrychleni = zrychleni_stejne
end

## GLOBAL VARIABLES ---------------------------------------------------------
Sa = 4
Sav = rand(Uniform(1, 5), n - 1)
v_max = 25
d_safe = 25
da = d_safe-5
db = da * 2
v0 = 15
A = 10
B = 0.5
    
@time for n in 2:100


    ## INICIALIZACE
    X = zeros(n)                                # všechny vozidla startují z 0
    V = zeros(n)                                # vektor počátečních rychlostí - zvoleno 0
    V[1] = v1(0)                                # přepočet pro v1 (závisí na funkci v1)
    t0 = 0                                      # počátek času
    h = 0.03                                    # časový krok
    D = 250 # poloha detektoru
    TIME = []
    VELOCITY = []

    index = 1
    while X[end] < D + 10
        t1 = t0 + h
        # v t0 to bude vypadat takto
        Δ_x = diff(hcat(X[2:end], X[1:end - 1]), dims=2)

        if index <= n
            if X[index] > D
                TIME = vcat(TIME, t0)
                VELOCITY = vcat(VELOCITY, V[index])
                index = index + 1
            end
        end

        vopt = v_opt.(Δ_x)
        a_α = zrychleni(vopt, V[2:end])

        # přechod k t1
        Xn, Vn = euler(X[2:end], V[2:end], a_α)
        X[2:end] = Xn
        V[2:end] = Vn
        X[1] = x1(t1)
        V[1] = v1(t1)
        t0 = t1
    end

    println("$n: $t0")

    Δt = diff(hcat(TIME[1:end - 1], TIME[2:end]), dims=2)
    _Δt_ = mean(Δt)
    tok = 1 / _Δt_
    _Δv_ = mean(VELOCITY)
    global TOK = vcat(TOK, tok)
    global RYCHLOST = vcat(RYCHLOST, _Δv_)
end

id = 3
# RYCHLOST = 1 ./ RYCHLOST
scatter(RYCHLOST,TOK,zcolor=2:100,xlabel=L"\Delta v [m/s]",ylabel="J [car/s]",label="")
savefig("plots/FD_VJ_vopt$id.pdf")
HUSTOTA = TOK ./ RYCHLOST
scatter(HUSTOTA,TOK,zcolor=2:100,xlabel=L"\rho [car/m]",ylabel="J [car/s]",label="")
savefig("plots/FD_RJ_vopt$id.pdf")
scatter(HUSTOTA,RYCHLOST,zcolor=2:100,xlabel=L"\rho [car/m]",ylabel=L"\Delta v [m/s]",label="")
savefig("plots/FD_RV_vopt$id.pdf")

using BSON: @save, @load
@save "saved_data/vopt$id.bson" TOK RYCHLOST HUSTOTA
@load "saved_data/vopt$id.bson" TOK RYCHLOST HUSTOTA

hcat(TOK[end],RYCHLOST[end],HUSTOTA[end])