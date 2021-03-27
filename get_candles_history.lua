local utils = require "utils"

path = getScriptPath()..'/'
table_of_assets = {['TQBR']={}, ['SPBXM']={}}
function OnInit()
  for class in pairs(table_of_assets) do
    assets = utils.string_split(getClassSecurities(class))
    for _, asset in ipairs(assets) do
      ds, Error = CreateDataSource(class, asset, INTERVAL_M1)
      table_of_assets[class][asset]=ds
    end
  end
end

is_run = true
function main()
  while is_run do
    for class in pairs(table_of_assets) do
      for asset, ds in pairs(table_of_assets[class]) do
        ds:SetEmptyCallback()
        if ds:Size() ~= 0 then
          file = io.open(path..'data/prices/'..asset..'.csv', 'w')
          file:write('open, high, low, close\n')
          for i = 1, ds:Size() do
            line = ds:O(i)..','..ds:H(i)..','..ds:L(i)..','..ds:C(i)..'\n'
            file:write(line)
          end
          file:close()
        end
      end
    end
  end
end

function OnStop()
  is_run = false
end
