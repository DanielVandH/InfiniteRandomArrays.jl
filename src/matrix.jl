"""
    InfRandMatrix([rng=default_rng()], m, n; dist=Float64])

Represents a random infinite matrix with `m` rows and `n` columns. At least one of `m` 
and `n` must be infinite. The random number generator 
can be specified by the first argument `rng`, which defaults to `Random.default_rng()`.
The `dist` keyword argument (default `Float64`) can be used to specify the distribution to sample from. 

!!! note "Mutation of rng"

    When an `InfRandMatrix` is constructed, the `rng` (or, if 
    no `rng` is provided, the global `rng`) gets reseeded
    using `Random.seed!(rng, rand(rng, UInt32))`.
"""
struct InfRandMatrix{T, S <: InfRandVector{T}, M, N} <: LazyMatrix{T} 
    seq::S 
    m::M
    n::N
    function InfRandMatrix(seq::S, m::M, n::N) where {T, S<:InfRandVector{T}, M, N}
        !(isinf(m) || isinf(n)) && throw(ArgumentError("The matrix must be infinite along at least one axis."))
        return new{T, S, M, N}(seq, m, n)
    end
end 
const IntOrInf = Union{InfiniteCardinal{0}, Infinity, Integer}
InfRandMatrix(; dist = Float64) = InfRandMatrix(default_rng(); dist)
InfRandMatrix(rng::AbstractRNG; dist = Float64) = InfRandMatrix(rng, ∞, ∞; dist)
InfRandMatrix(m::IntOrInf, n::IntOrInf; dist=Float64) = InfRandMatrix(default_rng(), m, n; dist)
InfRandMatrix(rng::AbstractRNG, m::IntOrInf, n::IntOrInf; dist=Float64) = InfRandMatrix(InfRandVector(rng; dist), m, n)
_is_wide(A::InfRandMatrix) = isfinite(A.m)
_is_tall(A::InfRandMatrix) = isfinite(A.n)
function Base.getindex(A::InfRandMatrix, i::Int, j::Int)
    ((i < 1) || (i > A.m) || (j < 1) || (j > A.n)) && throw(BoundsError(A, (i, j)))
    lin = _sub2ind(A, i, j)
    return A.seq[lin]
end

Base.size(A::InfRandMatrix) = (A.m, A.n)

function _sub2ind(A::InfRandMatrix, i, j)
    if _is_wide(A)
        return (j - 1) * A.m + i 
    elseif _is_tall(A) 
        return (i - 1) * A.n + j 
    else 
        return diagtrav_idx(i, j)
    end
end