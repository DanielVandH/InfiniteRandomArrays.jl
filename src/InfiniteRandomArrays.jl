module InfiniteRandomArrays

import Random: default_rng, seed!, AbstractRNG
import LazyArrays: AbstractCachedVector, resizedata!, LazyMatrix
import InfiniteArrays: ℵ₀, ∞, Infinity, InfiniteCardinal

export InfRandVector, InfRandMatrix, ∞

get_antidiagonal_bidx(i, j) = i + j - 1 # what antidiagonal does (i, j) belong to 
function diagtrav_idx(i, j) # assumes that the parent matrix is ∞ × ∞
    # maps (i, j) to its linear index when traversing the antidiagonals 
    band = get_antidiagonal_bidx(i, j)
    nelm_prev = (band * (band - 1)) ÷ 2 # number of elements in the previous band-1 antidiagonals 
    return nelm_prev + i
end

_dist_type(dist) = typeof(dist)
_dist_type(dist::Type{T}) where {T} = Type{T} # avoid DataType for typeof(Float64), since DataType means rand(seq.rng, seq.dist) is inferred as Any
function _reset_seed!(rng)
    new_seed = rand(rng, UInt32)
    return seed!(rng, new_seed)
end

"""
    InfRandVector([rng=default_rng()]; dist=Float64)

Represents a random infinite sequence. The random number generator can be specified 
by the first argument `rng`, which defaults to `Random.default_rng()`, and the distribution 
to generate from can be specified using the `dist` keyword argument, which defaults to `Float64`.

!!! note "Mutation of rng"

    When an `InfRandVector` is constructed, the `rng` (or, if 
    no `rng` is provided, the global `rng`) gets reseeded
    using `Random.seed!(rng, rand(rng, UInt32))`.
"""
mutable struct InfRandVector{T,D,RNG} <: AbstractCachedVector{T}
    const rng::RNG
    const dist::D
    const data::Vector{T}
    datasize::Int
end

function InfRandVector(rng::AbstractRNG=default_rng(); dist=Float64)
    T = typeof(rand(copy(rng), dist))
    _rng = copy(rng)
    _reset_seed!(rng)
    return InfRandVector{T,_dist_type(dist),typeof(_rng)}(_rng, dist, T[], 0)
end

Base.size(::InfRandVector) = (∞,)
Base.axes(::InfRandVector) = (1:∞,)
Base.length(::InfRandVector) = ∞

@inline _single_rand(seq::InfRandVector) = rand(seq.rng, seq.dist)
function resizedata!(seq::InfRandVector, inds)
    newlen = maximum(inds)
    curlen = length(seq.data)
    newlen > curlen || return seq
    resize!(seq.data, newlen)
    # rand!(seq.rng, view(seq.data, curlen+1:newlen), seq.dist)
    # ^ rand() is not actually sequential.. rand(Random.seed!(123), 1000) ≠ (rng = Random.seed!(123); [rand(rng) for _ in 1:1000])
    for i in (curlen+1):newlen
        seq.data[i] = _single_rand(seq)
    end
    seq.datasize = newlen
    return seq
end

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

end