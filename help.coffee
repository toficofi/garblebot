Discord = require "discord.js"
numberToWords = require "number-to-words"

module.exports = (message, bot) ->
  #message.channel.sendMessage "I'm a bot that runs what you say through a bunch of languages, and then back to English. Send me a DM, or @ me. You'll get some hilarious results. Powered by Yandex.Translate: http://translate.yandex.com/. Source: https://github.com/Jishaxe/garblebot"
  #message.channel.sendMessage "Want me in your server, as well as **#{numberToWords.toWords(bot.guilds.size)}** others? https://discordapp.com/oauth2/authorize?&client_id=#{bot.user.id}&scope=bot"

  embed = new Discord.RichEmbed()
  embed.setAuthor "Created by @jshxe#1659, idea by @Lolly#5299", "https://cdn.discordapp.com/avatars/227874586312704000/316cee9c84be6297bbb3d423ef866dac.jpg"
  embed.setColor "#4f92ff"
  embed.setDescription "I'm a bot that runs what you say through a bunch of languages, and then back to English.\nSend me a DM, or `@garblebot your text` me. You'll get some hilarious results."
  embed.addField "➕ Add me", "https://discordapp.com/oauth2/authorize?&client_id=#{bot.user.id}&scope=bot", true
  embed.addField "📓 GitHub", "https://github.com/Jishaxe/garblebot", true
  embed.setFooter "🖥️ Active on #{numberToWords.toWords(bot.guilds.size)} servers - powered by Yandex.Translate: http://translate.yandex.com/"

  message.channel.sendEmbed(embed)
