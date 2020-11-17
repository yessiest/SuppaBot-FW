--This class acts as a pipe between the incoming messages and commands.
--It observes the content of the incoming messages, and, depending on the optional flags,
--executes specific commands
--Remember: there can only be one command handler and plugin handler
--per a server handler. Side effects of using multiple command handlers and
--plugin handlers are unknown.
local class = import("classes.baseclass")
local command_handler = class("Command-handler")
local table_utils = import("table-utils")
local purify = import("purify")
function command_handler:__init(parent_server)
  self.server_handler = assert(parent_server,"parent server handler not provided")
  self.command_pool = {}
  self.prefixes = {}
end
function command_handler:add_prefix(prefix)
  local purified_prefix = purify.purify_escapes(prefix)
  self.prefixes[purified_prefix] = purified_prefix
end
function command_handler:remove_prefix(prefix)
  local purified_prefix = purify.purify_escapes(prefix)
  if self.prefixes[purified_prefix] then
    self.prefix[purified_prefix] = nil
  end
end
function command_handler:get_prefixes()
  return table_utils.deepcopy(self.prefixes)
end
function command_handler:add_command(command)
  assert(type(command) == "table","command object expected")
  local purified_name = purify.purify_escapes(command.name)
  self.command_pool[purified_name] = command
end
function command_handler:remove_command(command)
  assert(type(command) == "table","command object expected")
  local purified_name = purify.purify_escapes(command.name)
  if self.command_pool[purified_name] then
    self.command_pool[purified_name] = nil
  end
end
function command_handler:handle(message)
  for name,command in pairs(self.command_pool) do
    if command.options.regex then
      if message.content:match(command.options.regex) then
        command:exec(message)
        return
      end
    else
      if command.options.prefix then
        for _,prefix in pairs(self.prefixes) do
          if message.content:find(prefix..name.."$") == 1 or message.content:find(prefix..name.."%s") then
            command:exec(message)
            return
          end
        end
      else
        if message.content:find(name.."$") == 1 or message.content:find(name.."%s") then
          command:exec(message)
          return
        end
      end
    end
  end
end
return command_handler
