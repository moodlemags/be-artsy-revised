class ArtsyController < ApplicationController
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

  def trigger_artsy_api
    data_received = params[:artist]
    puts "artist params #{data_received}"
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

      # andy_warhol = api.artist(id: 'andy-warhol')
      # render json: "#{andy_warhol.name} was born in #{andy_warhol.birthday} in #{andy_warhol.hometown}"

      user_search = api.search(q: data_received)
      puts "user search #{user_search}"
        if user_search._embedded.results[0].type == "Artist"
          artist_page = user_search._embedded.results[0]._links.self
          puts "if 1 #{artist_page}"
        else
          full_search = user_search._embedded.results
          if artist_page = full_search.find { |found| found['type'] == 'Artist' }
            puts "if 2 #{artist_page._links.self}"
          else
            puts "not working"
          end
        end
        puts "artist_page = #{artist_page}"

      # artist_name = artist_page.name
  #     search_id = user_search.id
  #     artwork_grab = api.artworks(artist_id: search_id)
  #     artworks_title = artwork_grab._embedded.artworks[0].title
  #     artworks_thumbnail = artwork_grab._embedded.artworks[0]._links.thumbnail
  #     painting_genes = artwork_grab._embedded.artworks[0].id
  #     get_genes = api.genes(artwork_id: painting_genes)
  #     genes_name = get_genes._embedded.genes[0].name
  #     data = {
  #       artist_id: user_search.id,
  #       art_title: "#{artwork_grab._embedded.artworks[0].title}",
  #       art_link: "#{artwork_grab._embedded.artworks[0]._links.thumbnail}",
  #       art_gene_name: "#{get_genes._embedded.genes[0].name}",
  #       art_gene_desc: "#{get_genes._embedded.genes[0].description}"
  #     }
  #     render json: data
  end

  def render_artsy
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


  end


end
