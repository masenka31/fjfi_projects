using Distributions
using Plots
using Flux
using ConditionalDists
using ProgressMeter

########################## FUNCTIONS to generate data, plots, etc. ########################
# normal data
function normal_sinusoid(N, start, stop; noise=0.2)
    x = range(start, stop, length=N)
    y = sin.(x)
    X = vcat(x',y')
    return X .+ rand(MvNormal([0,0],noise),size(X,2))
end

function anomalous_sinusoid(N, start, stop; noise=0.2, shift=-1)
    x = range(start, stop, length=N)
    y = sin.(x) .+ shift
    X = vcat(x',y')
    return X .+ rand(MvNormal([0,0],noise),size(X,2))
end

using GenerativeModels
build_mlp(ks::Vector{Int}, fs::Vector) = Flux.Chain(map(i -> Dense(i[2],i[3],i[1]), zip(fs,ks[1:end-1],ks[2:end]))...)
build_mlp(idim::Int, hdim::Int, odim::Int, nlayers::Int; kwargs...) =
	build_mlp(vcat(idim, fill(hdim, nlayers-1)..., odim); kwargs...)
function build_mlp(ks::Vector{Int}; activation::String = "relu", lastlayer::String = "")
	activation = (activation == "linear") ? "identity" : activation
	fs = Array{Any}(fill(eval(:($(Symbol(activation)))), length(ks) - 1))
	if !isempty(lastlayer)
		fs[end] = (lastlayer == "linear") ? identity : eval(:($(Symbol(lastlayer))))
	end
	build_mlp(ks, fs)
end

function vae_constructor(;xdim, hdim, zdim, nlayers, activation)
	# construct the model
	# encoder - diagonal covariance
	encoder_map = Chain(
		build_mlp(xdim, hdim, hdim, nlayers-1, activation=activation)...,
		ConditionalDists.SplitLayer(hdim, [zdim, zdim], [identity, softplus])
		)
	encoder = ConditionalMvNormal(encoder_map)
	
	# decoder - we will optimize only a shared scalar variance for all dimensions
	decoder_map = Chain(
		build_mlp(zdim, hdim, hdim, nlayers-1, activation=activation)...,
		ConditionalDists.SplitLayer(hdim, [xdim, 1], [identity, softplus])
		)
	decoder = ConditionalMvNormal(decoder_map)

	# get the vanilla VAE
	model = VAE(zdim, encoder, decoder)
end

function scatter2(X; kwargs...)
    if size(X,1) != 2
        error("Input vector needs to habe 2 rows!")
    end
    Plots.scatter(X[1,:],X[2,:]; kwargs...)
end
function scatter2!(X; kwargs...)
    if size(X,1) != 2
        error("Input vector needs to habe 2 rows!")
    end
    Plots.scatter!(X[1,:],X[2,:]; kwargs...)
end

function plot_data(data, anomalous)
    scatter2(data[1],label="old",color=:green)
    scatter2!(data[2],label="new",xlims=(-2pi,3pi),ylims=(-2.5,2.5),color=:blue)
    scatter2!(anomalous,label="anomalous",color=:red)
end

function reconstruct(model::VAE, x)
	mean(model.decoder, rand(model.encoder,x))
end

function generate_new(model::VAE,n=100)
    z = rand(model.prior,n)
    rand(model.decoder, z)
end

# data likelihood
likelihood(model, x) = exp(logpdf(model.decoder, x, mean(model.encoder,x)))
likelihood(model, x, y) = exp(logpdf(model.decoder, [x,y], mean(model.encoder,[x,y])))

function likelihood_heatmap(model)
    len = 1000
    lk = zeros(len,len)
    xl = range(-2pi,3pi,length=len)
    yl = range(-2.5,2.5,length=len)
    i = 1
    for x in xl
        j = 1
        for y in yl
            lk[i,j] = likelihood(model,[x,y])
            j += 1
        end
        i += 1
    end
    #lk[lk .> 1] .= 1
    lk = lk ./ maximum(lk)
    p = heatmap(xl,yl,lk',color=:jet)

    return lk, p
end

"""
    RandomBagBatches(data;batchsize::Int=32)

Creates random batch for bag data which are an array of
arrays.
"""
function RandomBagBatches(data;batchsize::Int=32,randomize=true)
    l = length(data)
	if batchsize > l
		return data
	end
    if randomize
        idx = sample(1:l,batchsize)
		return (data)[idx]
    else
		idx = sample(1:l-batchsize)
        return data[idx:idx+batchsize-1]
    end
end

function train_new_solver_animation(model_init, opt_init, new_data, epoch, animation=true; batchsize = 128, new_ratio = 0.5, iter=500)
    generator = deepcopy(model_init)
    model = deepcopy(model_init)
    opt = deepcopy(opt_init)
    ps = Flux.params(model)
    loss(x) = -elbo(model, x)
    train_data = [new_data[:,i] for i in 1:size(new_data,2)]
    check = 10

    N_new = round(Int,batchsize*new_ratio)
    N_old = batchsize - N_new

    @showprogress "Training..." for i in 1:iter

        tmp = generate_new(generator,N_old)
        batch_old = [tmp[:,i] for i in 1:N_old]
        batch_new = RandomBagBatches(train_data, batchsize=N_new)
        batch = vcat(batch_old, batch_new)
        Flux.train!(loss,ps,batch,opt)
        train_loss = loss(train_data[1])
    
        if isnan(train_loss)
            @info "NaN loss. Training stopped."
            break
        end

        if mod(epoch, check) == 1 && animation
            hm = likelihood_heatmap(model)
            safesave(plotsdir("animation", "animation_hm_$epoch.png"), hm)
        end
    
        epoch += 1
    end
    return model, opt, epoch

end