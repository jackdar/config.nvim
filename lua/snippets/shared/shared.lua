local ls = require "luasnip"
local s, t, i = ls.snippet, ls.text_node, ls.insert_node

return {
  -- [[ Snippets ]]

  -- json object
  s("json", {
    t '{ "',
    i(1, "key"),
    t '": "',
    i(2, "value"),
    t '" }',
  }),

  -- [[ Tests ]]

  -- describe block
  s("desc", {
    t 'describe("',
    i(1, "suite"),
    t { '", () => {', "\t" },
    i(0),
    t { "", "});" },
  }),

  -- it block
  s("it", {
    t 'it("',
    i(1, "should do something"),
    t { '", () => {', "\t" },
    i(0),
    t { "", "});" },
  }),

  -- test block
  s("test", {
    t 'test("',
    i(1, "case"),
    t { '", () => {', "\t" },
    i(0),
    t { "", "});" },
  }),

  -- beforeEach
  s("bef", {
    t { "beforeEach(() => {", "\t" },
    i(0),
    t { "", "});" },
  }),

  -- afterEach
  s("aft", {
    t { "afterEach(() => {", "\t" },
    i(0),
    t { "", "});" },
  }),

  -- expect
  s("exp", {
    t "expect(",
    i(1, "value"),
    t ").",
    i(0),
  }),
}
