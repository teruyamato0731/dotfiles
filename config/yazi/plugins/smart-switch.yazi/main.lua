--- @sync entry

local function entry(_, job)
  local idx = tonumber(job.args[1])
  if not idx then
    ya.dbg("smart-switch: missing tab index")
    return
  end

  local cur = cx.active.current

  for _ = #cx.tabs, idx do
    ya.emit("tab_create", { cur.cwd })
    if cur.hovered then
      ya.emit("reveal", { cur.hovered.url })
    end
  end

  ya.emit("tab_switch", { idx })
end

return { entry = entry }
