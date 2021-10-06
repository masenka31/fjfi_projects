using DrWatson
@quickactivate

function circlemat(n)
    A = zeros(n,n)
    for i in 1:n
        for j in 1:n
            if (i == j - 1 && j > 1) || (i == n && j == 1)
                A[i,j] = 1
            elseif (i == j + 1 && j < n) || (i == 1 && j == n)
                A[i,j] = 1
            end
        end
    end
    return A
end

function polynomial(a, x)
    accumulator = 0
    for i in length(a):-1:1
        accumulator += x^(i-1) * a[i] # ! 1-based indexing for arrays
    end
    return accumulator
end
function polynomial(a, x::T) where T <: AbstractMatrix
    accumulator = zeros(size(x))
    for i in length(a):-1:1
        accumulator .+= x^(i-1) * a[i] # ! 1-based indexing for arrays
    end
    return accumulator
end

### evaluation
# since we only want I + A + A² + A³
a = [1,1,1,1]
# the "circle matrix"
A = circlemat(10)
# result
fA = polynomial(a, A)

using GraphRecipes, Plots
graphplot(fA, nodesize=0.2, curvature_scalar=0.04)
graphplot(A, nodesize=0.2, curves=false)