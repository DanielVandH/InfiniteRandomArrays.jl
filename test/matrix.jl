@testset "InfRandMatrix" begin
    @testset "Default constructor" begin
        Random.seed!(123)
        A = InfRandMatrix(5, ∞)
        @test InfiniteRandomArrays._is_wide(A)
        @test !InfiniteRandomArrays._is_tall(A)
        @test size(A) == (5, ∞)
        @test axes(A) == (1:5, 1:∞)
        @test A[1, 1] == A[1, 1]
        @inferred A[5, 5]
        @test A[1:3, 1:100] == A[1:3, 1:100]
        @test_throws BoundsError A[0, 1]
        Random.seed!(123)
        _A = [rand() for _ in 1:5, _ in 1:1000]
        @test _A == A[1:5, 1:1000]
        @test (A+A)[1:5, 1:1000] ≈ 2_A
        @test (A'+A')[1:1000, 1:5] ≈ 2_A'
        @test A[11] ≈ A.seq[11] ≈ A[1, 3]
        @test InfRandMatrix(5, ∞)[1:5, 1:100] ≠ InfRandMatrix(5, ∞)[1:5, 1:100]

        Random.seed!(12356)
        B = InfRandMatrix(∞, 7)
        @test !InfiniteRandomArrays._is_wide(B)
        @test InfiniteRandomArrays._is_tall(B)
        @test size(B) == (∞, 7)
        @test axes(B) == (1:∞, 1:7)
        @test B[1, 1] == B[1, 1]
        @inferred B[7, 5]
        @test_throws BoundsError B[-2, 5]
        @test B[1:1000, 1:7] == B[1:1000, 1:7]
        Random.seed!(12356)
        _B = [rand() for _ in 1:7, _ in 1:1000]
        @test _B' == B[1:1000, 1:7]
        @test InfRandMatrix(∞, 3)[1:5, 1:2] ≠ InfRandMatrix(∞, 3)[1:5, 1:2]

        Random.seed!(9888)
        C = InfRandMatrix()
        @test !InfiniteRandomArrays._is_wide(C)
        @test !InfiniteRandomArrays._is_tall(C)
        @test size(C) == (∞, ∞)
        @test axes(C) == (1:∞, 1:∞)
        @test C[1, 1] == C[1, 1]
        @test C[1:1000, 1:1000] == C[1:1000, 1:1000]
        Random.seed!(9888)
        seq = InfRandVector()
        @test seq[1] == C[1, 1]
        @test seq[2:3] == [C[1, 2], C[2, 1]]
        @test seq[4:6] == [C[1, 3], C[2, 2], C[3, 1]]
        @test seq[7:10] == [C[1, 4], C[2, 3], C[3, 2], C[4, 1]]
    end

    @testset "Providing an RNG and a distribution" begin
        rng = MersenneTwister(123)
        seq = InfRandMatrix(rng, 5, ∞; dist=Float16)
        rng2 = MersenneTwister(123)
        @test seq[1:10000] == [rand(rng2, Float16) for _ in 1:10000]
    end

    @testset "Distributions.jl" begin
        dist = Normal(0.3, 1.7)
        rng = Xoshiro(5)
        seq = InfRandMatrix(rng, 2, ∞; dist)
        rng2 = Xoshiro(5)
        @test seq[1:1000] == [0.3 + 1.7randn(rng2) for _ in 1:1000]
    end
end