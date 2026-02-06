return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "mrcjkb/rustaceanvim",
    "arthur944/neotest-bun",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
    "olimorris/neotest-phpunit",
    "V13Axel/neotest-pest",
  },
  config = function()
    require("neotest").setup {
      adapters = {
        require "rustaceanvim.neotest",
        require "neotest-vitest",
        require "neotest-bun",
        require "neotest-pest",
        require "neotest-phpunit" {
          phpunit_cmd = "./vendor/bin/phpunit",
          php_cmd = "php",
          cwd = function()
            return vim.fn.getcwd()
          end,
        },
        require "neotest-jest" {
          jestCommand = "npm test --",
          jestArguments = function(defaultArguments)
            return defaultArguments
          end,
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
          isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
        },
      },
    }

    vim.keymap.set("n", "<leader>ts", function()
      require("neotest").run.run()
    end, { desc = "Run nearest test" })

    vim.keymap.set("n", "<leader>tf", function()
      require("neotest").run.run(vim.fn.expand "%")
    end, { desc = "Run tests in current file" })

    vim.keymap.set("n", "<leader>to", function()
      require("neotest").output.open { enter = true }
    end, { desc = "Open test output" })

    vim.keymap.set("n", "<leader>ta", function()
      require("neotest").summary.toggle()
    end, { desc = "Toggle test summary" })

    vim.keymap.set("n", "<leader>tl", function()
      require("neotest").run.run_last()
    end, { desc = "Run last test" })
  end,
}
