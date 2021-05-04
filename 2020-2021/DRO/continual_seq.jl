using DrWatson
include(srcdir("continual_functions.jl"))

function likelihood_heatmap(model)
    len = 500
    lk = zeros(len,len)
    xl = range(-1,20,length=len)
    yl = range(-2,2,length=len)
    i = 1
    for x in xl
        j = 1
        for y in yl
            lk[i,j] = likelihood(model,[x,y])
            j += 1
        end
        i += 1
    end

    lk = lk ./ maximum(lk)
    p = heatmap(xl,yl,lk',color=:jet)
end


# create and plot data
data = [normal_sinusoid(500,i*pi,(i+1)*pi) for i in 0:5]

p = plot(legend=:topright,xlims=(-1,20),ylims=(-2,2));
for i in 1:6
    p = scatter2!(data[i],label="$i")
end
p

# create model
vae = vae_constructor(xdim=2,hdim=5,zdim=2,nlayers=3,activation="swish")
hm0 = likelihood_heatmap(vae)
save(plotsdir("animation","animation_hm_0.png"),hm0)

loss(x) = -elbo(vae, x)

opt = ADAM()
ps = Flux.params(vae)

check = 10
epoch = 1
best_model = deepcopy(vae)
best_opt = deepcopy(opt)
best_val_loss = Inf
val_data = [normal_sinusoid(200,0,2pi)[:,i] for i in 1:200]
train_data = [data[1][:,i] for i in 1:size(data[1],2)]
patience = 1

# ------------- initial training -----------------------------------------------------

@showprogress for i in 1:500

    batch = RandomBagBatches(train_data, batchsize=128)
    Flux.train!(loss,ps,batch,opt)
    val_loss = median(loss.(val_data))

    if val_loss < best_val_loss
        @info "Batch no. $epoch: $val_loss (patience = $patience)"
        best_val_loss = val_loss
        best_model = deepcopy(vae)
        best_opt = deepcopy(opt)

        patience = 1
    elseif isnan(val_loss)
        @info "NaN loss. Training stopped."
        break
    else
        patience += 1
    end
    
    if mod(epoch, check) == 1
        hm = likelihood_heatmap(vae)
        safesave(plotsdir("animation", "animation_hm_$epoch.png"), hm)
    end

    epoch += 1
    #opt.eta *= 0.999
end

m1 = deepcopy(vae)
hm = likelihood_heatmap(m1)

# ---------------------------- sequential GR training -------------------------------

m2, opt2, epoch = train_new_solver_animation(m1, opt, data[2], epoch; new_ratio = 1/2)
m3, opt3, epoch = train_new_solver_animation(m2, opt2, data[3], epoch; new_ratio = 1/3)
m4, opt4, epoch = train_new_solver_animation(m3, opt3, data[4], epoch; new_ratio = 1/4)
m5, opt5, epoch = train_new_solver_animation(m4, opt4, data[5], epoch; new_ratio = 1/5)
m6, opt6, epoch = train_new_solver_animation(m5, opt5, data[6], epoch; new_ratio = 1/6)

hm2 = likelihood_heatmap(m2);
hm3 = likelihood_heatmap(m3);
hm4 = likelihood_heatmap(m4);
hm5 = likelihood_heatmap(m5);
hm6 = likelihood_heatmap(m6);

plot(hm,hm2,hm3,hm4,hm5,hm6,layout=(3,2),axis=([],:none),colorbar=:none)
savefig(plotsdir("continual","sequence_podle_n.pdf"))

models = [m1,m2,m3,m4,m5,m6]
safesave(datadir("continual","models_podle_n.bson"),Dict(:models => models))