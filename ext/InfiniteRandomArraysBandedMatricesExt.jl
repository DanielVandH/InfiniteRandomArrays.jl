module InfiniteRandomArraysBandedMatricesExt 

using InfiniteRandomArrays
import BandedMatrices: brand, brandn, _BandedMatrix
import InfiniteRandomArrays.InfiniteArrays: PosInfinity
import InfiniteRandomArrays: Normal

_dist(op, dist::Type{T}) where {T} = dist
_dist(::typeof(randn), dist::Type{T}) where {T} = Normal{T}()
for (op, bop) in ((:rand, :brand), (:randn, :brandn))
    @eval begin
        $bop(dist::Type{T}, n::PosInfinity, m::Integer, a::Integer, b::Integer) where {T} =
            _BandedMatrix($op(dist, max(0, a + b + 1), m), 1:n, a, b)
        $bop(dist::Type{T}, n::Integer, m::PosInfinity, a::Integer, b::Integer) where {T} =
            _BandedMatrix(InfRandMatrix(max(0, a + b + 1), m; dist=_dist($op, dist)), 1:n, a, b)
        $bop(dist::Type{T}, n::PosInfinity, m::PosInfinity, a::Integer, b::Integer) where {T} =
            _BandedMatrix(InfRandMatrix(max(0, a + b + 1), m; dist=_dist($op, dist)), 1:n, a, b)

        $bop(n::PosInfinity, m::Integer, a::Integer, b::Integer) = $bop(Float64, n, m, a, b)
        $bop(n::Integer, m::PosInfinity, a::Integer, b::Integer) = $bop(Float64, n, m, a, b)
        $bop(n::PosInfinity, m::PosInfinity, a::Integer, b::Integer) = $bop(Float64, n, m, a, b)

        $bop(::Type{T}, n::PosInfinity, a::Integer, b::Integer) where {T} = $bop(T, n, n, a, b)
        $bop(n::PosInfinity, a::Integer, b::Integer) = $bop(Float64, n, a, b)

        $bop(::Type{T}, n::PosInfinity, m::Integer, a) where {T} = $bop(T, n, m, -a[1], a[end])
        $bop(::Type{T}, n::Integer, m::PosInfinity, a) where {T} = $bop(T, n, m, -a[1], a[end])
        $bop(::Type{T}, n::PosInfinity, m::PosInfinity, a) where {T} = $bop(T, n, m, -a[1], a[end])

        $bop(::Type{T}, n::PosInfinity, a) where {T} = $bop(T, n, -a[1], a[end])

        $bop(n::PosInfinity, m::Integer, a) = $bop(Float64, n, m, -a[1], a[end])
        $bop(n::Integer, m::PosInfinity, a) = $bop(Float64, n, m, -a[1], a[end])
        $bop(n::PosInfinity, m::PosInfinity, a) = $bop(Float64, n, m, -a[1], a[end])

        $bop(n::PosInfinity, a) = $bop(n, -a[1], a[end])
    end
end

end