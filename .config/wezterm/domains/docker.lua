local wezterm = require("wezterm")

local M = {}

local function list_containers()
  local success, stdout, stderr = wezterm.run_child_process({
    "docker",
    "container",
    "ls",
    "--format",
    "{{.ID}}\t{{.Names}}",
  })

  if not success then
    wezterm.log_warn("Could not list Docker containers: " .. (stderr or "unknown error"))
    return {}
  end

  local containers = {}
  for _, line in ipairs(wezterm.split_by_newlines(stdout)) do
    local id, name = line:match("^([^\t]+)\t(.+)$")
    if id and name then
      table.insert(containers, { id = id, name = name })
    end
  end

  table.sort(containers, function(left, right)
    return left.name < right.name
  end)

  return containers
end

local function make_fixup(id, default_prog)
  return function(cmd)
    local wrapped = { "docker", "exec", "-it", id }

    for _, arg in ipairs(cmd.args or default_prog) do
      table.insert(wrapped, arg)
    end

    cmd.args = wrapped
    cmd.cwd = nil
    return cmd
  end
end

function M.domains(options)
  local default_prog = (options and options.default_prog) or { "/bin/sh" }
  local domains = {}

  for _, container in ipairs(list_containers()) do
    table.insert(
      domains,
      wezterm.exec_domain(
        "docker:" .. container.id,
        make_fixup(container.id, default_prog),
        "Docker: " .. container.name
      )
    )
  end

  return domains
end

return M
