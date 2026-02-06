local function rebase_branch()
  -- If master branch exists and no main or development, rebase master
  -- If main branch exists and no master or development, rebase main
  -- If development exists branch, rebase development
  local branches = vim.fn.systemlist "git branch --list"

  -- Trim whitespace from branch names
  for i, branch in ipairs(branches) do
    branches[i] = branch:match "^%s*(.-)%s*$"
  end

  -- Check if branches is empty
  if branches == nil then
    print "No branches found"
    return
  end

  if vim.tbl_contains(branches, "master") then
    vim.cmd "G rebase master"
  elseif vim.tbl_contains(branches, "main") then
    vim.cmd "G rebase main"
  elseif vim.tbl_contains(branches, "development") then
    vim.cmd "G rebase development"
  else
    -- Ask which branch
    local input = vim.fn.input "Rebase onto branch: "
    vim.cmd("G rebase " .. input)
  end
end

return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
    },
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>G", "<cmd>tab Git<CR>")
      vim.keymap.set("n", "<leader>ga", "<cmd>Git add %:p<CR>")
      vim.keymap.set("n", "<leader>gs", "<cmd>G<CR>")
      vim.keymap.set("n", "<leader>gt", "<cmd>Git commit -v -q %:p<CR>")
      vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiff HEAD<CR>")
      vim.keymap.set("n", "<leader>ge", "<cmd>Gedit<CR>")
      vim.keymap.set("n", "<leader>gr", "<cmd>Gread<CR>")
      vim.keymap.set("n", "<leader>gr", "<cmd>Gread<CR>")
      vim.keymap.set("n", "<leader>gc", "<cmd>G checkout -<CR>")
      vim.keymap.set("n", "<leader>gC", "<cmd>G checkout master<CR>")
      vim.keymap.set("n", "<leader>gB", function()
        rebase_branch()
      end)
      vim.keymap.set("n", "<leader>gb", ":G checkout -b ")
      vim.keymap.set("n", "<leader>gl", "<cmd>Git pull<CR>")
      vim.keymap.set("n", "<leader>gp", "<cmd>Git push origin HEAD<CR>")
      vim.keymap.set("n", "<leader>gP", "<cmd>Git push origin HEAD --force<CR>")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk "next"
          end
        end, { desc = "Jump to next git [c]hange" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk "prev"
          end
        end, { desc = "Jump to previous git [c]hange" })

        -- Visual mode
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "stage git hunk" })
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "reset git hunk" })

        -- Normal mode
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
        map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
        map("n", "<leader>hD", function()
          gitsigns.diffthis "@"
        end, { desc = "git [D]iff against last commit" })

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
        map("n", "<leader>tD", gitsigns.preview_hunk_inline, { desc = "[T]oggle git show [D]eleted" })
      end,
    },
  },
}
