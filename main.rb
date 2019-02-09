require 'telegram/bot'

TOKEN = 'TELEGRAM_BOT_API_TOKEN'


ANSWERS_FILE_PATH = "#{File.dirname(__FILE__)}/data/answers.txt"
GREETING_FILE_PATH = "#{File.dirname(__FILE__)}/data/greeting.txt"

begin
  file_answers = File.open(ANSWERS_FILE_PATH, "r:utf-8")
rescue Errno::ENOENT => e
  puts "Файл с ответами не найден"
  abort e.message
end

answers_lines = file_answers.readlines
file_answers.close

begin
  file_greeting = File.open(GREETING_FILE_PATH, "r:utf-8")
rescue Errno::ENOENT => e
  puts "Файл с ответами не найден"
  abort e.message
end

greeting_lines = file_greeting.readlines
file_greeting.close

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
      when '/start', '/start start'
        bot.api.send_message(
            chat_id: message.chat.id,
            text: "Здравствуй, #{message.from.first_name}.\n" +
                "Можешь задать мне любой интересующий тебя вопрос..."
        )
      else
        sleep 1
        bot.api.send_message(
            chat_id: message.chat.id,
            text: greeting_lines.sample
        )

        sleep 3
        bot.api.send_message(
            chat_id: message.chat.id,
            text: answers_lines.sample
        )
    end
  end
end
