return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
    "olimorris/neotest-phpunit",
    "V13Axel/neotest-pest",
  },
  keys = {
    -- Run nearest tests
    vim.keymap.set("n", "<leader>tr", function()
      require("neotest").run.run()
    end, { desc = "Run nearest tests" }),
    -- Run tests in file
    vim.keymap.set("n", "<leader>tf", function()
      require("neotest").run.run(vim.fn.expand "%")
    end, { desc = "Run tests in file" }),
    -- Open floating output window
    vim.keymap.set("n", "<leader>tw", function()
      require("neotest").output()
    end, { desc = "Open floating output window" }),
    -- Open output panel
    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output_panel()
    end, { desc = "Open floating output panel" }),
    -- Open tests summary panel
    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").summary()
    end, { desc = "Open summary panel" }),
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-vitest",
        require "neotest-jest" {
          jestCommand = "npm test --",
          env = { CI = true },
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        },
        require "neotest-phpunit",
        require "neotest-pest",
      },
    }
  end,
}
