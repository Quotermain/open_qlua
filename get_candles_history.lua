local utils = require "utils"

path = getScriptPath()..'/'
table_of_assets = {['TQBR']={}, ['SPBXM']={}}
function OnInit()
  for class in pairs(table_of_assets) do
    assets = utils.string_split(getClassSecurities(class))
    for _, asset in ipairs(assets) do
      table.insert(table_of_assets[class], asset)
    end
  end
end

is_run = true
function main()
  while is_run do
    for class in pairs(table_of_assets) do
      for _, asset in ipairs(table_of_assets[class]) do
        ds, Error = CreateDataSource(class, asset, INTERVAL_M1)
        ds:SetEmptyCallback()
        sleep(2)
        if ds:Size() ~= 0 and (Error == nil or Error == '') then
          file = io.open(path..'data/prices/'..asset..'.csv', 'w')
          file:write('datetime, open, high, low, close\n')
          for i = 1, ds:Size() do
            candle_date = ds:T(i).year..'-'..ds:T(i).month..'-'..ds:T(i).day..' '
            candle_time = ds:T(i).hour..':'..ds:T(i).min..':'..ds:T(i).sec..','
            OHLC = ds:O(i)..','..ds:H(i)..','..ds:L(i)..','..ds:C(i)..'\n'
            line =candle_date..candle_time..OHLC
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
