yandex = require "yandex-translate"
config = require "config"

yandexKey = config.get "yandexKey"

if yandexKey is "<INSERT YANDEX API KEY HERE>"
  throw new Error "No Yandex API key specified in config/default.json! You can get a key from https://tech.yandex.com/keys/get/?service=trnsl"

translator = yandex yandexKey

module.exports = (text, language) ->
  new Promise (resolve, reject) ->
    translator.translate text, {to: language}, (err, result) ->
      if err then reject "Error while translating text to #{language}: #{err}"
      if result.code isnt 200 then reject "Expected HTTP code 200 with Yandex, got #{result.code}"
      return resolve result.text
