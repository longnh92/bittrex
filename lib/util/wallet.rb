module Util
  class Wallet
    include Format

    def print_all_wallets_detail
      puts all_wallets_detail
    end

    def all_wallets_detail
      set_ask_values_for_wallets
      result = []
      result << "Est. Sum BTC: #{est_sum_btc_value}"
      result << "Symbol\t\tBalances\t\tAvailable\t\tBid rate\t\tAsk rate\t\tEst. BTC"
      all_none_zero_balances.sort_by(&:est_btc_value).reverse.each do |wallet|
        result << [
          wallet.currency,
          sat_format(wallet.balance),
          sat_format(wallet.available),
          sat_format(bid_value_for(wallet)),
          sat_format(ask_value_for(wallet)),
          sat_format(wallet.est_btc_value)
        ].join("\t\t")
      end
      result.join("\n")
    end

    def all_none_zero_balances
      @all_none_zero_balances ||= Bittrex::Wallet.all_none_zero_balances
    end

    def est_sum_btc_value
      @est_btc_value ||= all_none_zero_balances.sum(&:est_btc_value)
    end

    private

    def all_markets
      @all_markets ||= Bittrex::Summary.all
    end

    def find_market(market_name)
      all_markets.find do |market|
        market.name.downcase == market_name.downcase
      end
    end

    def ask_value_for(wallet)
      market = find_market(wallet.market_name)
      market.nil? ? 0 : market.ask.to_f
    end

    def bid_value_for(wallet)
      market = find_market(wallet.market_name)
      market.nil? ? 0 : market.bid.to_f
    end

    def set_ask_values_for_wallets
      all_none_zero_balances.each do |wallet|
        wallet.ask_value = ask_value_for(wallet)
      end
    end
  end
end
