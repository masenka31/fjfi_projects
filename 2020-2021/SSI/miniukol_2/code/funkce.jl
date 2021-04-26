# Nejdříve budeme chtít vytvořit pole mřížky, na které budeme počítat příslušné věci.
# ] activate "C:\\Users\\masen\\Disk Google\\SCHOOL\\2020-2021\\SSI\\miniukol_1\\SSI"
using Plots
using Distributions
using Statistics

"""
Základní funkce pro simulaci pohybu částic na 2D mřížce s překážkami.
- mřížka se pevně daná jako čtvercová s rozměry n*n
- *pole* určuje, kde se nachází částice a kde překážky
- *staticke_pole* v sobě uchovává pozici překážek a ve zbývajících políčkách
  je vzdálenost od atraktoru podle dist(x,y) = |x1-x2| + |y1-y2|
- A je atraktor a má souřadnice (x,y), jedna z jeho souřadnic musí být nutně n+1, druhá pak z intervalu (1,n)

Kódování *pole*
1 - v buňce je částice
-1 - v buňce je překážka
0 - buňka je prázdná
"""



"""
Důležité je umět spočítat statické pole. Proto potřebujeme metriku dist(b1,b2),
což je vzdálenost buňky b1 od b2.

Následně definujeme funkci neumann_okoli(b1,b2), která vyhodí true/false, podle
toho, jestli jsou buňky b1 a b2 v Neumannově okolí nebo ne.
"""
# b je buňka, resp. její souřadnice
function dist(b1, b2)
    x1, y1 = b1
    x2, y2 = b2
    abs(x1 - x2) + abs(y1 - y2)
end

function neumann_okoli(b1, b2)
    dist(b1, b2) == 1
end

# TEST
b1 = (3, 2)
b2 = (3, 3)
b3 = (4, 3)

dist(b1,b1)
dist(b1,b3)
dist(b1,b2)


"""
Teď potřebuji funkci, která mi spočítá statické pole - tedy mi vyplní nulové buňky statického
pole vzdáleností od atraktoru.

- Funkce dist_pole(pole,b) mi vrátí souřadnice těch buněk, které jsou v okolí buňky b.
(Indexování jde zleva a zeshora.)
- Funkce update_pole(pole,b,max_value) přidá +1 do každé buňky v poli, která je v okolí
buňky b a není v ní překážka.
- Nakonec funkce spocitej_S(pole,atraktor) mi přes for cyklus spočítá a doplní statické
pole vzdálenostmi od atraktoru.
"""

function dist_pole(pole, b)
    max_value = maximum(pole)
    tmp = zeros(n, n)
    for x in 1:n
        for y in 1:n
            if neumann_okoli((x, y), b) && (pole[x,y] == 0)
                tmp[x,y] = 1
            end
        end
    end
    mask = tmp .== 1
end

function update_pole(pole, b, max_value)
    mask = dist_pole(pole, b)
    pole[mask] .= max_value + 1
    return pole
end

function spocitej_S(pole, atraktor)
    max_value = maximum(pole)
    update_pole(pole, atraktor, max_value)
    while sum(pole .== 0) > 0
        max_value = maximum(pole)
        indexes = findall(x -> x == max_value, pole)

        for b in Tuple.(indexes)
            update_pole(pole, b, max_value)
        end
    end
end

"""
Dále budeme potřebovat funkci, která nám vizualizuje výsledek. K tomu slouží funkce
plot_grid, která vykreslí mřížku, ve které jsou červené buňky překážky, žlutá buňka
představuje atraktor a modrá tečka pak částici.

Je třeba si uvědomit, že scatterplot má souřadnice zleva doprava a zdola nahoru,
zatímco matice se indexují zleva doprava a shora dolů. Pole vstupující do plot funkce
tak musí být orotováno o 90°.
"""
function plot_grid(pole, atraktor)
        index_free = findall(x -> x == 0, pole)
        index_obstacle = findall(x -> x == -1, pole)
        index_castice = findall(x -> x == 1, pole)
        n = size(pole, 1)

        p = plot(title="Mřížka s překážkami, částicemi a atraktorem", legend=:none,
                    xlims=(-0.5, n + 1.5), ylims=(-0.5, n + 1.5), aspect_ratio=:equal,
                    axis=([],false),size=(600,600))
        p = scatter!([atraktor[1]], [atraktor[2]], color=:white, markersize=250 / (n + 2), markershape=:square)
        p = scatter!([atraktor[1]], [atraktor[2]], color=:yellow, markersize=250 / (n + 2), markershape=:square)
        # plot mřížky
        for idx in index_free
            p = scatter!([idx[1]], [idx[2]], color=:white, markersize=250 / (n + 2), markershape=:square)
        end
        # plot překážek
        for idx in index_obstacle
            p = scatter!([idx[1]], [idx[2]], color=:red, markersize=250 / (n + 2), markershape=:square)
        end
        # plot částic
        for idx in index_castice
            p = scatter!([idx[1]], [idx[2]], color=:white, markersize=250 / (n + 2), markershape=:square)
            p = scatter!([idx[1]], [idx[2]], color=:blue, markersize=100 / (n + 2))
        end
        return p
end



