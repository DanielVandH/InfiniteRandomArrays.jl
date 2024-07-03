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
    T = typeof(_rand(copy(rng), dist))
    _rng = copy(rng)
    _reset_seed!(rng)
    return InfRandVector{T,_dist_type(dist),typeof(_rng)}(_rng, dist, T[], 0)
end

size(::InfRandVector) = (∞,)
length(::InfRandVector) = ∞

@inline _single_rand(seq::InfRandVector) = _rand(seq.rng, seq.dist)
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