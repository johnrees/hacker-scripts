#!/usr/bin/env ruby

require 'dotenv'
require 'gmail'

Dotenv.load

gmail = Gmail.connect(ENV['GMAIL_USERNAME'], ENV['GMAIL_PASSWORD'])

KEYWORDS_REGEX = /sorry|help|wrong/i

gmail.inbox.find(:unread, from: 'kumar.a@example.com').each do |email|
  if email.body.downcase[KEYWORDS_REGEX]
    # Restore DB and send a reply
    email.label('Database fixes')
    reply = reply_to(email.subject)
    gmail.deliver(reply)
  end
end

def reply_to(subject)
  gmail.compose do
    to "email@example.com"
    subject "RE: #{subject}"
    body "No problem. I've fixed it. \n\n Please be careful next time."
  end
end
