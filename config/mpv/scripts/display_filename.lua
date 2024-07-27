function display(_, value)
	if value then
		mp.osd_message("Playing "..value, 5)
	end
end
mp.observe_property("filename/no-ext", "string", display)
