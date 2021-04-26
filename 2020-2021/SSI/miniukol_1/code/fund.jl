MEANS = [0 0]
@time for n in 10:50
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
    x0 = Δ * (n - 1)
    X = reverse(Float64.(collect(0:Δ:x0)))
    V = zeros(n)                               # vektor počátečních rychlostí - zvoleno 0
    V[1] = v1(0)                                # přepočet pro v1 (závisí na funkci v1)
    t0 = 0                                      # počátek času
    h = 0.05                                    # časový krok
    iter = 2000
    xmax = x1(h*iter)
    ymax = v0 + A
    XX = X                                      # ukládání poloh
    VV = V                                      # ukládání rychlostí

    tok = []
    hustota = []
    rychlost = []
    Tmean = []
    Xmean = []

    # volba funkce optimální rychlosti
    v_opt = v_opt2

    # volba zrychlení: rozdílné nebo stejné
    rozdilne_zrychleni = false
    if rozdilne_zrychleni
        zrychleni = zrychleni_ruzne
    else
        zrychleni = zrychleni_stejne
    end

    while length(Tmean) < 1000
        scatter(X, ones(10), zcolor=1:10)
        global t1 = t0 + h

        # v t0 to bude vypadat takto
        Δ_x = diff(hcat(X[2:end], X[1:end - 1]), dims=2)
        prumer_x = mean(Δ_x)
        Δ_v = abs.(diff(hcat(V[2:end], V[1:end - 1]), dims=2))
        prumer_t = mean(Δ_x ./ Δ_v)
        if !isinf(prumer_t)
            Tmean = vcat(Tmean,prumer_t)
            Xmean = vcat(Xmean,prumer_x)
        end

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

    a = 1/mean(Tmean)
    b = 1/mean(Xmean)
    global MEANS = vcat(MEANS,[a b])
end

MEANS

J = MEANS[2:end,1]
ρ = MEANS[2:end,2]
ν = J ./ ρ

veliciny = hcat(J, ρ, ν) |> DataFrame
rename!(veliciny,[:tok,:hustota,:rychlost])
sort!(veliciny,:hustota)

scatter(veliciny[:hustota],veliciny[:tok])

plot(ρ,J,aspect_ration=:equal,xlabel=L"\rho",ylabel=L"J",label="")
plot(J,ν)
plot(ρ,ν)

