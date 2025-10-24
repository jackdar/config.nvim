vim.opt_local.makeprg = "node %"
vim.opt_local.errorformat = table.concat({
  "%-G%\\s%#at %.%#", -- FIRST: Ignore stack traces globally
  "%-GNode.js%.%#", -- Ignore: Node.js version line
  "%E%f:%l", -- Start: capture file:line
  "%-C%.%#", -- Continue: skip source code line
  "%-C%\\s%#^", -- Continue: skip ^ pointer
  "%ZError: %m", -- End: capture error message
  "%-G%.%#", -- Ignore: anything else
}, ",")
