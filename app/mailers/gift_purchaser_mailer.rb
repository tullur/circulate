class GiftPurchaserMailer < ApplicationMailer
  before_action :generate_uuid
  after_action :set_uuid_header
  after_action :store_notification

  def confirmation
    @gift_membership = params[:gift_membership]
    @subject = "How to Redeem Your Membership to the Chicago Tool Library!"
    mail(to: @gift_membership.purchaser_email, subject: @subject)
  end

  private

  def generate_uuid
    @uuid = SecureRandom.uuid
  end

  def set_uuid_header
    headers["X-SMTPAPI"] = {
      unique_args: {
        uuid: @uuid
      }
    }.to_json
  end

  def store_notification
    Notification.create!(uuid: @uuid, action: action_name, address: @gift_membership.purchaser_email, subject: @subject)
  end

end