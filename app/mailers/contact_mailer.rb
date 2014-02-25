class ContactMailer < ActionMailer::Base
    default to: "food.engineering.portal@gmail.com "# my email address

    def contact_email(name, email, body, subject)
        @name = name
        @email = email
        @body = body

        mail(from: email, subject: "Contact Request: #{subject}")
    end
end