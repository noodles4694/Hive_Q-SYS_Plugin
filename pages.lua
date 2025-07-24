
for i=1, layer_count do
  --table.insert(PageNames, "Layer " .. i .. " Parameters")
end
for ix,name in ipairs(PageNames) do
  table.insert(pages, {name = PageNames[ix]})
end