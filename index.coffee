Discord = require 'discord.js'
garble = require "./garble"
config = require "config"
waterfall = require "promise.waterfall"

languages = config.get "languages"

bot = new Discord.Client()
token = config.get "discordToken"

if token is "<INSERT DISCORD TOKEN HERE>" then throw new Error "No Discord token specified in config/default.json. Get a bot user token from https://discordapp.com/developers/applications/me"

bot.on 'ready', ->
  # Set instructions to get help
  bot.user.setGame "@#{bot.user.username} help"
  console.log 'connected! garblebot is now active. message help for help'

# Just print any errors to the consule
bot.on 'error', (error) ->
  console.error error

# Response to @ help
bot.on 'helpRequest', (message) ->
  message.reply "I'm a bot that runs what you say through a bunch of languages, and then back to English. Send me a DM, or @ me. You'll get some hilarious results. Powered by Yandex.Translate: http://translate.yandex.com/. Source: https://github.com/Jishaxe/garblebot"
  message.reply "Want me in your server? https://discordapp.com/oauth2/authorize?&client_id=#{bot.user.id}&scope=bot"

bot.on 'message', (message) ->
  # Responds when the bot is @ or with a direct message
  if (message.isMentioned bot.user) or (message.channel.type is "dm")
    # Don't respond to bots (including myself)
    if message.author.bot then return
    # Delete any mention of the bot in the text to stop recursiveness
    text = message.cleanContent.replace "@#{bot.user.username}", ""
    text = text.trim()

    # Truncate the text to 500 letters
    text = text.substring(0, 500)

    # Response to help
    if text is "help"
      bot.emit "helpRequest", message
      return

    # Map every language to a promise that garbles in that language
    translationPromises = languages.map (language, index) ->
      if index is 0
        return () ->
          garble text, null, language
      else
        return (toGarble) ->
          garble toGarble[0], languages[index - 1], language

    # Execute every garbling operation, passing the result of the last to the next one until we get to the result
    waterfall translationPromises
    .then (garbled) ->
      message.reply garbled
    .catch (error) ->
      # If we got an error at any point, print it out and let the user know
      console.error "ERROR: #{error}"
      message.reply "Sorry, I had an error while garbling that!"

console.log "Connecting to Discord..."
bot.login token
