require 'rails_helper'

describe "User" do

  before :each do
    @user = User.new(name: 'Example user', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar')
  end

context 'users' do

it "musi byc 100 uzytkownikow" do
  expect(User.count).to eq(34)
end

it "powinien byc poprawny" do
  #@user = User.new(name: 'Example user', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar')
  expect(@user.valid?).to be_truthy
end

it { should validate_presence_of(:name) }

end

end
