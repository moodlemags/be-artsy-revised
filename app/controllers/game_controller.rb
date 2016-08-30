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
    works_received = params[:saved_works]
    items = works_received.values
    randomized_artist = items[rand(items.length)].values
    puts "found firebase data #{works_received} w/values of #{items} and randomed #{randomized_artist}"

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


      endpoint = "#{randomized_artist}+more:pagemap:metatags-og_type:artist".to_s
      search_params = "#{endpoint}".to_s
      artist_search = api.search(q: endpoint.to_s)
      random_segway = artist_search._embedded.results[0]
      art_link = random_segway._links.self
      puts "endpoint #{endpoint} and params #{search_params} artwork link: #{artist_search}"

      render_painting = art_link._links.thumbnail
      artist_id = art_link.id
      puts "#{artist_id}"
      get_genes = api.genes(artist_id: artist_id)
      gene_one = get_genes._embedded.genes[0].name
      puts "#{get_genes} #{gene_one}"
      data = {
        painting: render_painting.to_s,
        gene_one: gene_one
      }
      #
      render json: data

    end


end
