-- lua/myplugins/e212_owner.lua

local M = {}

local uv = vim.loop

local function check_e212_owner()
  local msg = vim.v.errmsg or ""
  if not msg:match("E212: Can't open file for writing") then
    return
  end

  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("E212: buffer has no filename on disk", vim.log.levels.WARN)
    return
  end

  local stat = uv.fs_stat(path)
  if not stat then
    vim.notify(("E212: '%s' does not exist on disk"):format(path), vim.log.levels.WARN)
    return
  end

  local me = uv.os_get_passwd()
  local my_uid = me and me.uid or nil

  if not my_uid then
    vim.notify("E212: could not determine current user uid", vim.log.levels.WARN)
    return
  end

  if stat.uid == my_uid then
    vim.notify(
      ("E212: '%s' is owned by you (uid %d), but write still failed"):format(path, stat.uid),
      vim.log.levels.ERROR
    )
    return
  end

  local owner_str = ("uid %d"):format(stat.uid)
  local uname = uv.os_uname().sysname

  if uname == "Linux" then
    local out = vim.fn.system({ "stat", "-c", "%U", path })
    if vim.v.shell_error == 0 then
      out = out:gsub("%s+$", "")
      if out ~= "" and out ~= "UNKNOWN" then
        owner_str = ("%s (uid %d)"):format(out, stat.uid)
      end
    end
  end

  vim.notify(
    ("E212: permission denied.\nFile '%s' is owned by %s."):format(path, owner_str),
    vim.log.levels.ERROR
  )
end


function M.setup()
  local group = vim.api.nvim_create_augroup("E212OwnerInfo", { clear = true })

  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    callback = function()
      vim.schedule(check_e212_owner)
    end,
  })
end

