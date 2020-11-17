
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
--yeaaaaaaa we're stealing that awesomewm inbetween declarative and imperative style
--because of course i aint porting that entire library of stupid shit
--ALLL of that. nah
local prefix = command("prefix",{
  help = "Set prefix",
  usage = "prefix [(add | remove | list (default)) [<new prefix>]]",
  users = {
    [client.owner.id] = 1
  },
  roles = {
    ["747042157185073182"] = 1
  },
  perms = {
    "administrator"
  },
  callback = function(msg,args,opts)
    local function list_prefixes(msg)
      local prefixes = ""
      for k,v in pairs(command_handler:get_prefixes()) do
        prefixes = prefixes..v.."\n"
      end
      msg:reply({embed = {
        title = "Prefixes for this server",
        description = prefixes
      }})
    end
    if args[1] then
      if args[1] == "add" and args[2] then
        command_handler:add_prefix(args[2])
        msg:reply("Added "..args[2].." as a prefix")
      elseif args[1] == "remove" and args[2] then
        command_handler:remove_prefix(args[2])
      elseif args[1] == "list" then
        list_prefixes(msg)
      else
        msg:reply("Syntax error")
      end
    else
      list_prefixes(msg)
    end
  end
})
this:add_command(prefix)
this:add_command(echo)
return this
