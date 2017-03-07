Discord = require 'discord.js'
garble = require "./garble"
help = require "./help"
config = require "config"
waterfall = require "promise.waterfall"
languages = config.get "languages"
bot = new Discord.Client()
token = config.get "discordToken"

pingTime = null

if token is "<INSERT DISCORD TOKEN HERE>" then throw new Error "No Discord token specified in config/default.json. Get a bot user token from https://discordapp.com/developers/applications/me"

bot.on 'ready', ->
  # Set instructions to get help
  bot.user.setGame "@#{bot.user.username} help"
  console.log 'connected! garblebot is now active. message help for help'

# Just print any errors to the consule
bot.on 'error', (error) ->
  console.error error

# Response to ping
# Will wait for Discord to tell us about our message, then edit with the time elapsed
bot.on 'ping', (message) ->
  pingTime = Date.now()
  message.reply "**Pong!** ..."

# Response to @ help
bot.on 'help', help

bot.on 'message', (message) ->
  # If this is the bot's pong messsage, edit with the elapsed time
  if message.author is bot.user and pingTime isnt null
    message.edit message.content.replace("...", "#{Date.now() - pingTime}ms")
    pingTime = null
    return

  # Responds when the bot is @ or with a direct message
  if (message.cleanContent.startsWith("@#{bot.user.username}")) or (message.channel.type is "dm")
    # Don't respond to bots (including myself)
    if message.author.bot then return
    # Delete any mention of the bot in the text to stop recursiveness
    text = message.cleanContent.replace "@#{bot.user.username}", ""
    text = text.trim()

    # Truncate the text to 500 letters
    text = text.substring(0, 500)

    # Response to help
    if text is "help"
      bot.emit "help", message, bot
      return

    if text is "ping"
      bot.emit "ping", message
      return

    # Start typing while we translate
    message.channel.startTyping()
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
    .then () ->
      message.channel.stopTyping()

console.log "Connecting to Discord..."
bot.login token