"""
Poslední z funkcí mi v každém kroku spočítá, jak (a jestli) částice skočí
na další políčko a případně které. Konstanta ks je defaultně nastavena na 0,
ale její hodnotu lze změnit.
"""

# funkce pro přeskok, jestliže probíhá simulace
# pouze pro jednu částici
function preskok1(pole,ks)
    b_idx = findall(x -> x == 1, pole)[1]                   # vrátí mi index částice
    mask = dist_pole(pole, Tuple(b_idx))                    # vytvoří mi masku nad těmito políčky
    vec_S = staticke_pole[mask]                             # dostanu vzdálenosti od atraktoru ve vybraných políčkách
    idx_mask = findall(x -> x == 1, mask)                   # souřadnice těchto políček
    idx_mask = vcat(idx_mask, b_idx)                        # plus přidaná souřadnice políčka, ve kterém se právě nacházím
    vec_S = vcat(vec_S, staticke_pole[b_idx])               # společně
    
    jmenovatel = sum(exp.(.- vec_S .* ks))
    P_ks = exp.(.- vec_S * ks) ./ jmenovatel
    idx = rand(Categorical(P_ks))                           # a náhodně vyberu s pravděpodobnostním vektorem
    idx_skok = idx_mask[idx]                                # nakonec získám souřadnice buňky, kam mi částice skočí a "provedu skok"
    pole[b_idx] = 0
    pole[idx_skok] = 1
end

"""
Funkce pro přeskok více částic.

Částice mají určitou míru významnosti. Update probíhá
iterativně, aby nebylo nutné řešit konflikty, kdy by
mělo více částic přeskakovat do stejného pole.

Indexování je dáno podle toho, kde na mřížce se nacházejí.
"""
function preskok(pole,ks)
    point_indexes = findall(x -> x == 1,pole)               # vrátí mi indexy všech částic v poli
    for idx in point_indexes
        mask = dist_pole(pole, Tuple(idx))                    # vytvoří mi masku nad těmito políčky
        vec_S = staticke_pole[mask]                             # dostanu vzdálenosti od atraktoru ve vybraných políčkách
        idx_mask = findall(x -> x == 1, mask)                   # souřadnice těchto políček
        idx_mask = vcat(idx_mask, idx)                        # plus přidaná souřadnice políčka, ve kterém se právě nacházím
        vec_S = vcat(vec_S, staticke_pole[idx])               # společně
        
        jmenovatel = sum(exp.(.- vec_S .* ks))
        P_ks = exp.(.- vec_S * ks) ./ jmenovatel
        idx_new = rand(Categorical(P_ks))                           # a náhodně vyberu s pravděpodobnostním vektorem
        idx_skok = idx_mask[idx_new]                                # nakonec získám souřadnice buňky, kam mi částice skočí a "provedu skok"
        pole[idx] = 0
        pole[idx_skok] = 1
    end
end

# pro jednu částici
function plot_pole1(pole, A, ks)
    if sum(pole .== 1) != 0
        castice_idx = findall(x -> x == 1, pole)[1]
        if dist(A, Tuple(castice_idx)) == 1
            pole[castice_idx] = 0
            p = plot_grid2(pole, A)
        return p
        else
            preskok1(pole,ks)
            p = plot_grid(pole, A)
        end
    else
        p = plot_grid2(pole, A)
    end
    return p
end

# pro více částic
function plot_pole(pole, A, ks)
    if sum(pole .== 1) != 0
        castice_idx = findall(x -> x == 1, pole)
        for idx in castice_idx
            if dist(A, Tuple(idx)) == 1
                pole[idx] = 0
                #p = plot_grid2(pole, A)
                #return p
            end
        end
        
        preskok(pole,ks)
        p = plot_grid(pole, A)
        return p

    else
        p = plot_grid2(pole, A)
    end
    return p
end

function plot_grid2(pole, A)
    p = plot_grid(pole, A)
    p = scatter!([A[1]], [A[2]], color=:blue, markersize=50 / (n + 2))
end

# není potřeba, protože to funguje i pro ks = 0
function _preskok(pole)
    b_idx = findall(x -> x == 1, pole)[1]              # vrátí index políčka, ve kterých jsou částice
    mask = dist_pole(pole, Tuple(b_idx))               # vytvoří mi masku nad těmito políčky
    vec_S = staticke_pole[mask]                        # dostanu vzdálenosti od atraktoru ve vybraných políčkách
    idx_mask = findall(x -> x == 1, mask)              # souřadnice těchto políček
    idx_mask = vcat(idx_mask, b_idx)                   # plus přidaná souřadnice políčka, ve kterém se právě nacházím
    vec_S = vcat(vec_S, staticke_pole[b_idx])          # společně
    
    # pokud ks = 0, je pravděpodobnost překoku stejná pro každé políčko
    P = 1 / sum(mask)                                  # a tedy je to 1/#políček
    idx = rand(Categorical(length(vec_S)))             # tady vyberu náhodný index se stejnou pravděpodobností pro všechny
    idx_skok = idx_mask[idx]                           # nakonec získám souřadnice buňky, kam mi částice skočí a "provedu skok"
    pole[b_idx] = 0
    pole[idx_skok] = 1
end


