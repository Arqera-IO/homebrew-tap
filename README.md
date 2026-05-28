# arqera-tap

Homebrew tap for ARQERA tools.

```sh
brew tap Arqera-IO/tap
brew install ara-twin
```

Formulas in this tap are auto-published by [cargo-dist](https://github.com/axodotdev/cargo-dist) on every release of [ara-protocol](https://github.com/Arqera-IO/ara-protocol). Do not edit `Formula/*.rb` by hand — they will be overwritten on the next release.

## Available formulas

- `ara-twin` — reference peer binary (Ed25519 identity, substrate citizen, mesh participant)
- `twin-fs-watcher` — Layer-3 filesystem watcher (39 classification rules)
- `arqera-mcp-server` — MCP server exposing ARQERA primitives to LLM hosts

## License

See individual formulas; ara-protocol is BUSL-1.1.
