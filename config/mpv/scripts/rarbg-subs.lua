local utils = require 'mp.utils'

function set_rarbg_subs_path(name, value)
       if value ~= nil then
               local path = mp.get_property('path', '')
               local dir, fn = utils.split_path(path)
               local sd = utils.join_path(dir, 'Subs/' .. value)

               local list = utils.readdir(sd, 'files')
               if not list then
                       return
               end

               table.sort(list)
               for i = 1,#list do
                       local sub = string.match(list[i], 'eng')
                       if sub then
                               mp.commandv('sub-add', utils.join_path(sd, list[i]), 'select')
                       end
               end
       end
end
mp.observe_property("filename/no-ext", "string", set_rarbg_subs_path)
