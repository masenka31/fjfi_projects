include(srcdir("requirements.jl"))
include(srcdir("data_toy.jl"))

# initial values
m = 5;
s = 2;

m_gs, s_gs, pdm_gs, pds_gs = run_GS(x1,x2,α,β,Φ,μ,m,s,1000)

# 2d visualization
pd_2d_gs = kde(hcat(s_gs,m_gs))
plot(pd_2d_gs,xlims=(-1,35),ylims=(1,7),title="Gibbs sampler")
plot_pd_2d_gs = scatter!(s_gs,m_gs,markersize=1.5,legend=:none,colorbar=:none)

# fit MvNormal
matrix_gs = vcat(m_gs',s_gs')
fit_gs = fit_mle(MvNormal,matrix_gs)

plot(layout=(1,2),plot_pd_2d_gs, plot_pd_2d_hmc,size=(1200,600))
