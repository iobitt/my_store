require 'rails_helper'


describe Account::RegistrationService do

  it "создает пользователя с типом Manager" do
    ok, result, errors = Account::RegistrationService.new("Manager", "ivan", "12891289", "12891289").call
    expect(ok).to eq(true)
    expect(errors).to eq(nil)
    expect(result.name).to eq("ivan")
    expect(result.password).to eq("12891289")
    expect(result.type).to eq("Manager")
    expect(result.token).to eq(nil)
  end

  it "создает пользователя с не уникальным именем" do
    Account::RegistrationService.new("Manager", "ivan", "12891289", "12891289").call
    ok, result, errors = Account::RegistrationService.new("Manager", "ivan", "12891289", "12891289").call
    expect(ok).to eq(false)
  end

  it "создает пользователя с типом Api" do
    ok, result, errors = Account::RegistrationService.new("Api").call
    expect(ok).to eq(true)
    expect(errors).to eq(nil)
    expect(result.name).to eq(nil)
    expect(result.password).to eq(nil)
    expect(result.type).to eq("Api")
    expect(result.token.class).to eq(String)
    expect(result.token.length).to be >= 32
  end

  it "проверяет, что нельзя передать nil в качестве type" do
    ok, result, errors = Account::RegistrationService.new(nil).call
    expect(ok).to eq(false)
    expect(errors).to eq(["не допустимый тип пользователя"])
  end

  it "проверяет, что нельзя передать любую строку в качестве параметра type" do
    ok, result, errors = Account::RegistrationService.new("admin").call
    expect(ok).to eq(false)
    expect(errors).to eq(["не допустимый тип пользователя"])
  end

  it "проверяет, что нельзя передать пустые поля name, password и password2 при типе Manager" do
    ok, result, errors = Account::RegistrationService.new("Manager", nil, nil, nil).call
    expect(ok).to eq(false)
    expect(errors).to eq(["логин, пароль и потверждение пароля являются обязательными параметрами"])
  end

  it "принимает пустые строки в качестве параметров" do
    ok, result, errors = Account::RegistrationService.new("Manager", "", "", "").call
    expect(ok).to eq(false)
  end

  it "принимает пустое поле логин" do
    ok, result, errors = Account::RegistrationService.new("Manager", "", "12891289", "12891289").call
    expect(ok).to eq(false)
  end

  it "принимает пустое поле пароль" do
    ok, result, errors = Account::RegistrationService.new("Manager", "ivan", "", "12891289").call
    expect(ok).to eq(false)
  end

  it "принимает пароль длиной 7 символов вместо 8" do
    ok, result, errors = Account::RegistrationService.new("Manager", "ivan", "1289128", "12891289").call
    expect(ok).to eq(false)
  end

  it "пароли не совпадают" do
    ok, result, errors = Account::RegistrationService.new("Manager", "ivan", "12891288", "12891289").call
    expect(ok).to eq(false)
  end

end


describe Account::LoginService do

  it "проверяет ввод неверного логина" do
    ok, result, errors = Account::RegistrationService.new("Manager", "ivan", "12891289", "12891289").call
    expect(ok).to eq(true)
    ok, result, errors = Account::LoginService.new("ivam", "12891289").call
    expect(ok).to eq(false)
    expect(errors).to eq(["не верный логин или пароль"])
  end

  it "проверяет ввод неверного пароля" do
    ok, result, errors = Account::RegistrationService.new("Manager", "ivan", "12891289", "12891289").call
    expect(ok).to eq(true)
    ok, result, errors = Account::LoginService.new("ivan", "12891288").call
    expect(ok).to eq(false)
    expect(errors).to eq(["не верный логин или пароль"])
  end

  it "проверяет правильный ввод данных" do
    ok, result, errors = Account::RegistrationService.new("Manager", "ivan", "12891289", "12891289").call
    expect(ok).to eq(true)
    ok, result, errors = Account::LoginService.new("ivan", "12891289").call
    expect(ok).to eq(true)
    expect(errors).to eq(nil)
    expect(result.name).to eq("ivan")
    expect(result.type).to eq("Manager")
    expect(result.token).to eq(nil)
  end

  it "проверяет ввод значений nil" do
    expect { Account::LoginService.new(nil, nil).call }.to raise_error(RuntimeError, "all params must be str")
  end
end
