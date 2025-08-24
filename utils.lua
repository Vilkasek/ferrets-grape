function contains(table, element)
	for _, value in ipairs(table) do
		if value == element then
			return true
		end
	end

	return false
end
