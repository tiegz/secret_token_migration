class ActiveSupport::MessageVerifier
  def verify(signed_message)
    raise InvalidSignature if signed_message.blank?

    data, digest = signed_message.split("--")
    if data.present? && digest.present? && secure_compare(digest, generate_digest(data))
      @serializer.load(::Base64.decode64(data))
    elsif data.present? && digest.present? && @deprecated_secret && secure_compare(digest, generate_deprecated_digest(data))
      ActiveSupport::Notifications.instrument("deprecated_secret.active_support")
      @serializer.load(::Base64.decode64(data))
    else
      raise InvalidSignature
    end
  end

  def generate_deprecated_digest(data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get(@digest).new, @deprecated_secret, data)
  end
end