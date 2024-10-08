# frozen_string_literal: true

# This class is responsible for validating the Telegram Bot's secret key
#
# @example
#   auth_validator = AuthValidator.new
#   auth_validator.valid_auth?(params)
#
class AuthValidator
  # set env to provide the Telegram Bot's secret key
  #
  # @return [Boolean]
  #
  def valid_auth?(params, bot_key)
    raise NoSecretKeyError, 'No secret key found' unless bot_key
    raise AuthTooOldError, 'Data is outdated' if Time.now.to_i - params['auth_date'] > 86_400

    params_hash = params.delete('hash')
    computed_hash = compute_hash_for_auth_data(params)

    hash_equals?(params_hash, computed_hash)
  end

  private

  def compute_hash_for_auth_data(params)
    check_string = prepare_auth_data_check_string(params)
    sha256_digest = OpenSSL::Digest.new('SHA256')
    token_sha = sha256_digest.digest(BOT_KEY)

    OpenSSL::HMAC.hexdigest(sha256_digest, token_sha, check_string)
  end

  def hash_equals?(hash1, hash2)
    hash1 == hash2
  end

  def prepare_auth_data_check_string(params, skip_keys = %w[hash])
    filtered_keys = params.keys.reject { |key| skip_keys.include?(key) }
    strings = filtered_keys.map { |key| "#{key}=#{params[key]}" }

    strings.sort.join("\n")
  end
end
