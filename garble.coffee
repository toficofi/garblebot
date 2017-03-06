yandex = require "yandex-translate"
config = require "config"

yandexKey = config.get "yandexKey"

if yandexKey is "<INSERT YANDEX API KEY HERE>"
  throw new Error "No Yandex API key specified in config/default.json! You can get a key from https://tech.yandex.com/keys/get/?service=trnsl"

translator = yandex yandexKey

module.exports = (text, from, language) ->
  new Promise (resolve, reject) ->
    data = {to: language}
    if from isnt null then data.from = from

    translator.translate text, data, (err, result) ->
      if err then reject "Error while translating text to #{language}: #{err}"
      if result.code isnt 200 then reject "Expected HTTP code 200 with Yandex, got #{result.code}"
      console.log "#{result.text}: #{from} - #{language}"
      return resolve result.text
