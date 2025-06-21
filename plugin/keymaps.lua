-- [[ Keymaps ]]
local function map(mode, l, r, opts)
  opts = opts or {}
  opts.noremap = true
  opts.silent = true

  vim.keymap.set(mode, l, r, opts)
end

map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make the current file executable" })
map("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

map("n", "<M-,>", "<c-w>5<", { desc = "Move split to the left by 5 columns" })
map("n", "<M-.>", "<c-w>5>", { desc = "Move split to the right by 5 columns" })
map("n", "<M-t>", "<C-W>+", { desc = "Move split up by 1 row" })
map("n", "<M-s>", "<C-W>-", { desc = "Move split down by 1 row" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights on search when <Esc> in normal mode" })
map("n", "<leader>w", ":noautocmd w %<CR>", { desc = "Quick [W]rite the current buffer with no auto commands" })

map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

map("t", "<Esc><Esc>", "<Esc><C-\\><C-n>", { desc = "Exit terminal mode" })

map("x", "<leader>p", '"_dP', { desc = "Delete into void register when pasting" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete into void register" })
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank into system clipboard" })
map("n", "<leader>D", '"_d$', { desc = "Delete to end of line into void register" })
map("n", "<leader>Y", '"+y$', { desc = "Yank to end of line into the system clipboard" })

map("n", "<leader>%", "<cmd>let @+=@%<CR>", { desc = "Copy file path to system clipboard" })

map("n", "<C-d>", "<C-d>zz", { desc = "Vertical scroll and center on <C-d>" })
map("n", "<C-u>", "<C-u>zz", { desc = "Vertical scroll and center on <C-u>" })

map("n", "n", "nzzzv", { desc = "Find and center on [n]" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move a line up in visual mode" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move a line down in visual mode" })

map("n", "J", "mzJ`z", { desc = "Keep cursor in same place when [J]oining lines" })

map("n", "<C-d>", "<C-d>zz", { desc = "Vertical scroll and center on <C-d>" })
map("n", "<C-u>", "<C-u>zz", { desc = "Vertical scroll and center on <C-u>" })

map("n", "n", "nzzzv", { desc = "Find and center on [n]" })
map("n", "N", "Nzzzv", { desc = "Find and center on [N]" })

map("v", "<", "<gv", { desc = "Stay in visual mode after indenting" })
map("v", ">", ">gv", { desc = "Stay in visual mode after indenting" })

map("n", "<leader>bd", "<cmd>bd!<CR>", { desc = "Close the current buffer" })
map("n", "<leader>bc", "<cmd>enew<CR>", { desc = "Create a new buffer" })

map("n", "<leader>m", "<cmd>make run<CR>", { desc = "Quickly make run from Makefile" })
map("n", "<leader>M", "<cmd>make build<CR>", { desc = "Quickly make build from Makefile" })

map("i", "<C-r>", "<C-r><C-o>", { desc = "Insert contents of named register literally" })

map("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", {
  desc = "Toggle find and replace for the word under the cursor",
})
map("v", "<leader>s", 'y:%s/\\V<C-r>"/<C-r>"/gI<Left><Left><Left>', {
  desc = "Toggle find and replace for a visual selection",
})

map("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrapping" })
map("n", "<leader>ln", function()
  vim.g.RELATIVENUMBER = not vim.g.RELATIVENUMBER
  vim.cmd "set relativenumber!"
  vim.notify("Relative line numbering " .. (vim.g.RELATIVENUMBER and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Quickly toggle relative line numbering" })
