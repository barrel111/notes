return {
  Meta = function(meta)
    if not quarto.doc.is_format("html") or meta["toc-start"] == false then return meta end
    local setting = pandoc.utils.stringify(meta["toc-start"] or "first-section")
    if setting ~= "first-section" then
      local number, unit = setting:match("^(%d+%.?%d*)(%a+)$")
      local units = {px = true, rem = true, em = true, vh = true, vw = true}
      assert(number and units[unit], "toc-start: use first-section, false, or a nonnegative CSS length such as 3rem")
    end
    quarto.doc.include_text("in-header", '<meta name="toc-start" content="' .. setting .. '">')
    quarto.doc.add_html_dependency({
      name = "toc-start",
      version = "0.1.0",
      scripts = {"toc-start.js"},
      stylesheets = {"toc-start.css"},
    })
    return meta
  end,
}
