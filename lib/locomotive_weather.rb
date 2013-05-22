require "locomotive_weather/version"
require 'wunderground'

module Locomotive
  module Liquid
    module Tags
      class Weather < ::Liquid::Tag

        Syntax = /(#{::Liquid::Expression}+)?/

        def initialize(tag_name, markup, tokens, context)
          if markup =~ Syntax
            @city = $1.gsub('\'', '')
            @options = { }
            markup.scan(::Liquid::TagAttributes) { |key, value| @options[key.to_sym] = value.gsub(/"|'/, '') }
          else
            raise ::Liquid::SyntaxError.new("Syntax Error in 'weather' - Valid syntax: weather <city>, api_key: <wunderground API Key>")
          end
          super
        end

        def render(context)
          begin
            Rails.cache.fetch("weather_#{@city}",:expires=>3600) do
              get_weather(@city)
            end
          rescue NameError
            # ==========================================================================
            # = in case we are using locomotive editor, the RAILS cache doesn’t exist! =
            # ==========================================================================
            get_weather(@city)
          end

        end

        def get_weather(city)
          begin
            w_api = Wunderground.new(@options[:api_key])
            weatherresp=w_api.forecast_and_conditions_for(city,:lang=>'DL')
            days_forecast=""
            weatherresp['forecast']['simpleforecast']['forecastday'][0..3].each do |forecast|
              days_forecast+="<div class='weather_block'>"
              days_forecast+="#{forecast['date']['weekday_short']} #{forecast["conditions"]}<br/>"
              days_forecast+="<img src='#{forecast["icon_url"]}'><br/>"
              days_forecast+="<small>Min: #{forecast["low"]["celsius"]}&deg;C</small> <br/>"
              days_forecast+="<small>Max: #{forecast["high"]["celsius"]}&deg;C</small>"
              days_forecast+="</div>"
            end
            %{
              <div class="actual_weather">#{weatherresp['current_observation']['weather']} #{weatherresp['current_observation']['temp_c']}&deg;C</div>
              <div class="forecast">#{days_forecast}</div>
            }
          rescue Exception => e
            "Error getting weather"
            raise
          end
        end
      end
      ::Liquid::Template.register_tag('weather', Weather)
    end
  end
end
