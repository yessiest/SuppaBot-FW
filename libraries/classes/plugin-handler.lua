--This class manages the loading, unloading, scanning and event manipulation for plugin objects
--This class requries communication between itself and the command handler
--in order to load commands.
--Remember: there can only be one command handler and plugin handler
--per a server handler. Side effects of using multiple command handlers and
--plugin handlers are unknown.
local class = import("classes.baseclass")
local plugin_handler = class("PluginHandler")
local file = import("file")
local json = import("json")
local core = import("core")
local emitter_proxy = import("classes.emitter-proxy")

function plugin_handler:__init(parent_server)
  assert(parent_server,"server handler to assign the plugin handler to has not been provided")
  self.server_handler = parent_server
  self.plugins = {}
  self.plugin_info = {}
  self.plugin_paths = {}
end

function plugin_handler:add_plugin_folder(path)
  assert(type(path) == "string","path should be a string, got "..type(path))
  table.insert(self.plugin_paths,path)
end

function plugin_handler:scan_folder(path)
  local file = io.open(path.."/meta.json","r")
  if file then
    local metadata,code,err = json.decode(file:read("*a"))
    if metadata and metadata.name then
      self.plugin_info[metadata.name] = metadata
      self.plugin_info[metadata.name].path = path.."/"
    end
    file:close()
  else
    for k,v in pairs({"/init.lua","/main.lua"}) do
      local file = io.open(path..v,"r")
      if file then
        local name = path:match("[^/]+$")
        self.plugin_info[name] = {["main"]="init.lua"}
        self.plugin_info[name].path = path.."/"
        file:close()
      end
    end
  end
end

function plugin_handler:update_plugin_info()
  for k,v in pairs(self.plugin_paths) do
    if file.existsDir(v) then
      file.ls(v):gsub("[^\n]+",function(c)
        self:scan_folder(v..c)
      end)
    end
  end
end

function plugin_handler:load(name)
  local environment = setmetatable({
    id = self.server_handler.id,
    globals = self.server_handler.config,
    signals = emitter_proxy(self.server_handler.signal_emitter),
    client = self.server_handler.client,
    events = emitter_proxy(self.server_handler.event_emitter),
    discordia = import("discordia"),
    server = self.server_handler,
    command_handler = self.server_handler.command_handler,
    plugin_handler = self.server_handler.plugin_handler,
    log = function() end,
    import = import,
  },{__index = _G})
  local plugin_meta = self.plugin_info[name]
  if not self.plugin_info[name] then
    return false, "No such plugin"
  end
  if not self.plugin_info[name].main then
    return false, "Plugin metadata entry exists, but the main file isn't specified"
  end
  if file.exists(plugin_meta.path..plugin_meta.main) then
    environment["plugin_path"] = plugin_meta.path
    local plugin_content = file.read(plugin_meta.path..plugin_meta.main,"*a")
    local plugin_loader,err = load(plugin_content,"plugin loader",nil,environment)
    if plugin_loader then
      local plugin_object = plugin_loader()
      plugin_object:load(environment)
      self.plugins[name] = plugin_object
      self.plugins[name].__env = environment
      return true
    else
      return false, err
    end
  else
    return false, "File specified as main does not exist"
  end
end

function plugin_handler:unload(name)
  if self.plugins[name] then
    self.plugins[name].__env.signal_handler:destroy()
    self.plugins[name].__env.event_handler:destroy()
    self.plugins[name]:unload()
  end
end
return plugin_handler
