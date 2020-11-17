
local plugin = import("classes.plugin")
local command = import("classes.command")
local this = plugin("test")
local echo = command("echo",function(msg,args,opts)
  msg:reply(args[1])
end)
echo.args = {
  "string"
}
echo.rules:set_user_rule(client.owner.id,1)
echo.rules:set_perm_rules({
  ""
})
this:add_command(echo)
return this
