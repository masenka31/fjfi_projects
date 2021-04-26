using LinearAlgebra

############ Matice přechodu ############
function matice_prechodu(pole_bezcastic, staticke_pole, ks)
    # inicializace prázdné matice přechodu
    P = zeros(n*n,n*n)
    i = 1
    # smyčka pro výpočet jednotlivých řádků P
    for b_idx in findall(x -> x == 1, ones(5,5))
        # pokud překážka nebo atraktor
        if pole_bezcastic[b_idx] == 1
            pravd_prechodu = zeros(5,5)
            pravd_prechodu[b_idx] = 1

            pvec = reshape(pravd_prechodu,1,:)
            P[i,:] .= pvec[:]
        # pokud klasické pole
        else
            mask = dist_pole(pole, Tuple(b_idx))                    
            mask[b_idx] = 1                                         
            vec_S = staticke_pole[mask]                             
            idx_mask = findall(x -> x == 1, mask)                   
            
            jmenovatel = sum(exp.(.- vec_S .* ks))
            P_ks = exp.(.- vec_S * ks) ./ jmenovatel

            pravd_prechodu = zeros(5,5)
            pravd_prechodu[idx_mask] .= P_ks
            pvec = reshape(pravd_prechodu,1,:)

            P[i,:] .= pvec[:]
        end
        i += 1
    end
    return P
end

function reshape_P(P)
    P_new = zeros(25,25)
    k = 1
    j = 22
    for i in 1:25
        if sum(P[i,:] .== 1) == 1
            P_new[j,:] .= P[i,:]
            j += 1
        else
            P_new[k,:] .= P[i,:]
            k += 1
        end
    end

    P_new2 = zeros(25,25)
    k = 1
    j = 22
    for i in 1:25
        if sum(P_new[:,i] .== 1) == 1
            P_new2[:,j] .= P_new[:,i]
            j += 1
        else
            P_new2[:,k] .= P_new[:,i]
            k += 1
        end
    end

    return P_new2
end

function mean_abs_time(P)
    Q = P[1:21,1:21]
    heatmap(reverse(Q,dims=1))

    N = inv(I - Q)
    NN = N*ones(21)

    MAT = zeros(5,5)
    k = 1
    for i in 1:5
        for j in 1:5
            if pole[j,i] != -1
                MAT[j,i] = NN[k]
                k += 1
                if k > 21
                    break
                end
            end
        end
    end

    return NN, MAT
end

function meanT(ks)
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

    P = matice_prechodu(pole_bezcastic, staticke_pole, ks)
    P_new = reshape_P(P)
    mat_vec, _ = mean_abs_time(P_new)

    Et = mat_vec[1]
end