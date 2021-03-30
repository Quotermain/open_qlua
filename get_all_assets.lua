local utils = require "utils"

file_path = getScriptPath()..'/all_assets.csv'

asset_classes_splited = {'TQBR', 'SPBXM'}
for _, class in ipairs(asset_classes_splited) do
  assets = utils.string_split(getClassSecurities(class))
  for _, asset in ipairs(assets) do
    asset_info = getSecurityInfo(class, asset)
    lot_size = asset_info.lot_size
    price_step = asset_info.min_price_step
    file = io.open(file_path, 'a+')
    file:write(asset..','..class..','..lot_size..','..price_step..'\n')
    file:close()
  end
end
