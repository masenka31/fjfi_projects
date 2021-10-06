function polynomial(a, x)
    accumulator = 0
    for i in length(a):-1:1
        accumulator += x^(i-1) * a[i] # ! 1-based indexing for arrays
    end
    return accumulator
end

a = [-19,7,-4,6]
x = 3
polynomial(a,x)

x = 3.0
eltype(x)
accumulator = 0
eltype(accumulator)

c = collect(2:2:42)
d = copy(c)
d[7] = 13

addone(x) = x + 1

af = [-19.0, 7.0, -4.0, 6.0]
at = (-19, 7, -4, 6)
ant = (a₀ = -19, a₁ = 7, a₂ = -4, a₃ = 6)
a2d = [-19 -4; 7 6]
ac = [2i^2 + 1 for i in -2:1]

for a in [af, at, ant, a2d, ac]
    println("typeof: $(typeof(a))")
    println("eltype: $(eltype(a))")
    
    res = polynomial(a, x)
    println(res)
end