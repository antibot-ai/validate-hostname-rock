--- Валидация имени хоста
--
-- @module validateHostname
local utf8 = require 'utf8'
local validateHostname

local RU_LETTERS = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'

--- Проверяет на корректность имени хоста
--
-- @param hostname (string) Строка имя хоста
-- @return valid Корректен ли хост
-- @usage
  -- local valid = validateHostname('antibot.ru')
  -- print(valid) -- true
function validateHostname(hostname)
  if type(hostname) ~= 'string' or utf8.len(hostname) >= 255 then
    return false
  end

  hostname = utf8.lower(hostname)

  if string.find(hostname, ':') then
    -- Если это адресс ipv6
    local ipv6 = hostname:match('^ipv6:(.+)$')

    if ipv6 then
      local re = '^([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+):([a-f0-9]+)$'
      if ipv6:find(re) then
        return true
      end
    end

    return false
  elseif not string.find(hostname, '^[a-z'..RU_LETTERS..'0-9%-%.]+$') then
    -- Если хост содержит недопустимые символы
    return false
  end

  -- Если хостнейм содержит два дефиса подряд
  -- и две точки подряд
  if string.find(hostname, '%-%-') or
    string.find(hostname, '%.%.')
  then
    return false
  end

  -- Если хостнейм начинается или заканчивается дефисом
  -- или точкой
  if string.find(hostname, '^[%-%.]') or
    string.find(hostname, '[%-%.]$')
  then
    return false
  end

  -- Если это адрес ipv4
  if string.find(hostname, '^%d+') and
   string.find(hostname, '%d+$')
  then
    local ipv4 = {hostname:match('^(%d+)%.(%d+)%.(%d+)%.(%d+)$')}

    if not ipv4[1] and
      not ipv4[2] and
      not ipv4[3] and
      not ipv4[4]
    then
      return false
    end

    local a = tonumber(ipv4[1]) < 256
    local b = tonumber(ipv4[2]) < 256
    local c = tonumber(ipv4[3]) < 256
    local d = tonumber(ipv4[4]) < 256

    if not (a and b and c and d) then
      return false
    end
  end

  return true
end

return validateHostname
