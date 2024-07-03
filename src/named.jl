const InfRandTridiagonal{T} = Tridiagonal{T,<:InfRandVector{T}}
const InfRandBidiagonal{T} = Bidiagonal{T,<:InfRandVector{T}}

InfRandTridiagonal{T}() where {T} = Tridiagonal(_gen_seqs(Val(3), T)...)
InfRandTridiagonal(::Type{T}=Float64) where {T} = InfRandTridiagonal{T}()

const InfRandSymTridiagonal{T} = SymTridiagonal{T,<:InfRandVector{T}}

InfRandSymTridiagonal{T}() where {T} = SymTridiagonal(_gen_seqs(Val(2), T)...)
InfRandSymTridiagonal(::Type{T}=Float64) where {T} = InfRandSymTridiagonal{T}()

const InfRandBidiagonal{T} = Bidiagonal{T,<:InfRandVector{T}}

InfRandBidiagonal{T}(uplo::Union{Symbol,AbstractChar}) where {T} = Bidiagonal(_gen_seqs(Val(2), T)..., uplo)
InfRandBidiagonal(::Type{T}, uplo::Union{Symbol,AbstractChar}) where {T} = InfRandBidiagonal{T}(uplo)
InfRandBidiagonal(uplo::Union{Symbol,AbstractChar}) = InfRandBidiagonal(Float64, uplo)

for S in (:Symmetric, :UnitUpperTriangular, :UnitLowerTriangular,
    :UpperTriangular, :LowerTriangular)
    @eval begin
        const $(Symbol("InfRand$(S)")){T} = $S{T,<:InfRandMatrix{T}}
        $(Symbol("InfRand$(S)")){T}() where {T} = $S(InfRandMatrix(dist=T))
        $(Symbol("InfRand$(S)"))(::Type{T}=Float64) where {T} = $S(InfRandMatrix(dist=T))
    end
end
const InfRandDiagonal{T} = Diagonal{T,<:InfRandVector{T}}
InfRandDiagonal{T}() where {T} = Diagonal(InfRandVector(dist=T))
InfRandDiagonal(::Type{T}=Float64) where {T} = InfRandDiagonal{T}()