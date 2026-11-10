# Streaming and Sketching

Notes in the shared Quarto website using [math-web](https://github.com/barrel111/math-web)
for LaTeX macros and [thms](https://github.com/barrel111/thms) for theorem
styling and collapsible proofs. Requires Quarto 1.7 or newer.

## Preview and build

Run these commands from `~/Documents/notes/`:

```sh
quarto preview streaming-sketching/index.qmd
```

To build this page in `_site/streaming-sketching/`:

```sh
quarto render streaming-sketching/index.qmd
```

## Edit

- Edit `index.qmd` for the notes page.
- Shared LaTeX commands come from `../latex/`, a symlink to
  `~/Documents/configs/latex/`. Changes to those source files are picked up on render.
- Edit `_metadata.yml` for page-specific options; `../_quarto.yml` controls the shared website. Keep this folder free of a nested `_quarto.yml` so it remains part of the notes site.
- Edit `styles.css` for the page layout, which follows the shared notes site's
  grid layout and supports a right-hand table of contents.
- Add `.qmd` pages and link to them from the page content.
- Give each proof a unique `key` attribute to remember its collapsed state.

## Neovim snippets

The local Neovim LuaSnip configuration shares the `tex` snippets with the
`quarto` filetype used by `.qmd` files. Restart Neovim after changing the
snippet configuration.

In normal mode, `Space l q` starts Quarto preview for the current project
(or the current file outside a project).

| Trigger | In Quarto |
| --- | --- |
| `mm` | Inline math: `$...$` (no padding spaces) |
| `;dm`, `;eq` | Display math: `$$ ... $$` |
| `;ali` | An `aligned` environment inside display math |
| `;a`, `;b`, etc. | Greek letters inside math |
| `ff` after a nonletter | A fraction inside math |
| `__`, `^^` | Subscripts and superscripts inside math |
| `;tb` | Markdown bold |
| `;tii`, `;emp` | Markdown italics |
| `;tt` | Inline code |
| `;tsc` | `[...]{.smallcaps}` |

Math shortcuts require a formula delimited by `$` or `$$`; `mm` and `;dm`
insert both delimiters and place the cursor inside. Matrix and cases triggers
(`pm`, `bm`, `ca`) work at the beginning of a line inside display math.
Formatting snippets work in prose. Snippets are suppressed inside code,
YAML metadata, and HTML comments. Raw LaTeX environment and algorithm snippets
remain specific to `.tex` files.

## Under-construction placeholders

Use a centered amber block with the same left-border treatment as theorem
environments for unfinished material:

```markdown
::: {.under-construction}
⚠️ **Under construction** — proof coming soon.
:::
```

It can stand alone or wrap draft text, equations, or other blocks. If nesting
fenced divs, use more colons on the outer fence than the inner one.

## Drop caps

The first prose paragraph immediately after each main `##` heading gets a
two-line drop cap. Subsections, epigraphs, theorem boxes, and lists are not
selected by this rule. The letter remains ordinary text for copying and
screen readers.

To disable it for a section:

```markdown
## Section title {.no-dropcap}

Opening paragraph without a drop cap.
```

To explicitly add one elsewhere, wrap a paragraph:

```markdown
::: {.dropcap}
Opening paragraph with a drop cap.
:::
```

## Quotations and epigraphs

Ordinary quotations use Markdown blockquotes, styled with a subtle left rule:

```markdown
> Quoted passage goes here.
>
> [— Author, *Work*]{.quote-source}
```

For an epigraph, wrap the same block in an `.epigraph` div. It uses italic
text, a narrower column aligned to the right, and no rule. Place it below the
page title or immediately after a section heading:

```markdown
::: {.epigraph}
> Epigraph text goes here.
>
> [— Author, *Work*]{.quote-source}
:::
```

The attribution is optional. For a bibliography citation, replace `*Work*`
with `[@citation-key]` using a key from the page's bibliography. For multiple
paragraphs, separate them with a line containing only `>`.

## Pseudocode

Write the caption and optional reference label on the fence, then just the
algorithm body. Wrappers and project defaults are supplied automatically:

````markdown
```{.pseudocode #alg-example caption="Example"}
\State $x \gets 1$ \Comment{Initialize}
\Output $x$
```
````

Use `@alg-example` to reference it. Line numbering and the `▷` marker are set
once under `pseudocode:` in `_metadata.yml`. HTML comments are right-aligned and
gray through `styles.css`; write them with `\Comment{...}`. To override a
setting for one block, add e.g. `html-line-number=false` to its fence.

Algorithm commands belong outside math delimiters; use `$...$` only for their
mathematical expressions. Existing full `algorithm`/`algorithmic` blocks also
work. The `pseudocode-short` filter must run before `pseudocode`; its reuse
instructions are in `../_extensions/local/pseudocode-short/README.md`.

The installed pseudocode filter has a local compatibility fix to initialize
on `DOMContentLoaded`, after math-web's deferred KaTeX script is ready.
Updating that extension may replace this fix.

## Configuration

The site uses the `thms-html` format with the `math-web` filter and KaTeX.
It uses EB Garamond, an off-white background, a centered title banner, and a
reading column up to 800px wide with a right-hand table of contents. Body text
scales from 19px to 20px with a line height of 1.5. The content and ToC have
matching 10vw outer insets on desktop. Google Fonts supplies EB Garamond
through `styles.css`.
The `--notes-*` variables at the top of that file control the font size,
leading, reading width, ToC width, and outer insets together.
`--notes-title-gap` controls the space below the title block; the first epigraph
does not add an extra top margin.
The local `toc-start` extension aligns the right-hand ToC with its first linked
section, below the opening epigraphs. It recalculates when fonts or layout
change. See `../_extensions/local/toc-start/README.md` for reuse in other projects
and page-level options.
`../_quarto.yml` imports the preamble's `math-core`, `math-analysis`, `math-prob`,
`math-complexity`, and `math-opt` modules directly. The full `preamble.sty`
also contains LaTeX layout code and is not a web notation input.
Extensions are vendored in `../_extensions/`; keep that directory in version
control. The installed versions are math-web 1.0.0 and thms 1.1.0.

If setting up another checkout with the same sibling `configs/` directory,
create the shared link from the `notes/` directory:

```sh
ln -s ../configs/latex latex
```

To update them, run from the notes root:

```sh
quarto update barrel111/math-web
quarto update barrel111/thms
```
