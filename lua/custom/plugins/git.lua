return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
    },
    cmd = { "Git", "G" },
    keys = {
      { "<leader>G", "<cmd>tab Git<CR>" },
      { "<leader>ga", "<cmd>Git add %:p<CR>" },
      { "<leader>gs", "<cmd>G<CR>" },
      { "<leader>gt", "<cmd>Git commit -v -q %:p<CR>" },
      { "<leader>gd", "<cmd>Gvdiff HEAD<CR>" },
      { "<leader>ge", "<cmd>Gedit<CR>" },
      { "<leader>gr", "<cmd>Gread<CR>" },
      { "<leader>gr", "<cmd>Gread<CR>" },
      { "<leader>gc", "<cmd>G checkout -<CR>" },
      { "<leader>gC", "<cmd>G checkout master<CR>" },
      { "<leader>gB", "<cmd>G rebase master<CR>" },
      { "<leader>gb", ":G checkout -b " },
      { "<leader>gl", "<cmd>Git pull<CR>" },
      { "<leader>gp", "<cmd>Git push origin HEAD<CR>" },
      { "<leader>gP", "<cmd>Git push origin HEAD --force<CR>" },
    },
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
