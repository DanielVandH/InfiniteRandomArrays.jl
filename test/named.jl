const IRV = InfRandVector

@testset "Random Special Matrices" begin
    @testset "InfRandBidiagonal" begin
        for uplo in ('U', :L)
            Random.seed!(123)
            B = InfRandBidiagonal(uplo)
            Random.seed!(123)
            @test B[1:100, 1:100] == Bidiagonal(IRV(), IRV(), uplo)[1:100, 1:100]
        end
    end

    @testset "InfRandTridiagonal" begin
        Random.seed!(123)
        B = InfRandTridiagonal{Float32}()
        Random.seed!(123)
        @test B[1:100, 1:100] == Tridiagonal(IRV(dist=Float32), IRV(dist=Float32), IRV(dist=Float32))[1:100, 1:100]
        Random.seed!(566)
        B = InfRandTridiagonal()
        Random.seed!(566)
        @test B[1:100, 1:100] == Tridiagonal(IRV(), IRV(), IRV())[1:100, 1:100]
    end

    @testset "InfRandSymTridiagonal" begin
        Random.seed!(123)
        B = InfRandSymTridiagonal{Float16}()
        Random.seed!(123)
        @test B[1:100, 1:100] == SymTridiagonal(IRV(dist=Float16), IRV(dist=Float16))[1:100, 1:100]
        Random.seed!(566)
        B = InfRandSymTridiagonal()
        Random.seed!(566)
        @test B[1:100, 1:100] == SymTridiagonal(IRV(), IRV())[1:100, 1:100]
    end

    @testset "Others" begin
        function test_matrix(f, g, seed)
            Random.seed!(seed)
            diag = f()
            Random.seed!(seed)
            diag2 = g(g == Diagonal ? InfRandVector() : InfRandMatrix())
            @test diag isa g
            @test diag[1:250, 1:250] == diag2[1:250, 1:250]
        end
        gs = (:Symmetric, :UnitUpperTriangular, :UnitLowerTriangular,
            :UpperTriangular, :LowerTriangular, :Diagonal)
        fs = Symbol.(:InfRand, gs)
        for (f, g) in zip(fs, gs)
            f, g = getfield(Main, f), getfield(Main, g) # Symbol -> Function
            test_matrix(f, g, 123)
        end
    end
end