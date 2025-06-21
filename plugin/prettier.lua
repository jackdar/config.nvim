if not _G.prettierrc_cache then
  _G.prettierrc_cache = {}
end

local function set_colorcolumn_from_prettier()
  local buf_dir = vim.fn.expand "%:p:h"

  local function get_cached_config(dir)
    local current_dir = dir
    while current_dir ~= "/" do
      if _G.prettierrc_cache[current_dir] then
        return _G.prettierrc_cache[current_dir], current_dir
      end
      current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end
    return nil, nil
  end

  local cached_config, cache_dir = get_cached_config(buf_dir)
  if cached_config then
    if cached_config.printWidth then
      vim.opt_local.colorcolumn = tostring(cached_config.printWidth)
    end
    return
  end

  local function find_prettierrc(start_dir)
    local current_dir = start_dir
    while current_dir ~= "/" do
      local prettierrc_path = current_dir .. "/.prettierrc"
      if vim.fn.filereadable(prettierrc_path) == 1 then
        return prettierrc_path, current_dir
      end

      local prettierrc_json_path = current_dir .. "/.prettierrc.json"
      if vim.fn.filereadable(prettierrc_json_path) == 1 then
        return prettierrc_json_path, current_dir
      end
      current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end
    return nil, nil
  end

  local prettierrc_path, config_dir = find_prettierrc(buf_dir)
  if not prettierrc_path then
    _G.prettierrc_cache[buf_dir] = {}
    return
  end

  local file = io.open(prettierrc_path, "r")
  if not file then
    _G.prettierrc_cache[config_dir] = {}
    return
  end

  local content = file:read "*all"
  file:close()

  local ok, json = pcall(vim.fn.json_decode, content)
  if not ok then
    _G.prettierrc_cache[config_dir] = {}
    return
  end

  _G.prettierrc_cache[config_dir] = json

  local print_width = json.printWidth
  if print_width and type(print_width) == "number" then
    vim.opt_local.colorcolumn = tostring(print_width)
  end
end

local function clear_prettierrc_cache()
  _G.prettierrc_cache = {}
  print "Prettier cache cleared"
end

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.html,*.css,*.svg,*.json,*.js,*.jsx,*.mjs,*.ts,*.tsx,*.mts",
  callback = set_colorcolumn_from_prettier,
  group = vim.api.nvim_create_augroup("PrettierColorColumn", { clear = true }),
})

vim.api.nvim_create_user_command("PrettierClearCache", clear_prettierrc_cache, {
  desc = "Clear the Prettier configuration cache",
})
