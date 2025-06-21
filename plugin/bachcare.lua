-- [[ WORK: Bachcare Plugin ]]
-- Custom Plugin for Bachcare/Sykes related tasks

-- [[ Keymaps ]]
local opts = { noremap = true, silent = true }

-- Try automatically detect the test command
vim.api.nvim_create_user_command("Test", function()
  local file_path = vim.fn.expand "%:p"
  local file_type = vim.fn.fnamemodify(file_path, ":e")
  local original_working_dir = vim.fn.getcwd()
  local php_ext = { "php", "php3", "php4", "php5", "php7", "phtml" }
  local js_ext = { "js", "jsx", "ts", "tsx" }
  -- Possible subdirectories to check for package.json
  local possible_dirs = { "app", "src" }

  -- Find git root directory
  local function find_git_root()
    local current_dir = vim.fn.expand "%:p:h"
    while current_dir ~= "/" do
      if vim.fn.isdirectory(current_dir .. "/.git") == 1 then
        return current_dir
      end
      current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end
    return nil
  end

  -- Find the nearest package.json with a test script
  local function find_package_with_test()
    local package_path = current_dir .. "/package.json"
    if vim.fn.filereadable() then
    end
  end

  -- Check if the file is a test file
  local function is_test_file()
    -- Check if the provided file path is not a directory or an oil buffer
    if vim.fn.isdirectory(file_path) == 1 or string.find(file_path, "oil://") then
      print "Provided path is a directory."
      return false
    end

    -- Check if the file is in a test directory
    local dir = vim.fn.fnamemodify(file_path, ":h")
    while dir ~= "/" do
      if vim.fn.fnamemodify(dir, ":t") == "tests" or vim.fn.fnamemodify(dir, ":t") == "test" then
        print("Test directory found: " .. dir)
        return true
      end
      dir = vim.fn.fnamemodify(dir, ":h")
    end
  end

  -- Build the test command based on the file type
  local function build_test_command()
    local cwd = vim.fn.getcwd()

    -- Get the test command for a PHP file
    local function get_php_test_command()
      local scripts_dir = cwd .. "/scripts"

      -- Check if the scripts directory exists in the project
      if vim.fn.isdirectory(scripts_dir) == 1 then
        return "./scripts/service.sh test --filter " .. vim.fn.fnamemodify(file_path, ":t:r")
      else
        print "No scripts directory found."
      end
    end

    -- Get test command for a JS/TS file
    local function get_js_test_command()
      -- Check if the file is an npm project
      local function is_npm_project()
        local package_json = cwd .. "/package.json"
        return vim.fn.filereadable(package_json) == 1
      end

      -- Check if the npm project has a test script
      local function has_test_script(current_working_dir)
        local test_script = vim.fn.system("jq -r .scripts.test " .. current_working_dir .. "/package.json")
        if string.find(test_script, "null") then
          print(current_working_dir .. "/app")
          if vim.fn.isdirectory(current_working_dir .. "/app") == 1 then
            return has_test_script(current_working_dir .. "/app")
          else
            return false
          end
        end
        print("Test script found: " .. test_script)
        cwd = vim.fn.chdir(current_working_dir)
        return true
      end

      if is_npm_project() and has_test_script(cwd) then
        return "npm run test -- " .. file_path
      else
        print "No package.json or test script found."
      end
    end

    -- [[ Begin Test File Check ]]

    -- If the file is a test file, if not, return
    if is_test_file() then
      print "Test file detected."
    else
      print "Not a test file."
      return
    end

    -- Get the file type and return the appropriate test command
    if vim.tbl_contains(php_ext, file_type) then
      return get_php_test_command()
    elseif vim.tbl_contains(js_ext, file_type) then
      return get_js_test_command()
    else
      print "Unsupported file type for testing."
    end
  end

  local test_command = build_test_command()

  if not test_command then
    return
  end

  -- Open a new tab and run the test command
  vim.cmd.tabnew()
  vim.cmd("terminal " .. test_command)
  vim.api.nvim_feedkeys("i", "n", false)
  vim.fn.chdir(original_working_dir)
end, {
  desc = "Test current file",
})

-- Toggle relative line numbers for screen sharing
vim.api.nvim_create_user_command("ToggleRl", function()
  require("state").set("relative_numbers", not vim.g.relative_numbers)

  if vim.g.relative_numbers then
    vim.cmd ":set relativenumber"
  else
    vim.cmd ":set norelativenumber"
  end

  local status = vim.g.relative_numbers and "enabled" or "disabled"
  vim.notify("Relative line numbering " .. status, vim.log.levels.INFO)
end, {
  desc = "Toggle relative line numbers on/off",
})
