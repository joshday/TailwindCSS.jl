using TailwindCSS
using Cobweb: h, Page
using Test

"text-xl"  # Tailwind CLI should write this CSS into it's output

@testset "TailwindCSS.jl" begin
    input = joinpath(@__DIR__, "input.css")
    output = joinpath(@__DIR__, "output.css")
    config = Dict("content" => ["*.jl"])

    rm(output, force=true)

    TailwindCSS.minify(input, output, config)

    @test any(x -> occursin("text-xl", x), eachline(output))
end
