# InfiniteRandomArrays

[![Build Status](https://github.com/DanielVandH/InfiniteRandomArrays.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/DanielVandH/InfiniteRandomArrays.jl/actions/workflows/CI.yml?query=branch%3Amain)

Julia package for defining infinite random arrays using `InfRandVector` and `InfRandMatrix`.

```julia-repl
julia> using InfiniteRandomArrays, Random

julia> seq = InfRandVector()
ℵ₀-element InfRandVector{Float64, Type{Float64}, Xoshiro} with indices 1:∞:
 0.45212042137198805
 0.9647238362580713
 0.6462526785368201
 0.6070361635715884
 0.10222222882722942
 ⋮

julia> using Distributions

julia> seq = InfRandVector(Xoshiro(); dist = Normal()) # you can provide your own RNG objects and probability distributions
ℵ₀-element InfRandVector{Float64, Normal{Float64}, Xoshiro} with indices 1:∞:
 -0.2504330818050723
  0.5311482824138374
 -0.44943761206068344
 -0.05495674359736308
 -1.3213053212880623
  ⋮

julia> mat = InfRandMatrix() # ∞ × ∞ by default
ℵ₀×ℵ₀ InfRandMatrix{Float64, InfRandVector{Float64, Type{Float64}, Xoshiro}, Infinities.Infinity, Infinities.Infinity} with indices OneToInf()×OneToInf():
 0.984449   0.203976   0.898197  0.84345   0.745756  0.368674  0.351961  0.461869  …  
 0.585687   0.610724   0.267032  0.495627  0.697247  0.873579  0.44229   0.301071
 0.534054   0.557934   0.478424  0.843203  0.723205  0.339773  0.731446  0.18291
 0.0206029  0.0462717  0.160456  0.76735   0.869515  0.365665  0.476832  0.565982
 0.49287    0.616739   0.637889  0.870164  0.770499  0.616812  0.580221  0.370818
 ⋮                                                   ⋮                             ⋱

julia> mat = InfRandMatrix(3, ∞) # wide random matrix
3×ℵ₀ InfRandMatrix{Float64, InfRandVector{Float64, Type{Float64}, Xoshiro}, Int64, Infinities.Infinity} with indices Base.OneTo(3)×OneToInf():
 0.900203  0.261395  0.222175  0.429518  0.732901  0.820293  0.972021  0.0544778  …  
 0.914717  0.538762  0.46626   0.907753  0.453501  0.307607  0.440711  0.896696
 0.96409   0.556647  0.784155  0.699887  0.47419   0.35258   0.788991  0.481014      

julia> mat = InfRandMatrix(Xoshiro(), ∞, 7; dist = Exponential()) # tall random matrix
ℵ₀×7 InfRandMatrix{Float64, InfRandVector{Float64, Exponential{Float64}, Xoshiro}, Infinities.Infinity, Int64} with indices OneToInf()×Base.OneTo(7):
 2.3061    0.381158  0.405392  0.0152963  0.424681  0.880358  1.3035
 0.988759  0.238397  1.32133   2.33813    0.626563  1.06349   1.19391
 2.00946   2.7429    0.97791   1.68287    0.712554  1.26766   0.0432282
 0.260173  0.947835  0.668184  0.405158   1.81257   0.195216  3.52343
 1.0597    0.680587  0.616505  0.100519   0.387551  2.80689   0.63101
 ⋮        
 
julia> mat = InfRandMatrix(; dist = InfiniteRandomArrays.Normal{Float32}()) # if you don't want to depend on Distributions.jl for normal sampling
ℵ₀×ℵ₀ InfRandMatrix{Float32, InfRandVector{Float32, InfiniteRandomArrays.Normal{Float32}, Xoshiro}, Infinities.Infinity, Infinities.Infinity} with indices OneToInf()×OneToInf():
  0.306927  -0.15094     1.04316   -1.13007    -1.14508   -0.0463847   0.744666  …
 -1.34004   -0.314993    1.01494   -1.91199    -1.52208   -0.552572   -0.760699
  0.194879   0.0223698   0.196902   0.675849    1.60287   -0.233533   -1.4827
  0.717089   1.12661     0.749318   0.0874666   1.06572   -1.05195     1.64873
 -2.94036   -2.05101    -0.384845   0.905886    0.912348  -0.845594   -0.737711
  ⋮                                                        ⋮                     ⋱
                                          ⋮
```

You can also generate random infinite random banded matrices.

```julia-repl
julia> using InfiniteRandomArrays, BandedMatrices

julia> brand(∞, 2)
ℵ₀×ℵ₀ BandedMatrix{Float64} with bandwidths (-2, 2) with data 1×ℵ₀ InfRandMatrix{Float64, InfRandVector{Float64, Type{Float64}, Random.Xoshiro}, Int64, Infinities.Infinity} with indices Base.OneTo(1)×OneToInf() with indices 1:∞×OneToInf():
  ⋅    ⋅   0.723141   ⋅         ⋅         ⋅          ⋅        …
  ⋅    ⋅    ⋅        0.186655   ⋅         ⋅          ⋅
  ⋅    ⋅    ⋅         ⋅        0.676184   ⋅          ⋅
  ⋅    ⋅    ⋅         ⋅         ⋅        0.0671784   ⋅
  ⋅    ⋅    ⋅         ⋅         ⋅         ⋅         0.360374
  ⋅    ⋅    ⋅         ⋅         ⋅         ⋅          ⋅        …
  ⋅    ⋅    ⋅         ⋅         ⋅         ⋅          ⋅
 ⋮                                       ⋮                    ⋱

julia> brandn(∞, ∞, 0, 1)
ℵ₀×ℵ₀ BandedMatrix{Float64} with bandwidths (0, 1) with data 2×ℵ₀ InfRandMatrix{Float64, InfRandVector{Float64, InfiniteRandomArrays.Normal{Float64}, Random.Xoshiro}, Int64, Infinities.Infinity} with indices Base.OneTo(2)×OneToInf() with indices 1:∞×OneToInf():
 -0.194233  1.40483    ⋅          ⋅          ⋅          ⋅        …
   ⋅        1.31805  -0.773853    ⋅          ⋅          ⋅
   ⋅         ⋅        0.396964   0.813132    ⋅          ⋅
   ⋅         ⋅         ⋅        -0.938625  -0.449394    ⋅
   ⋅         ⋅         ⋅          ⋅         0.962001  -0.355942
   ⋅         ⋅         ⋅          ⋅          ⋅        -0.155913  …
   ⋅         ⋅         ⋅          ⋅          ⋅          ⋅
  ⋮                                                    ⋮         ⋱

julia> brandn(2, ∞, -1, 3)
2×ℵ₀ BandedMatrix{Float64} with bandwidths (-1, 3) with data 3×ℵ₀ InfRandMatrix{Float64, InfRandVector{Float64, InfiniteRandomArrays.Normal{Float64}, Random.Xoshiro}, Int64, Infinities.Infinity} with indices Base.OneTo(3)×OneToInf() with indices 1:2×OneToInf():
  ⋅   -0.452139  0.695347   0.0522877    ⋅         ⋅    ⋅    ⋅    ⋅   …
  ⋅     ⋅        0.386502  -1.22294    -0.211329   ⋅    ⋅    ⋅    ⋅

julia> brandn(∞, (-2, 1))
ℵ₀×ℵ₀ BandedMatrix{Float64} with bandwidths (2, 1) with data 4×ℵ₀ InfRandMatrix{Float64, InfRandVector{Float64, InfiniteRandomArrays.Normal{Float64}, Random.Xoshiro}, Int64, Infinities.Infinity} with indices Base.OneTo(4)×OneToInf() with indices 1:∞×OneToInf():
  0.112621   0.228737    ⋅          ⋅         ⋅          ⋅        …  
  0.256487  -0.420693  -0.957109    ⋅         ⋅          ⋅
 -0.348874  -0.979824   0.852881  -1.166      ⋅          ⋅
   ⋅         0.487066   0.961304  -0.197319  0.892409    ⋅
   ⋅          ⋅         0.5048     0.012266  0.150144   1.0133
   ⋅          ⋅          ⋅         0.171971  0.380894  -0.566895  …
   ⋅          ⋅          ⋅          ⋅        0.675937   0.698617
  ⋮                                                     ⋮         ⋱
```