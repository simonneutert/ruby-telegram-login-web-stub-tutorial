# frozen_string_literal: true

class AuthValidatorTest < Test::Unit::TestCase
  def test_hash_authentication_with_passed_params
    Timecop.freeze(Date.new(2011, 11, 11)) do
      AuthValidator.new
      params = { 'id' => 1337,
                 'first_name' => 'Simon',
                 'last_name' => 'Neutert',
                 'username' => 'simonneutert',
                 'photo_url' => 'https://t.me/i/userpic/320/xxx.jpg',
                 'auth_date' => 1_320_966_000,
                 'hash' => '9c82b507c611f9dd98e5a70cf0ba458d7a3dab038c9bb94219c6ecc9caa80eae' }
      cloned_params = Marshal.load(Marshal.dump(params))
      auth_validator = AuthValidator.new
      auth_status = auth_validator.valid_auth?(cloned_params, '1337LeetUnitRheinhessen')
      assert_equal(true, auth_status)
    end
  end

  def test_hash_authentication_with_auth_too_old
    Timecop.freeze(Date.new(2011, 11, 11)) do
      AuthValidator.new
      params = { 'id' => 1337,
                 'first_name' => 'Simon',
                 'last_name' => 'Neutert',
                 'username' => 'simonneutert',
                 'photo_url' => 'https://t.me/i/userpic/320/xxx.jpg',
                 'auth_date' => 1337,
                 'hash' => '9c82b507c611f9dd98e5a70cf0ba458d7a3dab038c9bb94219c6ecc9caa80eae' }
      cloned_params = Marshal.load(Marshal.dump(params))
      auth_validator = AuthValidator.new

      assert_raise AuthValidator::AuthTooOldError do
        auth_validator.valid_auth?(cloned_params, '1337LeetUnitRheinhessen')
      end
    end
  end
end
