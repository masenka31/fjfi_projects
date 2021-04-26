using AxisArrays

function evaluate(dir::String, parameters)
    res = collect_results(datadir(dir))
    gdf = groupby(res,:iter)
    n = length(parameters)

    if n == 2
        statistics = DataFrame(:iter => [50,500,5000], :m => [0.0, 0.0, 0.0], :std_m => [0.0, 0.0, 0.0], :s => [0.0, 0.0, 0.0], :std_s => [0.0, 0.0, 0.0])
        new_params  = [:m, :std_m, :s, :std_s]
    else
        statistics = DataFrame(:iter => [50,500,5000], :θ1 => [0.0, 0.0, 0.0], :std_θ1 => [0.0, 0.0, 0.0],:θ2 => [0.0, 0.0, 0.0], :std_θ2 => [0.0, 0.0, 0.0],:θ3 => [0.0, 0.0, 0.0], :std_θ3 => [0.0, 0.0, 0.0])
        new_params  = [:θ1, :std_θ1, :θ2, :std_θ2, :θ3, :std_θ3]
    end
    
    row = 1
    for df in gdf
        for i in 1:n
            e = mean(df[!,parameters[i]])
            s = var(df[!,parameters[i]])
            statistics[row,new_params[2i-1]] = e
            statistics[row,new_params[2i]] = s
        end
        row += 1
    end
    return statistics
end

parameters_toy = [:Em, :Es]
parameters_lr = [:Eθ1,:Eθ2,:Eθ3]

toy_gs = round.(evaluate("gs_toy",parameters_toy),digits=3) |> Array
toy_hmc = round.(evaluate("hmc_toy",parameters_toy),digits=3) |> Array
lr_gs = round.(evaluate("gs_lr",parameters_lr),digits=4) |> Array
lr_hmc = round.(evaluate("hmc_lr",parameters_lr),digits=4) |> Array
