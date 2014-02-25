class ContactMailer < ActionMailer::Base

    def contact_email(name, email, body, subject)
        @name = name
        @email = email
        @body = body

        mail(subject: "Contact Request - #{subject}")
    end
end