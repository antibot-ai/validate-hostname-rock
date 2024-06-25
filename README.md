# Валидация имени хоста
Проверяет корректность имени хоста. Возвращает `true` в случае успешной валидации.

### Параметры
- **hostname** (строка): Строка для валидации

# Установка
### tarantool
```bash
tt rocks install --only-server=https://rocks.antibot.ru validate-hostname
```
### luarocks
```bash
luarocks install --server=https://rocks.antibot.ru validate-hostname
```

# Использование
```lua
local validateHostname = require('validateHostname')

local valid = validateHostname('antibot.ru')
print(valid) -- true
```

# Генерация ldoc
```bash
ldoc -s '!new' -d ldoc lua
```

# Тестирование
```bash
luatest test/*
```
