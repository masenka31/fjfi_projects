HUSTOTA = []
for n in 11:100
    ## GLOBAL VARIABLES ---------------------------------------------------------
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
    x0 = 0
    X = zeros(n)
    V = zeros(n)                               # vektor počátečních rychlostí - zvoleno 0
    V[1] = v1(0)                                # přepočet pro v1 (závisí na funkci v1)
    t0 = 0                                      # počátek času
    h = 0.03                                    # časový krok
    iter = 2000
    xmax = x1(h*iter)
    ymax = v0 + A
    XX = X                                      # ukládání poloh
    VV = V                                      # ukládání rychlostí

    D = 300 # poloha detektoru
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

    while t0 < 200
        t1 = t0 + h

        # v t0 to bude vypadat takto
        Δ_x = diff(hcat(X[2:end], X[1:end - 1]), dims=2)

        vopt = v_opt.(Δ_x)
        a_α = zrychleni(vopt, V[2:end])

        # přechod k t1
        Xn, Vn = euler(X[2:end], V[2:end], a_α)
        X[2:end] = Xn
        V[2:end] = Vn
        X[1] = x1(t1)
        V[1] = v1(t1)

        # posunutí času a uložení výsledků
        t0 = t1
        XX = hcat(XX,X)
        VV = hcat(VV,V)
    end

    Δx = diff(hcat(X[2:end], X[1:end - 1]), dims=2)
    _Δx_ = mean(Δx)
    hustota = 1/_Δx_
    global HUSTOTA = vcat(HUSTOTA, hustota)
end

plot(2:100,HUSTOTA)

scatter(HUSTOTA, TOK, xlabel=L"\rho", ylabel=L"J",label="")