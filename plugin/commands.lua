-- Initialize copilot as disabled by default
vim.g.copilot_enabled = false

-- Toggle Copilot command
vim.api.nvim_create_user_command("CopilotToggle", function()
  if vim.g.copilot_enabled then
    -- Disable copilot
    vim.g.copilot_enabled = false

    -- Stop copilot if it's running
    local ok, copilot = pcall(require, "copilot")
    if ok and copilot then
      vim.cmd("Copilot detach")
    end

    print("Copilot disabled")
  else
    -- Enable copilot
    vim.g.copilot_enabled = true

    -- Lazy load copilot
    require("lazy").load({ plugins = { "copilot.lua" } })

    print("Copilot enabled")
  end
end, { desc = "Toggle Copilot on/off" })
