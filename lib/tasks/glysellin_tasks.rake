# encoding: utf-8
# require 'fileutils'

namespace :glysellin do
  task :seed => :environment do
    [
      { name: 'Chèque', identifier: 'check' },
      { name: 'Paypal', identifier: 'paypal-integral' },
      { name: 'Carte bancaire', identifier: 'atos' }
    ].each do |attributes|
      Glysellin::PaymentMethod.create(attributes)
    end

    [
      { name: 'Colissimo', identifier: 'colissimo' },
      { name: 'Lettre Max', identifier: 'lettre-max' },
      { name: 'Frais de ports Offerts', identifier: 'free-shipping' }
    ].each do |attributes|
      Glysellin::ShippingMethod.create! attributes
    end

    Glysellin::DiscountType.create!(
      name: 'Order percentage', identifier: 'order-percentage'
    )
  end

  task :copy_views => :environment do
    folder = %w(app views glysellin)
    source_dir = File.expand_path(File.join('..', '..', '..', *folder), __FILE__)
    dest_dir = Rails.root.join(*folder)
    print "Copying glysellin views folder to #{ dest_dir } ... "

    FileUtils.cp_r source_dir, dest_dir

    puts 'done !'
  end
end
