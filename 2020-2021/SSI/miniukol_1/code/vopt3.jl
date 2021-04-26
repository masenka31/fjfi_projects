# Inicializace ještě jednou...
n = 10 # počet vozidel
Δ = 5 # počáteční rozestup mezi vozidly
x0 = Δ * (n - 1)
X = reverse(Float64.(collect(0:Δ:x0)))
V = zeros(10) # vektor počátečních rychlostí - zvoleno 0
V[1] = v1(0) # přepočet pro v1 (závisí na funkci v1)
t0 = 0
h = 0.05
XX = X
VV = V

# LOOP ----------------------------------------------------------------------
for i in 1:500
    scatter(X, ones(10), zcolor=1:10)
    global t1 = t0 + h

    # v t0 to bude vypadat takto
    Δ_x = diff(hcat(X[2:end], X[1:end - 1]), dims=2)
    vopt = v_opt3.(Δ_x)
    a_α = zrychleni2(vopt, V[2:end])

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

# výsledný grafík a uložení
plot(XX',label="",size=(800,600),xlabel="iter",ylabel="x")


## ANIMATION ---------------------------------------------------------
animation = @gif for i in 1:500
    global t1 = t0 + h

    # v t0 to bude vypadat takto
    Δ_x = diff(hcat(X[2:end], X[1:end - 1]), dims=2)
    vopt = v_opt3.(Δ_x)
    a_α = zrychleni2(vopt, V[2:end])

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
    bplot = bar(X,V,bar_width=0.2,xlims = (0,500),ylims=(0,27),label="",
    xlabel="x [m]", ylabel="v [m/s]", size=(600,300));
    splot = scatter(X,zeros(n),size=(600,300),label="",ylims=(-0.1,0.1),xlims=(0,500));
    plot(layout=(2,1),bplot, splot, size=(600,600))
end