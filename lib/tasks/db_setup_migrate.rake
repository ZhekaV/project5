namespace :db_setup_migrate do
  desc 'db_setup_migrate'
  task run: :environment do
    begin
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      system 'rails db:setup'
    else
      if ActiveRecord::Base.connection.tables.blank?
        system 'rails db:schema:load'
        system 'rails db:seed'
      else
        system 'rails db:migrate'
      end
    end
  end
end
