--This class acts as a pipe between the incoming messages and commands.
--It observes the content of the incoming messages, and, depending on the optional flags,
--executes specific commands
--Remember: there can only be one command handler and plugin handler
--per a server handler. Side effects of using multiple command handlers and
--plugin handlers are unknown.
local class = import("classes.baseclass")
local command_handler = class("Command-handler")
function command_handler:__init(parent_server)
  self.server_handler = assert(parent_server,"parent server handler not provided")
  self.command_pool = {}
  self.prefixes = {}
end
function command_handler:add_prefix(prefix)
  self.prefixes[prefix] = prefix
end
function command_handler:remove_prefix(prefix)
  if self.prefixes[prefix] then
    self.prefix[prefix] = nil
  end
end
function command_handler:add_command(command)
  assert(type(command) == "table","command object expected")
  self.command_pool[command.name] = command
end
function command_handler:remove_command(command)
  assert(type(command) == "table","command object expected")
  if self.command_pool[command.name] then
    self.command_pool[command.name] = nil
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
          if message.content:find(prefix..command.name,1,true) == 1 then
            command:exec(message)
            return
          end
        end
      else
        if message.content:find(command.name,1,true) == 1 then
          command:exec(message)
          return
        end
      end
    end
  end
end
return command_handler
