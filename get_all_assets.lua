function string_split(string)
  splitted = {}
  for word in string.gmatch(string, '([^,]+)') do
    table.insert(splitted, word)
  end
  return splitted
end


file_path = "C:/Users/Quotermain233/Projects/open_qlua/data/all_assets.csv"

asset_classes_splited = string_split(getClassesList())
for _, class in ipairs(asset_classes_splited) do
  assets = string_split(getClassSecurities(class))
  for _, asset in ipairs(assets) do
    asset_info = getSecurityInfo(class, asset)
    lot_size = asset_info.lot_size
    price_step = asset_info.min_price_step
    file = io.open(file_path, 'a+')
    file:write(asset..','..class..','..lot_size..','..price_step..'\n')
    file:close()
  end
end
