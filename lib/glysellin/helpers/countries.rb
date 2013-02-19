# encoding: utf-8
module Glysellin
  module Helpers
    module Countries
      extend ActiveSupport::Concern

      COUNTRIES_LIST = {
        "AF"=>"Afghanistan", 
        "AL"=>"Albania", 
        "DZ"=>"Algeria", 
        "AS"=>"American Samoa", 
        "AD"=>"Andorra", 
        "AO"=>"Angola", 
        "AI"=>"Anguilla", 
        "AQ"=>"Antarctica", 
        "AG"=>"Antigua & Barbuda", 
        "AR"=>"Argentina", 
        "AM"=>"Armenia", 
        "AW"=>"Aruba", 
        "AU"=>"Australia", 
        "AT"=>"Austria", 
        "AZ"=>"Azerbaijan", 
        "BS"=>"Bahama", 
        "BH"=>"Bahrain", 
        "BD"=>"Bangladesh", 
        "BB"=>"Barbados", 
        "BY"=>"Belarus", 
        "BE"=>"Belgium", 
        "BZ"=>"Belize", 
        "BJ"=>"Benin", 
        "BM"=>"Bermuda", 
        "BT"=>"Bhutan", 
        "BO"=>"Bolivia", 
        "BA"=>"Bosnia and Herzegovina", 
        "BW"=>"Botswana", 
        "BV"=>"Bouvet Island", 
        "BR"=>"Brazil", 
        "IO"=>"British Indian Ocean Territory", 
        "VG"=>"British Virgin Islands", 
        "BN"=>"Brunei Darussalam", 
        "BG"=>"Bulgaria", 
        "BF"=>"Burkina Faso", 
        "BI"=>"Burundi", 
        "KH"=>"Cambodia", 
        "CM"=>"Cameroon", 
        "CA"=>"Canada", 
        "CV"=>"Cape Verde", 
        "KY"=>"Cayman Islands", 
        "CF"=>"Central African Republic", 
        "TD"=>"Chad", 
        "CL"=>"Chile", 
        "CN"=>"China", 
        "CX"=>"Christmas Island", 
        "CC"=>"Cocos (Keeling) Islands", 
        "CO"=>"Colombia", 
        "KM"=>"Comoros", 
        "CG"=>"Congo", 
        "CK"=>"Cook Iislands", 
        "CR"=>"Costa Rica", 
        "HR"=>"Croatia", 
        "CU"=>"Cuba", 
        "CY"=>"Cyprus", 
        "CZ"=>"Czech Republic", 
        "CI"=>"Côte D'ivoire (Ivory Coast)", 
        "DK"=>"Denmark", 
        "DJ"=>"Djibouti", 
        "DM"=>"Dominica", 
        "DO"=>"Dominican Republic", 
        "TP"=>"East Timor", 
        "EC"=>"Ecuador", 
        "EG"=>"Egypt", 
        "SV"=>"El Salvador", 
        "GQ"=>"Equatorial Guinea", 
        "ER"=>"Eritrea", 
        "EE"=>"Estonia", 
        "ET"=>"Ethiopia", 
        "FK"=>"Falkland Islands (Malvinas)", 
        "FO"=>"Faroe Islands", 
        "FJ"=>"Fiji", 
        "FI"=>"Finland", 
        "FR"=>"France", 
        "FX"=>"France, Métropolitain", 
        "GF"=>"French Guiana", 
        "PF"=>"French Polynesia", 
        "TF"=>"French Southern Territories", 
        "GA"=>"Gabon", 
        "GM"=>"Gambia", 
        "GE"=>"Georgia", 
        "DE"=>"Germany", 
        "GH"=>"Ghana", 
        "GI"=>"Gibraltar", 
        "GR"=>"Greece", 
        "GL"=>"Greenland", 
        "GD"=>"Grenada", 
        "GP"=>"Guadeloupe", 
        "GU"=>"Guam", 
        "GT"=>"Guatemala", 
        "GN"=>"Guinea", 
        "GW"=>"Guinea-Bissau", 
        "GY"=>"Guyana", 
        "HT"=>"Haiti", 
        "HM"=>"Heard & McDonald Islands", 
        "HN"=>"Honduras", 
        "HK"=>"Hong Kong", 
        "HU"=>"Hungary", 
        "IS"=>"Iceland", 
        "IN"=>"India", 
        "ID"=>"Indonesia", 
        "IQ"=>"Iraq", 
        "IE"=>"Ireland", 
        "IR"=>"Islamic Republic of Iran", 
        "IL"=>"Israel", 
        "IT"=>"Italy", 
        "JM"=>"Jamaica", 
        "JP"=>"Japan", 
        "JO"=>"Jordan", 
        "KZ"=>"Kazakhstan", 
        "KE"=>"Kenya", 
        "KI"=>"Kiribati", 
        "KP"=>"Korea, Democratic People's Republic of", 
        "KR"=>"Korea, Republic of", 
        "KW"=>"Kuwait", 
        "KG"=>"Kyrgyzstan", 
        "LA"=>"Lao People's Democratic Republic", 
        "LV"=>"Latvia", 
        "LB"=>"Lebanon", 
        "LS"=>"Lesotho", 
        "LR"=>"Liberia", 
        "LY"=>"Libyan Arab Jamahiriya", 
        "LI"=>"Liechtenstein", 
        "LT"=>"Lithuania", 
        "LU"=>"Luxembourg", 
        "MO"=>"Macau", 
        "MG"=>"Madagascar", 
        "MW"=>"Malawi", 
        "MY"=>"Malaysia", 
        "MV"=>"Maldives", 
        "ML"=>"Mali", 
        "MT"=>"Malta", 
        "MH"=>"Marshall Islands", 
        "MQ"=>"Martinique", 
        "MR"=>"Mauritania", 
        "MU"=>"Mauritius", 
        "YT"=>"Mayotte", 
        "MX"=>"Mexico", 
        "FM"=>"Micronesia", 
        "MD"=>"Moldova, Republic of",
        "MC"=>"Monaco", 
        "MN"=>"Mongolia", 
        "MS"=>"Monserrat", 
        "MA"=>"Morocco", 
        "MZ"=>"Mozambique", 
        "MM"=>"Myanmar", 
        "NA"=>"Namibia", 
        "NR"=>"Nauru", 
        "NP"=>"Nepal", 
        "NL"=>"Netherlands", 
        "AN"=>"Netherlands Antilles", 
        "NC"=>"New Caledonia", 
        "NZ"=>"New Zealand", 
        "NI"=>"Nicaragua", 
        "NE"=>"Niger", 
        "NG"=>"Nigeria", 
        "NU"=>"Niue", 
        "NF"=>"Norfolk Island", 
        "MP"=>"Northern Mariana Islands", 
        "NO"=>"Norway", 
        "OM"=>"Oman", 
        "PK"=>"Pakistan", 
        "PW"=>"Palau", 
        "PA"=>"Panama", 
        "PG"=>"Papua New Guinea", 
        "PY"=>"Paraguay", 
        "PE"=>"Peru", 
        "PH"=>"Philippines", 
        "PN"=>"Pitcairn", 
        "PL"=>"Poland", 
        "PT"=>"Portugal", 
        "PR"=>"Puerto Rico", 
        "QA"=>"Qatar", 
        "RO"=>"Romania", 
        "RU"=>"Russian Federation", 
        "RW"=>"Rwanda", 
        "RE"=>"Réunion", 
        "LC"=>"Saint Lucia", 
        "WS"=>"Samoa", 
        "SM"=>"San Marino", 
        "ST"=>"Sao Tome & Principe", 
        "SA"=>"Saudi Arabia", 
        "SN"=>"Senegal", 
        "SC"=>"Seychelles", 
        "SL"=>"Sierra Leone", 
        "SG"=>"Singapore", 
        "SK"=>"Slovakia", 
        "SI"=>"Slovenia", 
        "SB"=>"Solomon Islands", 
        "SO"=>"Somalia", 
        "ZA"=>"South Africa", 
        "GS"=>"South Georgia and the South Sandwich Islands", 
        "ES"=>"Spain", 
        "LK"=>"Sri Lanka", 
        "SH"=>"St. Helena", 
        "KN"=>"St. Kitts and Nevis", 
        "PM"=>"St. Pierre & Miquelon", 
        "VC"=>"St. Vincent & the Grenadines", 
        "SD"=>"Sudan", 
        "SR"=>"Suriname", 
        "SJ"=>"Svalbard & Jan Mayen Islands", 
        "SZ"=>"Swaziland", 
        "SE"=>"Sweden", 
        "CH"=>"Switzerland", 
        "SY"=>"Syrian Arab Republic", 
        "TW"=>"Taiwan, Province of China", 
        "TJ"=>"Tajikistan", 
        "TZ"=>"Tanzania, United Republic of", 
        "TH"=>"Thailand", 
        "TG"=>"Togo", 
        "TK"=>"Tokelau", 
        "TO"=>"Tonga", 
        "TT"=>"Trinidad & Tobago", 
        "TN"=>"Tunisia", 
        "TR"=>"Turkey", 
        "TM"=>"Turkmenistan", 
        "TC"=>"Turks & Caicos Islands", 
        "TV"=>"Tuvalu", 
        "UG"=>"Uganda", 
        "UA"=>"Ukraine", 
        "AE"=>"United Arab Emirates", 
        "GB"=>"United Kingdom (Great Britain)", 
        "UM"=>"United States Minor Outlying Islands", 
        "VI"=>"United States Virgin Islands", 
        "US"=>"United States of America", 
        "UY"=>"Uruguay", 
        "UZ"=>"Uzbekistan", 
        "VU"=>"Vanuatu", 
        "VA"=>"Vatican City State (Holy See)", 
        "VE"=>"Venezuela", 
        "VN"=>"Viet Nam", 
        "WF"=>"Wallis & Futuna Islands", 
        "EH"=>"Western Sahara", 
        "YE"=>"Yemen", 
        "YU"=>"Yugoslavia", 
        "ZR"=>"Zaire", 
        "ZM"=>"Zambia", 
        "ZW"=>"Zimbabwe"
      }

      included do
        helper_method :countries_option_list, :country_from_code
      end

      def countries_option_list
        COUNTRIES_LIST.map { |code, country| [country, code] }
      end

      def country_from_code code
        COUNTRIES_LIST[code.to_s.capitalize]
      end
    end
  end
end