@testset verbose = true "InfRandVector" begin
    @testset "Default constructor" begin
        Random.seed!(123)
        seq = InfRandVector()
        val = seq[1]
        @test seq[1] == val # constant 
        @test seq[1:10000] == seq[1:10000]
        @test seq[1] == val # didn't change after resizing
        @inferred seq[1]
        Random.seed!(123)
        _seq = [rand() for _ in 1:1000]
        @test seq[1:1000] == _seq[1:1000]
        @test size(seq) == (∞,)
        @test length(seq) == ∞
        @test axes(seq) == (1:∞,)
        @inferred InfiniteRandomArrays._single_rand(seq)
        @test similar(seq) == cache(zeros(∞))
    end

    @testset "Providing an RNG and a distribution" begin
        rng = MersenneTwister(123)
        seq = InfRandVector(rng; dist=InfiniteRandomArrays.Normal(Float16))
        rng2 = MersenneTwister(123)
        @test seq[1:10000] == [randn(rng2, Float16) for _ in 1:10000]
        @inferred InfiniteRandomArrays._single_rand(seq)
    end

    @testset "Distributions.jl" begin
        dist = Normal(0.3, 1.7) # do Normal{Float32} for example if you want that number type
        rng = Xoshiro(5)
        seq = InfRandVector(rng; dist)
        rng2 = Xoshiro(5)
        @test seq[1:100] ≈ [0.3 + 1.7randn(rng2) for _ in 1:100]

        @test InfiniteRandomArrays._dist_type(dist) == Normal{Float64}
        @test InfiniteRandomArrays._dist_type(Float64) == Type{Float64}
        @inferred InfiniteRandomArrays._single_rand(seq)
    end

    @testset "Reseeding" begin
        kp = InfRandVector()[1:1000]
        kp2 = InfRandVector()[1:1000]
        kp3 = InfRandVector()[1:1000]
        @test kp ≠ kp2
        @test kp2 ≠ kp3
        @test kp ≠ kp3
    end

    @testset "_gen_seqs" begin
        @inferred InfiniteRandomArrays._gen_seqs(Val(3), Float64)
        @test all(i -> i isa InfRandVector, InfiniteRandomArrays._gen_seqs(Val(3), Float64))
        rng = Random.seed!(123)
        s1, s2, s3 = InfiniteRandomArrays._gen_seqs(Val(3), Float64)
        rng = Random.seed!(123)
        _s1 = InfRandVector(rng)
        _s2 = InfRandVector(rng)
        _s3 = InfRandVector(rng)
        @test s1[1:100] == _s1[1:100]
        @test s2[1:100] == _s2[1:100]
        @test s3[1:100] == _s3[1:100]
    end
end
