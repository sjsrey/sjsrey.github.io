-- Replace a `::: {.cv-latest section="..." n=3}` div with the first n items
-- of the ordered list that follows the matching heading in cv.qmd, so the
-- home page stays in sync with the CV.

local function read_cv()
  local dir = (quarto and quarto.project and quarto.project.directory) or "."
  local path = pandoc.path.join({ dir, "cv.qmd" })
  local f = io.open(path, "r")
  if not f then
    quarto.log.warning("cv-latest: cannot open " .. path)
    return nil
  end
  local text = f:read("a")
  f:close()
  return pandoc.read(text, "markdown")
end

local cv = nil

function Div(el)
  if not el.classes:includes("cv-latest") then
    return nil
  end
  local section = el.attributes["section"]
  local n = tonumber(el.attributes["n"] or "3")

  cv = cv or read_cv()
  if not cv then
    return nil
  end

  local in_section = false
  for _, blk in ipairs(cv.blocks) do
    if blk.t == "Header" then
      in_section = pandoc.utils.stringify(blk) == section
    elseif in_section and blk.t == "OrderedList" then
      local items = {}
      for i = 1, math.min(n, #blk.content) do
        items[i] = blk.content[i]
      end
      return pandoc.OrderedList(items, blk.listAttributes)
    end
  end

  quarto.log.warning("cv-latest: no list found under heading '" .. tostring(section) .. "' in cv.qmd")
  return nil
end
