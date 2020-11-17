package.path = "./libraries/?.lua;./libraries/?/init.lua;"..package.path

--load discordia
discordia = require("discordia")
color = require("tty-colors")
client = discordia.Client()

--activate the import system
local import = require("import")(require)
local server = import("classes.server-handler")
client:on("ready",function()
  print("starting test")
  local new_server = server(client,client:getGuild("640251445949759499"),{
  
  })
end)
local tempfile = io.open("./token","r")
if not tempfile then
  error(color("./token file does not exist","light red"))
end
local nstr = tempfile:read("*l")
tempfile:close()
client:run('Bot '..nstr)
