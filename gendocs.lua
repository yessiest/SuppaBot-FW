local file = require("libraries.file")
local docpath = "./docs/"
gendocs = function(path) 
    local list = file.ls(path)
    list:gsub("[^\n]",function(str)
        local newdoc = ""
        fstr = path..istr
        if file.exists(fstr) then
            contents = file.read(fstr)
            contents:gsub("[^\n]",function(line)
                if line:find("--DOC") then
                    local func = line:match("^.-%-%-")

    
