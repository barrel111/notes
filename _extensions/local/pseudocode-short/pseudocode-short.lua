local function stringify(value)
  if type(value) == "boolean" then return tostring(value) end
  return pandoc.utils.stringify(value)
end

local function unquote(value)
  local quote = value:sub(1, 1)
  if (quote == '"' or quote == "'") and value:sub(-1) == quote then
    return value:sub(2, -2)
  end
  return value
end

return {
  Pandoc = function(doc)
    local defaults = doc.meta.pseudocode or {}
    return doc:walk({
      CodeBlock = function(block)
        if not block.classes:includes("pseudocode") then return nil end

        -- Preserve the original option syntax. Fence attributes take precedence
        -- over block directives, which take precedence over project defaults.
        local options, lines, in_body = {}, {}, false
        for line in (block.text .. "\n"):gmatch("(.-)\n") do
          local key, value = line:match("^%s*#|%s*([%w_-]+):%s*(.-)%s*$")
          if not in_body and key then
            options[key] = unquote(value)
          elseif not in_body and line:match("^%s*$") then
            -- Leading whitespace is not part of the algorithm body.
          else
            in_body = true
            lines[#lines + 1] = line
          end
        end
        for key, value in pairs(block.attributes) do options[key] = value end
        if block.identifier ~= "" then options.label = block.identifier end

        for _, key in ipairs({
          "html-line-number", "html-comment-delimiter", "html-line-number-punc",
          "html-indent-size", "html-no-end", "html-indent-lines",
          "pdf-line-number", "pdf-right-comment", "pdf-comment-delimiter",
        }) do
          if options[key] == nil and defaults[key] ~= nil then
            options[key] = stringify(defaults[key])
          end
        end

        local caption = options.caption or options.title
        options.caption, options.title = nil, nil
        local body = table.concat(lines, "\n")
        if not body:match("\\begin%s*{algorithm}") then
          if not body:match("\\begin%s*{algorithmic}") then
            body = "\\begin{algorithmic}\n" .. body .. "\n\\end{algorithmic}"
          end
          local heading = caption and ("\\caption{" .. caption .. "}\n") or ""
          body = "\\begin{algorithm}\n" .. heading .. body .. "\n\\end{algorithm}"
        else
          assert(not caption,
            "pseudocode-short: use the caption attribute with a bare body, or \\caption inside a complete algorithm")
        end

        local keys, output = {}, {}
        for key in pairs(options) do keys[#keys + 1] = key end
        table.sort(keys)
        for _, key in ipairs(keys) do
          local value = stringify(options[key])
          assert(not value:find("[\r\n]"), "pseudocode-short: options must fit on one line")
          -- Quotes also let the renderer's option parser accept one-character
          -- values such as a custom comment marker or line-number separator.
          output[#output + 1] = "#| " .. key .. ': "' .. value .. '"'
        end
        output[#output + 1] = body
        return pandoc.CodeBlock(table.concat(output, "\n"), pandoc.Attr("", {"pseudocode"}))
      end,
    })
  end,
}
