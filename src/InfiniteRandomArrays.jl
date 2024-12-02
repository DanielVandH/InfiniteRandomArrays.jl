module InfiniteRandomArrays

import Base: size, axes, length
import Random: Random, default_rng, seed!, AbstractRNG
import LazyArrays: LazyArrays, AbstractCachedVector, resizedata!, LazyMatrix
import InfiniteArrays: InfiniteArrays, ℵ₀, ∞, Infinity, InfiniteCardinal
import LinearAlgebra: SymTridiagonal, Tridiagonal, Bidiagonal,
    Symmetric, UnitUpperTriangular, UnitLowerTriangular,
    UpperTriangular, LowerTriangular, Diagonal

export InfRandVector, InfRandMatrix, ∞,
    InfRandSymTridiagonal, InfRandTridiagonal, InfRandBidiagonal,
    InfRandSymmetric, InfRandUnitUpperTriangular, InfRandUnitLowerTriangular,
    InfRandUpperTriangular, InfRandLowerTriangular, InfRandDiagonal

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

struct Normal{T} end
Normal(::Type{T}=Float64) where {T} = Normal{T}()
_rand(rng, dist) = rand(rng, dist)
_rand(rng, ::Normal{T}) where {T} = randn(rng, T)

_gen_seqs(::Val{N}, ::Type{T}) where {N,T} = ntuple(_ -> InfRandVector(dist=T), Val(N))

include("vector.jl")
include("matrix.jl")
include("named.jl")

end