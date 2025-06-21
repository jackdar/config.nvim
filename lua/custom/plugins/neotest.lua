return {
  "nvim-neotest/neotest",
  event = "VeryLazy",
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
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-vitest",
        require "neotest-jest" {
          jest_test_discovery = false,
        },
        require "neotest-phpunit",
        require "neotest-pest",
      },
    }

    -- Run nearest tests
    -- vim.keymap.set("n", "<leader>tr", "<cmd>Neotest run<CR>", { desc = "Run nearest tests" })
    vim.keymap.set("n", "<leader>tr", '<cmd>lua require("neotest").run.run()<CR>', { desc = "Run nearest tests" })
    vim.keymap.set("n", "<leader>tf", '<cmd>lua require("neotest").run.run(vim.fn.expand "%")<CR>', { desc = "Run nearest tests" })
    vim.keymap.set("n", "<leader>td", '<cmd>lua require("neotest").run.run(vim.fn.fnamemodify(vim.fn.expand "%", ":h"))<CR>', { desc = "Run nearest tests" })
    vim.keymap.set("n", "<leader>ta", '<cmd>lua require("neotest").run.run(vim.fn.getcwd())<CR>', { desc = "Run nearest tests" })
    vim.keymap.set("n", "<leader>[t", '<cmd>lua require("neotest").jump.prev({ status = "failed" })<CR>', { desc = "Run nearest tests" })
    vim.keymap.set("n", "<leader>]t", '<cmd>lua require("neotest").jump.next({ status = "failed" })<CR>', { desc = "Run nearest tests" })

    -- Run tests in file
    -- vim.keymap.set("n", "<leader>tf", "<cmd>Neotest run file %<CR>", { desc = "Run tests in file" })
    -- vim.keymap.set("n", "<leader>tf", function()
    --   require("neotest").run.run(vim.fn.expand "%")
    -- end, { desc = "Run tests in file" })

    -- Run tests in directory
    -- vim.keymap.set("n", "<leader>td", function()
    --   require("neotest").run.run(vim.fn.fnamemodify(vim.fn.expand "%", ":h"))
    -- end, { desc = "Run tests in directory" })

    -- Run test suite
    -- vim.keymap.set("n", "<leader>ta", function()
    --   require("neotest").run.run(vim.fn.getcwd())
    -- end, { desc = "Run test suite" })

    -- Open floating output window
    vim.keymap.set("n", "<leader>tw", "<cmd>Neotest output<CR>", { desc = "Open floating output window" })

    -- Open output panel
    vim.keymap.set("n", "<leader>to", "<cmd>Neotest output-panel<CR>", { desc = "Open floating output panel" })

    -- Open tests summary panel
    vim.keymap.set("n", "<leader>ts", "<cmd>Neotest summary<CR>", { desc = "Open summary panel" })
  end,
}
