--- @since 25.5.31
--- @sync entry

local function entry()
  local h = cx.active.current.hovered
  if not h then
    return
  end

  ya.emit(h.cha.is_dir and "enter" or "open", { hovered = true })
end

return { entry = entry }
