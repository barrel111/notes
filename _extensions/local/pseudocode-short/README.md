# Pseudocode shorthand

Runs before `leovan/quarto-pseudocode` and supplies its normal source format.
Keep both extensions enabled, in this order:

```yaml
filters:
  - pseudocode-short
  - pseudocode

pseudocode:
  html-line-number: true
  html-comment-delimiter: "▷"
```

Write only the algorithm body:

````markdown
```{.pseudocode #alg-example caption="Example"}
\State $x \gets 1$ \Comment{Initialize}
\Output $x$
```
````

The identifier and caption are optional. Use `@alg-example` for references.
Full `algorithm`/`algorithmic` blocks remain supported; put their caption in
`\caption{...}` rather than a fence attribute.

Override a default on the fence, e.g. `html-line-number=false`, or using the
existing `#| html-line-number: false` directive. Precedence is fence attributes,
then block directives, then project/page `pseudocode` settings.

To reuse, copy this folder into another project's `_extensions/local/`,
install the pseudocode renderer, and add the configuration above. Math-engine
loading and comment alignment/color remain the renderer and site's settings.
