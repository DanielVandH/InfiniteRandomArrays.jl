using InfiniteRandomArrays
using Test
using Aqua
using Distributions
using Random
using InfiniteArrays
using LinearAlgebra
using BandedMatrices
using LazyArrays: LazyArrays, CachedArray
using FillArrays

@testset verbose = true "Aqua" begin
    Aqua.test_all(InfiniteRandomArrays; ambiguities=false)
    Aqua.test_ambiguities(InfiniteRandomArrays) # don't pick up Base and Core...
end

include("vector.jl")
include("matrix.jl")
include("brand.jl")
include("named.jl")