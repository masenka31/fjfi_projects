function HMC_toy_sim(x1,x2,α,β,Φ,μ,iter)
    Mtmp = zeros(1,iter)
    Stmp = zeros(1,iter)

    for i in 1:10
        chain = sample(toy(x1,x2,α,β,Φ,μ), HMC(0.1, 5), iter)
        m, s = HMCtoy_params(chain)
        marginalkde(m,s,size=(300,300))
        plt_dist = plot!(xlabel=["m" "" ""],ylabel=["" "" "s"])
        safesave(plotsdir("hmc_toy","iter=$(iter)_$i.pdf"),plt_dist)

        Mtmp = vcat(Mtmp,m')
        Stmp = vcat(Stmp,s')

        data = Dict(
            :Em => mean(m),
            :Es => mean(s),
            :iter => iter,
            :m => m,
            :s => s,
        )
        safesave(datadir("hmc_toy",savename(data, "bson")),data)
    end

    M = Mtmp[2:end,:]
    S = Stmp[2:end,:]
    ci_m = hcat([calculate_confidence(M[i,:]) for i in 1:10]...)
    ci_s = hcat([calculate_confidence(S[i,:]) for i in 1:10]...)

    plt_m = plot_CI(ci_m,ylabel="m")
    plt_m = plot!(size=(320,220))
    plt_s = plot_CI(ci_s,ylabel="s")
    plt_s = plot!(size=(320,220))
    safesave(plotsdir("hmc_toy","ci_m_iter=$iter.pdf"),plt_m)
    safesave(plotsdir("hmc_toy","ci_s_iter=$iter.pdf"),plt_s)
end


function HMC_LR_sim(X,y,δ,γ,iter)
    E = (X'*X)^(-1)*X'*y
    θ1m = zeros(1,iter)
    θ2m = zeros(1,iter)
    θ3m = zeros(1,iter)

    for i in 1:10
        result = sample(linreg(X,y,γ,δ,E),HMC(0.005,5),iter)
        θ1 = result.value[:,Symbol("θ[1]"),1]
        θ2 = result.value[:,Symbol("θ[2]"),1]
        θ3 = result.value[:,Symbol("θ[3]"),1]
        plt = plot_θ(θ1,θ2,θ3)
        safesave(plotsdir("hmc_lr","iter=$(iter)_$i.pdf"),plt)

        θ1m = vcat(θ1m,θ1')
        θ2m = vcat(θ2m,θ2')
        θ3m = vcat(θ3m,θ3')

        data = Dict(
            :Eθ1 => mean(θ1),
            :Eθ2 => mean(θ2),
            :Eθ3 => mean(θ3),
            :iter => iter,
            :α => α,
            :θ => hcat(θ1,θ2,θ3),
        )
        safesave(datadir("hmc_lr",savename(data, "bson")),data)

    end

    θ1 = θ1m[2:end,:]
    θ2 = θ2m[2:end,:]
    θ3 = θ3m[2:end,:]

    ci1 = hcat([calculate_confidence(θ1[i,:]) for i in 1:10]...)
    ci2 = hcat([calculate_confidence(θ2[i,:]) for i in 1:10]...)
    ci3 = hcat([calculate_confidence(θ3[i,:]) for i in 1:10]...)

    p1 = plot_CI(ci1,ylabel=L"\theta_1")
    p2 = plot_CI(ci2,ylabel=L"\theta_2")
    p3 = plot_CI(ci3,ylabel=L"\theta_3")

    ci_plot = plot(p1,p2,p3,layout=(3,1),size=(600,500))
    safesave(plotsdir("hmc_lr","ci_theta_iter=$iter.pdf"),ci_plot)
end