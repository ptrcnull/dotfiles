local utils = require 'mp.utils'

function set_rarbg_subs_path(name, filename)
	if filename ~= nil then
		local path = mp.get_property('path', '')
		local dir, fn = utils.split_path(path)
		local all_sub_dir = utils.join_path(dir, 'Subs')
		local sd = utils.join_path(all_sub_dir, filename)

		local list = utils.readdir(sd, 'files')
		if not list then
			local episode = filename:match("S%d+E%d+")
			local list_of_episode_subs = utils.readdir(all_sub_dir, 'dirs')
			if not list_of_episode_subs then
				return
			end
			local found = nil
			for i, val in pairs(list_of_episode_subs) do
				if val:find(episode, 1, true) then
					found = utils.join_path(all_sub_dir, val)
				end
			end
			if found then
				sd = found
				list = utils.readdir(found, 'files')
				if not list then
					return
				end
			else
				return
			end
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
