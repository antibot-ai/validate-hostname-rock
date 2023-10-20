-- test/validation.lua
local luatest = require('luatest')
local g = luatest.group('validation')

-- Функция валидации
local validateHostname = require('lua.validate-hostname.init')

-- Тесты
g.test_valid_hostname = function()
  local validHosts = {
    'москва.рф',
    'example.com',
    '123.example.com',
    'example.com.123',
    '123.com',
    'foo.bar.baz',
    'foo.bar.baz.123-123.zaz',
    'a-b.c.d.123.fun',
    'FOO.BAR',
    'foo.bar.baz',
    'foo.123.en.com',
    '127.0.0.255',
    '123.123.123.abc',
    'IPv6:2001:0db8:85a3:0000:0000:8a2e:0370:7334',
  }

  for i = 1, #validHosts do
    -- Ожидаем, что хост будет валидным
    local valid = validateHostname(validHosts[i])
    luatest.assert_eval_to_true(valid, validHosts[i])
  end
end

g.test_invalid_hostname = function()
  local invalidHosts = {
    '.',
    '-',
    '-example.com',
    '.example.com',
    'example--minus.com',
    'example.com-',
    'example.com.',
    '.123.123.123.123',
    '123.123.123.123.',
    '123.123.123',
    '123.123.123.123-',
    '-123.123.123.123',
    '123..123.123.123',
    '123.123.-123.123',
    '123.--123.123.123',
    '256.123.123.123',
    '123.123.123.-1',
    '12345',
    '123.123',
    'foo.a:b.com',
    'my example.com',
    [[longlabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelnamelonglabelname.com]],
    'IPv4:2001:0db8:85a3:0000:0000',
    'IPv4:123.123.123.123',
    'IPv6:2001:0db8:85a3:0000:0000',
  }

  for i = 1, #invalidHosts do
    -- Ожидаем, что хост будет невалидным
    local valid = validateHostname(invalidHosts[i])
    luatest.assert_eval_to_false(valid, invalidHosts[i])
  end
end

g.test_empty_host = function()
    -- Ожидаем, что пустой хост будет невалидным
    local hostname = ''
    local valid = validateHostname(hostname)
    luatest.assert_eval_to_false(valid)
end
