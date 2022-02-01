module TailwindCSS

using Pkg.Artifacts
using Scratch
using JSON3

function __init__()
    global DIR = get_scratch!("TailwindCSS")
end

#-----------------------------------------------------------------------------# artifacts
artifacts_toml = joinpath(@__DIR__, "..", "Artifacts.toml")
prefix = "https://github.com/tailwindlabs/tailwindcss/releases/download/v3.0.18"
tailwindcli_hash = artifact_hash("tailwindcli", artifacts_toml)

if tailwindcli_hash == nothing || !artifact_exists(tailwindcli_hash)
    tailwindcli_hash = create_artifact() do dir
        url = if Sys.isapple() && Sys.ARCH === :aarch64
            "$prefix/tailwindcss-macos-arm64"
        elseif Sys.isapple() && Sys.ARCH === :x86_64
            "$prefix/tailwindcss-macos-x64"
        elseif Sys.islinux() && Sys.ARCH === :aarch64
            "$prefix/tailwindcss-linux-arm64"
        elseif Sys.islinux() && Sys.ARCH === :x86_64
            "$prefix/tailwindcss-linux-x64"
        elseif Sys.iswindows()
            "$prefix/tailwindcss-windows-x64.exe"
        else
            error("TailwindCSS does not provide a CLI for your machine: $(Sys.MACHINE)")
        end
        download(url, joinpath(dir, "tailwindcli"))
        chmod(joinpath(dir, "tailwindcli"), 0o770, recursive=true)
    end
    bind_artifact!(artifacts_toml, "tailwindcli", tailwindcli_hash)
end
cli = joinpath(artifact_path(tailwindcli_hash), "tailwindcli")


#-----------------------------------------------------------------------------# function
help() = run(`$cli -h`)

#-----------------------------------------------------------------------------# init
"""
    init(file::String)
    init(file::String, config::AbstractDict)

Create a `tailwind.config.js` file, optionally using entries in `config`.

# Example

    using TailwindCSS: init

    init("tailwind.config.js", Dict("content" => ["*.html", "*.js"]))
"""
function init(file::String = "")
    args = [cli, "init"]
    !isempty(file) && push!(args, file)
    run(`$args`)
end
function init(file::String, config::AbstractDict)
    open(touch(file), "w") do io
        print(io, "module.exports = ")
        JSON3.write(io, config)
    end
end

#-----------------------------------------------------------------------------# minify
"""
    minify(inputfile, outputfile, config)

Write a minified CSS file `outputfile` based on `inputfile` and `config`.

- `config` can be a `String` (path to tailwind.config.js) or an `AbstractDict` (see `TailwindCSS.init`).
"""
function minify(input::String, output::String, config::String)
    args = [cli, "--input", input, "--output", output, "--config", config, "--minify"]
    run(`$args`)
end

function minify(input::String, output::String, config::AbstractDict)
    file = joinpath(DIR, "generated_tailwind.config.js")
    config = init(file, config)
    minify(input, output, file)
end

end
