# garblebot

A Discord bot that completely ruins the meaning of any message you give it. It works by running your sentence through [Yandex.Translate API](https://tech.yandex.com/translate/) with a bunch of languages, then back to your original language.

You can see the bot in action [here](https://discordapp.com/oauth2/authorize?&client_id=286285827145990145&scope=bot). Just shoot it a message.

If you want to host your own version of garblebot, just install Node.JS & NPM, clone/fork this repo, and run `npm install`.
Go into `config/default.json` and replace `languages` with an array of languages you want to run sentences through. The last language in the array will be the final one. You don't need to specify the incoming language, this is detected automagically.
After this, replace `discordToken` with your [Discord bot account secret](https://discordapp.com/developers/applications/me) and `yandexKey` for your [Yandex.Translate API key](https://tech.yandex.com/keys/get/?service=trnsl).

Now just run `npm start` and the bot is ready!
