function plot_layout(data,layout;kwargs...)
    l = prod(layout)
    if l != length(data)
        error("Layout size not compatible with data size!")
    end
    p = plot(layout=layout;kwargs...)
    for i in 1:l
        x = data[i]
        if size(x,1) > size(x,2)
            x = x'
        end
        p = scatter!(p, x[1,:],x[2,:], subplot=i)
    end
    return p
end


function scatter2(X; kwargs...)
    if size(X,1) != 2
        @warn "Input vector has more than 2 rows."
    end
    scatter(X[1,:],X[2,:]; kwargs...)
end
function scatter2!(X; kwargs...)
    if size(X,1) != 2
        @warn "Input vector has more than 2 rows."
    end
    scatter!(X[1,:],X[2,:]; kwargs...)
end

function scatter3(X; kwargs...)
    if size(X,1) != 3
        @warn "Input vector has more than 3 rows."
    end
    scatter(X[1,:],X[2,:],X[3,:]; kwargs...)
end
function scatter3!(X; kwargs...)
    if size(X,1) != 3
        @warn "Input vector has more than 3 rows."
    end
    scatter!(X[1,:],X[2,:],X[3,:]; kwargs...)
end