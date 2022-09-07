# frozen_string_literal: true

# rubocop:disable Style/MixinUsage Layout/LineLength
require 'rails/console/app'
include Rails::ConsoleMethods

def maison
  House.find(1799)
end

def ld
  last.destroy
end

def utilisateur
  User.find(1676)
end

def hp
  HousePerson.find(2373)
end

def rr
  reload!
end

def contrat
  Contract.where(state: :complete).last
end

def yousign_nil
  contract = Contract.find(4476)
  contract.update(
    client_procedure_yousign_token: nil,
    client_upload_yousign_file_token: nil
  )
end

def send_yousign_file
  contract = Contract.find(4476)
  Yousigns::UploadFileJob.perform_now(contract.id, 'client')
end

Pry.config.print = proc { |output, value| output.puts "=> #{value.inspect}" }
Pry.config.color = true
Pry.config.pager = false

alias qq exit

# rubocop:enable Style/MixinUsage Layout/LineLength