# Apple Health Parser Web

A static, single-page version of [`apple-health-parser`](https://github.com/alxdrcirilo/apple-health-parser) year recap. Runs entirely in the browser via [Pyodide](https://pyodide.org). The `export.zip` is parsed and rendered client-side.

## Local development

Requires this repo to sit next to a checked-out `apple-health-parser` repo (`../apple-health-parser`), since the local dev wheel is built from that checkout rather than from PyPI.

```bash
make run    # builds the wheel, serves this directory, opens it in your browser
make stop   # stops the background server started by `make run`
```

Or step by step:

```bash
make wheel  # build the apple-health-parser wheel into dist/
make serve  # serve this directory at http://localhost:8743 (foreground)
```

A `sample-export.zip` fixture is included for a quick smoke test (use year `2024`).

## How it works

`index.html` loads Pyodide and Plotly.js from a CDN, installs `apple-health-parser` dependencies via `micropip`, then calls `generate_recap_report_html()` directly. Exporting to PDF reuses the CLI's `get_recap_report()`, rasterizing each chart to a PNG with `Plotly.toImage()` client-side instead of `kaleido`, which can't run in a browser sandbox.
