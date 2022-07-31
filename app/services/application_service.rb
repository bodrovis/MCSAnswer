# frozen_string_literal: true

class ApplicationService
  def self.call(...)
    new(...).call
  end

  def initialize(*_); end

  private

  def broadcast(channel, template, **params)
    Turbo::StreamsChannel.broadcast_render_to(
      channel,
      template:,
      **params
    )
  end

  def broadcast_later(channel, template, **params)
    Turbo::StreamsChannel.broadcast_render_later_to(
      channel,
      template:,
      **params
    )
  end
end
