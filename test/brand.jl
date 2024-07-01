using BandedMatrices
@testset "brand" begin
    function test_brand(A, ::Type{T}, n, m, a, b; seed, normal) where {T}
        Random.seed!(seed)
        @test bandwidths(A) == (a, b)
        @test size(A) == (n, m)
        @test axes(A) == (1:n, 1:m)
        @test A isa BandedMatrix
        n′ = max(0, a + b + 1)
        if isfinite(m)
            data = normal ? randn(T, n′, m) : rand(T, n′, m)
            @test A.data == data
        else
            data = InfRandMatrix(n′, m; dist=normal ? InfiniteRandomArrays.Normal{T}() : T)
            @test A.data[:, 1:1000] == data[:, 1:1000]
        end
    end
    _brand(seed, args...) = (Random.seed!(seed); @inferred brand(args...))
    _brandn(seed, args...) = (Random.seed!(seed); @inferred brandn(args...))
    test_brand(_brand(123, Float64, ∞, 5, 1, 2), Float64, ∞, 5, 1, 2; seed=123, normal=false)
    test_brand(_brandn(123, Float32, ∞, 23, -1, 5), Float32, ∞, 23, -1, 5; seed=123, normal=true)
    test_brand(_brand(457, Float32, 2, ∞, 0, 3), Float32, 2, ∞, 0, 3; seed=457, normal=false)
    test_brand(_brandn(47, Float64, 17, ∞, 4, -2), Float64, 17, ∞, 4, -2; seed=47, normal=true)
    test_brand(_brand(4997, Float32, ∞, ∞, 5, 3), Float32, ∞, ∞, 5, 3; seed=4997, normal=false)
    test_brand(_brandn(40, Float64, ∞, ∞, 7, 7), Float64, ∞, ∞, 7, 7; seed=40, normal=true)

    test_brand(_brand(123, ∞, 32, -2, 2), Float64, ∞, 32, -2, 2; seed=123, normal=false)
    test_brand(_brandn(123, ∞, 3, -1, 2), Float64, ∞, 3, -1, 2; seed=123, normal=true)
    test_brand(_brand(457, 2, ∞, 7, 3), Float64, 2, ∞, 7, 3; seed=457, normal=false)
    test_brand(_brandn(47, 17, ∞, 4, -2), Float64, 17, ∞, 4, -2; seed=47, normal=true)
    test_brand(_brand(4997, ∞, ∞, 3, 3), Float64, ∞, ∞, 3, 3; seed=4997, normal=false)
    test_brand(_brandn(40, ∞, ∞, 12, 7), Float64, ∞, ∞, 12, 7; seed=40, normal=true)

    test_brand(_brand(4230, Float64, ∞, 2, 7), Float64, ∞, ∞, 2, 7; seed=4230, normal=false)
    test_brand(_brandn(40, Float64, ∞, 7, -2), Float64, ∞, ∞, 7, -2; seed=40, normal=true)
    test_brand(_brand(4230, ∞, 2, 7), Float64, ∞, ∞, 2, 7; seed=4230, normal=false)
    test_brand(_brandn(40, ∞, 7, -2), Float64, ∞, ∞, 7, -2; seed=40, normal=true)

    test_brand(_brand(123, Float64, ∞, 5, (-1, 2)), Float64, ∞, 5, 1, 2; seed=123, normal=false)
    test_brand(_brandn(123, Float32, ∞, 23, (1, 5)), Float32, ∞, 23, -1, 5; seed=123, normal=true)
    test_brand(_brand(457, Float32, 2, ∞, (0, 3)), Float32, 2, ∞, 0, 3; seed=457, normal=false)
    test_brand(_brandn(47, Float64, 17, ∞, (-4, -2)), Float64, 17, ∞, 4, -2; seed=47, normal=true)
    test_brand(_brand(4997, Float32, ∞, ∞, (-5, 3)), Float32, ∞, ∞, 5, 3; seed=4997, normal=false)
    test_brand(_brandn(40, Float64, ∞, ∞, (-7, 7)), Float64, ∞, ∞, 7, 7; seed=40, normal=true)

    test_brand(_brand(4230, Float64, ∞, (-2, 7)), Float64, ∞, ∞, 2, 7; seed=4230, normal=false)
    test_brand(_brandn(40, Float32, ∞, (-7, -2)), Float32, ∞, ∞, 7, -2; seed=40, normal=true)
    test_brand(_brand(4230, ∞, (-2, 7)), Float64, ∞, ∞, 2, 7; seed=4230, normal=false)
    test_brand(_brandn(40, ∞, (-7, -2)), Float64, ∞, ∞, 7, -2; seed=40, normal=true)

    test_brand(_brand(127, ∞, 7, (3, 5)), Float64, ∞, 7, -3, 5; seed=127, normal=false)
    test_brand(_brandn(127, ∞, 7, (3, 5)), Float64, ∞, 7, -3, 5; seed=127, normal=true)
    test_brand(_brand(1237, 4, ∞, (3, 1)), Float64, 4, ∞, -3, 1; seed=1237, normal=false)
    test_brand(_brandn(1237, 2, ∞, (-3, -5)), Float64, 2, ∞, 3, -5; seed=1237, normal=true)
    test_brand(_brand(12357, ∞, ∞, (-1, 3)), Float64, ∞, ∞, 1, 3; seed=12357, normal=false)
    test_brand(_brandn(12357, ∞, ∞, (0, 0)), Float64, ∞, ∞, 0, 0; seed=12357, normal=true)

    test_brand(_brand(128, ∞, (3, 5)), Float64, ∞, ∞, -3, 5; seed=128, normal=false)
    test_brand(_brandn(128412, ∞, (-1, 2)), Float64, ∞, ∞, 1, 2; seed=128412, normal=true)
end