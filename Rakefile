require 'bundler/gem_tasks'
require 'figaro'
require "awesome_print"
require './lib/bittrex.rb'

Figaro.application.path = File.expand_path('../config/application.yml', __FILE__)
Figaro.load

namespace :bt do
  task :console do
    exec "irb -r bittrex -I ./lib"
  end

  task :balances do
    Util::Wallet.new.print_all_wallets_detail
  end

  task :balances_interval, :interval do |t, arg|
    t = Thread.new do
      while(true) do
        detail = Util::Wallet.new.all_wallets_detail
        system "clear"
        puts detail
        sleep(arg[:interval].to_i || 5)
      end
    end
    STDIN.gets
    t.kill
  end

  task :market, :market_name do |t, arg|
    quote = Bittrex::Quote.current(arg[:market_name])
    puts "Market: #{arg[:market_name]}"
    puts "Ask: #{'%.8f' % quote.ask}"
    puts "Bid: #{'%.8f' % quote.bid}"
    puts "Last: #{'%.8f' % quote.last}"
  end

  task :open_orders do
    ap Bittrex::Order.open.map(&:raw)
  end

  task :buy, [:market, :qty, :rate] do |t, arg|
    ap Bittrex::Order.buy(arg[:market], arg[:qty], arg[:rate])
  end

  task :sell, [:market, :qty, :rate] do |t, arg|
    ap Bittrex::Order.sell(arg[:market], arg[:qty], arg[:rate])
  end

  task :cancel_order, :id do |t, arg|
    ap Bittrex::Order.cancel(arg[:id])
  end

end
