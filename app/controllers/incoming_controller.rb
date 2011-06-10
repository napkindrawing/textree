require '/usr/local/rvm/gems/ruby-1.9.2-p180/gems/twiliolib-2.0.7/lib/twiliolib.rb'

class IncomingController < ApplicationController
    def index
        account = Twilio::RestAccount.new(Rails.application.config.TWILIO_SID, Rails.application.config.TWILIO_TOKEN)
        members = Member.all
        members.each do |member| 
            # Avert infinite loops!
            return if member.phone_number == Rails.application.config.TWILIO_NUMBER
            d = {
                'From' => Rails.application.config.TWILIO_NUMBER,
                'To' => member.phone_number,
                'Body' => '['+params[:From]+']: '+params[:Body]
            }
            STDERR.puts "text going out: #{d.inspect}"
            resp = account.request(
                "/#{Rails.application.config.TWILIO_API_REV}/Accounts/#{Rails.application.config.TWILIO_SID}/SMS/Messages",
                'POST', 
                d
            )
            STDERR.puts "response: #{resp.inspect}"
        end
    end
end
