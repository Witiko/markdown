#!/usr/bin/env texlua
local ran_ok, kpse = pcall(require, "kpse")
if ran_ok then kpse.set_program_name("luatex") end
local markdown = require("markdown")

for _ = 1, 100 do
  markdown.new({singletonCache = false})("Hello *world*!")
end
