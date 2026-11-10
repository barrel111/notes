# TOC start position

Align the right-hand Quarto ToC with its first linked section. The offset is
measured from the rendered page, including any opening epigraphs. Font loading,
resizing, and changes to epigraph height trigger a fresh measurement.

The extension changes the sidebar's initial margin on desktop. Quarto continues
to control its sticky top inset, scrolling, and mobile navigation.

## Enable

```yaml
filters:
  - toc-start

toc-start: first-section
```

Use a CSS length such as `toc-start: 3rem` for a fixed additional starting
margin, or `toc-start: false` in a page's front matter to opt out. This targets
Quarto's standard right-hand article ToC at widths of 992px and above. It has
no effect when there is no right-hand ToC.

## Reuse

Copy this directory into `_extensions/local/toc-start/` in another project and
add the YAML above to its `_quarto.yml`. It works alongside `thms-html`,
`math-web-html`, or ordinary Quarto HTML; it does not modify those extensions.

For central updates across repositories, move this extension into its own
repository with the same `_extensions/local/toc-start/` structure, then install
it in each project with `quarto add OWNER/REPOSITORY`. Commit installed copies
to retain reproducible builds. No publishing is needed for local reuse.
