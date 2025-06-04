-- [[ State Management ]]
local M = {}

local function setup_tracked_variables()
  M.add('have_nerd_font', true)
  M.add('node_host_prog', vim.fn.expand '$HOME/.local/share/fnm/node-versions/v22.15.0/installation/bin')
  M.add('copilot_enabled', true)
  M.add('auto_format', true)
  M.add('lsp_diagnostics_enabled', true)
  M.add('colorscheme', 'rose-pine')
  M.add('relative_numbers', true)

  vim.api.nvim_create_user_command('State', function()
    vim.cmd(':lua require(\'state\').list()')
  end, {})
end

local state_file = vim.fn.stdpath 'state' .. '/nvim-globals.lua'

-- Load state from file
local function load_state()
  local file = io.open(state_file, 'r')
  if not file then
    -- Create empty state file if it doesn't exist
    save_state {}
    return {}
  end

  local content = file:read '*all'
  file:close()

  if not content or content:match '^%s*$' then
    return {}
  end

  local chunk, err = load('return ' .. content)
  if not chunk then
    vim.notify('State load error: ' .. err, vim.log.levels.WARN)
    return {}
  end

  local ok, state = pcall(chunk)
  if not ok or type(state) ~= 'table' then
    vim.notify('State parse error', vim.log.levels.WARN)
    return {}
  end

  return state
end

-- Save state to file
function save_state(state)
  local state_dir = vim.fn.fnamemodify(state_file, ':h')
  if vim.fn.isdirectory(state_dir) == 0 then
    vim.fn.mkdir(state_dir, 'p')
  end

  local file = io.open(state_file, 'w')
  if not file then
    vim.notify('Cannot write state file', vim.log.levels.ERROR)
    return false
  end

  file:write '{\n'
  for key, value in pairs(state) do
    if type(key) == 'string' and (type(value) == 'string' or type(value) == 'number' or type(value) == 'boolean') then
      local formatted_value = type(value) == 'string' and string.format('%q', value) or tostring(value)
      file:write('  ' .. key .. ' = ' .. formatted_value .. ',\n')
    end
  end
  file:write '}\n'
  file:close()
  return true
end

-- Get current state (what's actually in the file)
local function get_current_state()
  local state = {}
  local file_state = load_state()

  -- Merge file state with current vim globals
  for key in pairs(file_state) do
    state[key] = vim.g[key]
  end

  return state
end

-- Initialize - load state and set vim globals, then setup tracked variables
function M.init()
  local state = load_state()

  -- Set vim globals for all keys in state file
  for key, value in pairs(state) do
    vim.g[key] = value
  end

  -- Setup tracked variables (only adds new ones, doesn't overwrite existing)
  setup_tracked_variables()
end

-- Set a tracked global and save
function M.set(key, value)
  local state = load_state()

  -- Only save if this key is already tracked
  if state[key] ~= nil then
    vim.g[key] = value
    state[key] = value
    save_state(state)
  else
    vim.notify('Global "' .. key .. '" is not tracked. Use add() first.', vim.log.levels.WARN)
  end
end

-- Add a new global to be tracked (with safety check for existing)
function M.add(key, value)
  if type(key) ~= 'string' then
    vim.notify('Key must be a string', vim.log.levels.ERROR)
    return false
  end

  if not (type(value) == 'string' or type(value) == 'number' or type(value) == 'boolean') then
    vim.notify('Value must be string, number, or boolean', vim.log.levels.ERROR)
    return false
  end

  local state = load_state()

  -- Only add if it doesn't already exist (prevents overwriting saved values)
  if state[key] == nil then
    state[key] = value
    vim.g[key] = value
    save_state(state)
  end

  return true
end

-- Remove a global from tracking
function M.remove(key)
  local state = load_state()

  if state[key] == nil then
    vim.notify('Global "' .. key .. '" is not tracked', vim.log.levels.WARN)
    return false
  end

  state[key] = nil
  vim.g[key] = nil

  return save_state(state)
end

-- Save all currently tracked globals
function M.save()
  local state = get_current_state()
  return save_state(state)
end

-- List all tracked globals
function M.list()
  local state = load_state()

  for key, value in pairs(state) do
    print(key .. ': ' .. tostring(value))
  end
end

-- Check if a global is tracked
function M.is_tracked(key)
  local state = load_state()
  return state[key] ~= nil
end

return M
