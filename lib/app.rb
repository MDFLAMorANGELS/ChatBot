# ligne très importante qui appelle les gems.
require 'http'
require 'json'
# n'oublie pas les lignes pour Dotenv ici…
require 'dotenv'
Dotenv.load
# création de la clé d'api et indication de l'url utilisée.
def converse_with_ai(api_key, conversation_history)

api_key = ENV['OPENAI_API_KEY']
url = "https://api.openai.com/v1/engines/text-davinci-003/completions"

# un peu de json pour faire la demande d'autorisation d'utilisation à l'api OpenAI
headers = {
  "Content-Type" => "application/json",
  "Authorization" => "Bearer #{api_key}"
}

# un peu de json pour envoyer des informations directement à l'API
data = {
  "prompt" => conversation_history,
  "max_tokens" => 150,
  "temperature" => 0.6
}

# une partie un peu plus complexe :
# - cela permet d'envoyer les informations en json à ton url
# - puis de récupéré la réponse puis de séléctionner spécifiquement le texte rendu
response = HTTP.post(url, headers: headers, body: data.to_json)
response_body = JSON.parse(response.body.to_s)
response_string = response_body['choices'][0]['text'].strip

# ligne qui permet d'envoyer l'information sur ton terminal

puts "Voici votre réponses :"
puts response_string
return response_string
end

# Début de la conversation
conversation_history = ""
puts "Bonjour, je suis un chatbot. Comment puis-je vous aider ?"
while true
  print "Vous : "
  user_input = gets.chomp

  if user_input.downcase == "stop"
    puts "Au revoir !"
    break
  end

  # Ajout de l'historique de la conversation à la requête
  conversation_history += "\nUtilisateur : #{user_input}\nChatbot : "

  # Envoi de la requête à l'API OpenAI
  response_text = converse_with_ai(ENV["OPENAI_API_KEY"], conversation_history)

  # Affichage de la réponse de l'API
  puts "IA : #{response_text}"

  # Mise à jour de l'historique de la conversation
  conversation_history += response_text + "\n"
end