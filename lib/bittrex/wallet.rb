module Bittrex
  class Wallet
    attr_reader :id, :currency, :balance, :available, :pending,
                :address, :requested, :raw, :ask_value, :est_btc_value, :market_name
    attr_writer :ask_value
    def initialize(attrs = {})
      @id = attrs['Uuid'].to_s
      @address = attrs['CryptoAddress']
      @currency = attrs['Currency']
      @balance = attrs['Balance']
      @available = attrs['Available']
      @pending = attrs['Pending']
      @raw = attrs
      @requested = attrs['Requested']
    end

    def est_btc_value
      @est_btc_value ||= ask_value * balance
    end

    def market_name
      @market_name||= "BTC-#{currency}"
    end

    def self.all
      client.get('account/getbalances').map{|data| new(data) }
    end

    def self.all_none_zero_balances
      all.select { |wallet| wallet.balance > 0 }
    end

    def to_s
      "#{currency} - #{balance} - #{available} - #{pending}"
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
