--- @since 25.12.29
--- @sync entry

local normal_ratio

local function set_ratio(ratio)
  rt.mgr.ratio = ratio
  ui.render()
end

local function focus_preview()
  if normal_ratio then
    return
  end

  local ratio = rt.mgr.ratio
  normal_ratio = { ratio.parent, ratio.current, ratio.preview }
  set_ratio { 1, 2, 5 }
end

local function unfocus_preview()
  if not normal_ratio then
    return false
  end

  local ratio = normal_ratio
  normal_ratio = nil
  set_ratio(ratio)
  return true
end

local function entry(_, job)
  local action = job.args[1]

  if action == "right" then
    local hovered = cx.active.current.hovered
    if not hovered then
      return
    end

    if hovered.cha.is_dir then
      unfocus_preview()
      ya.emit("enter", {})
    else
      focus_preview()
    end
  elseif action == "left" then
    if not unfocus_preview() then
      ya.emit("leave", {})
    end
  end
end

return { entry = entry }
