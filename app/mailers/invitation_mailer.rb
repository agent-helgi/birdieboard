class InvitationMailer < ApplicationMailer
  def invite(invitation)
    @invitation  = invitation
    @tournament  = invitation.tournament
    @accept_url  = invitation_url(invitation.token)

    mail(
      to:      invitation.email,
      subject: "You're invited to #{@tournament.name}"
    )
  end
end
