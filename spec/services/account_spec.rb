require_relative '../../app/services/account/registration'
# require_relative '../../app/models/user'
# require_relative '../../app/models/application_record'
require 'spec_helper'


describe Account::Registration, User do

  it "принимает валидные параметры, создает нового пользователя и возвращает SUCCESS" do
    expect(Account::Registration.call "ivan", "12891289", "12891289").to eq(Account::Registration::SUCCESS)
  end

  it "принимает nil в качестве параметров и бросает исключение RuntimeError" do
    expect { Account::Registration.call(nil, nil, nil) }.to raise_error(RuntimeError, "all params must be str")
  end

  it "принимает пустые строки в качестве параметров" do
    expect(Account::Registration.call "", "", "").to eq(Account::Registration::LOGIN_SHORT)
  end

  it "принимает пустое поле логин" do
    expect(Account::Registration.call "", "12891289", "12891289").to eq(Account::Registration::LOGIN_SHORT)
  end

  it "принимает пустое поле пароль" do
    expect(Account::Registration.call "ivan", "", "12891289").to eq(Account::Registration::PASSWORD_SHORT)
  end

  it "принимает пароль длиной 7 символов вместо 8" do
    expect(Account::Registration.call "ivan", "1289128", "12891289").to eq(Account::Registration::PASSWORD_SHORT)
  end

  it "пароли не совпадают" do
    expect(Account::Registration.call "ivan", "12891288", "12891289").to eq(Account::Registration::PASSWORD_MISMATCH)
  end

end
