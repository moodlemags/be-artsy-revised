class GameController < ApplicationController
  require 'hyperclient'

  def index
    client_id = '45c1a28f62560c431645'
    client_secret = '3fb01aaf998e1ef3fea830d232a36c05'

    api = Hyperclient.new('https://api.artsy.net/api') do |api|
      api.headers['Accept'] = 'application/vnd.artsy-v2+json'
      api.headers['Content-Type'] = 'application/json'
      api.connection(default: false) do |conn|
        conn.use FaradayMiddleware::FollowRedirects
        conn.use Faraday::Response::RaiseError
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.adapter :net_http
      end
    end
    xapp_token = api.tokens.xapp_token._post(client_id: client_id, client_secret: client_secret).token
    puts "token:", xapp_token
    render json: {'Welcome controller': 'welcome to the Artsy API woowooowow'}
  end

  def get_game_data
    # gene_received = params[:id]
    # puts "gene param #{gene_received}"
    xapp_token = 'JvTPWe4WsQO-xqX6Bts49id7qJqr5JLsQGAdvulqJSW9mftRPIKGBuNJnrA0JfQ8-dFZSrZeKVEBsJGHtE6lIT1otchC4Yw6uavJ3kY7STUddLq2MkVxx7KoIKFD3oTy2ltss5IeJT2lhszx6oM0W9YK1nm3aoC8F1Nxo4LPfiYaAhNW_k4W2GrspCa2SZfpZbmxT351ecFpgcfId8mq3iq5sfRkVMy5V8zs4nskkx4='

      api = Hyperclient.new('https://api.artsy.net/api') do |api|
        api.headers['Accept'] = 'application/vnd.artsy-v2+json'
        api.headers['X-Xapp-Token'] = xapp_token
        api.connection(default: false) do |conn|
          conn.use FaradayMiddleware::FollowRedirects
          conn.use Faraday::Response::RaiseError
          conn.request :json
          conn.response :json, content_type: /\bjson$/
          conn.adapter :net_http
        end
      end

      painting_array = ["521d22b9139b213ff0000334", "4d8b937c4eb68a1b2c001722", "53d128877261692cddbd0000", "4d8b92eb4eb68a1b2c000968", "51f01804275b24130c0000ae", "515d6d615eeb1c524c004a75", "5227b2a18b3b81d7ed000017", "521e6c2f275b241e63000673", "516cb54cb83d23b4db000f7e", "515b234a223afae9a5000ff4"]
      main_painting = painting_array.sample
      puts "random painting selected: ,#{main_painting}"
      api_link = api.artwork(id: main_painting)
      genes_link = api.genes(artwork_id: main_painting)
      puts "artwork link: #{api_link}"
      artist_painting = api.artists(artwork_id: main_painting)
      puts "artist link - #{artist_painting}"
      puts "searching#{artist_painting._embedded.artists[0].name} "
      data = {
        painting_id: "#{api_link._links.thumbnail}",
        gene_one: "#{genes_link._embedded.genes[0].name}",
        painting_artist: "#{artist_painting._embedded.artists[0].name}"
      }

      render json: data
      # sample_renaissance = api.gene(id: gene_received)
      # puts "'api endpoint', #{sample_renaissance}"

    end


end
