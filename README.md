<h1 align="center">TailwindCSS</h1>


### Use the [TailwindCSS CLI](https://tailwindcss.com/blog/standalone-cli) from Julia.

## Basic Usage

- Two main functions are `init` and `minify`

### `init`

    init(file::String)
    init(file::String, config::AbstractDict)

Create a tailwind.config.js file, optionally using entries in config.

```julia
    using TailwindCSS: init

    init("tailwind.config.js", Dict("content" => ["*.html", "*.js"]))
```

### `minify`

    minify(inputfile, outputfile, config)

Write a minified CSS file (`outputfile`) based on `inputfile` (.css) and `config` (tailwind.config.js).

- `config` can be a `String` (path to tailwind.config.js) or an `AbstractDict` (see `TailwindCSS.init`).


## Manually using the CLI

- Type in `TailwindCSS.help()` to display the CLI's help.
- You can then run arbitrary commands with:

```julia
run(`$(TailwindCSS.cli) $args`)
```
