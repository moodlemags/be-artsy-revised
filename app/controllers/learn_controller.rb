class LearnController < ApplicationController
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

        endpoint = "#{data_received}+more:pagemap:metatags-og_type:artist".to_s
        search_params = "#{endpoint}".to_s
        artist_search = api.search(q: endpoint.to_s)
        get_artist_id = artist_search._embedded.results[0]
        get_artist_link = get_artist_id._links.self
        get_artist_name = get_artist_link.name
        get_artist_birthday = get_artist_link.birthday
        get_artist_hometown = get_artist_link.hometown
        get_artist_thumbnail = get_artist_link._links.thumbnail
        get_artist_creation_date = get_artist_link.created_at

        puts "searching for artist: #{search_params} w/ this query link #{artist_search} resulting in this referential link #{get_artist_id}"
        puts "#{get_artist_name}"

        artist_id = get_artist_link.id
        get_gene_id = api.genes(artist_id: artist_id, total_count: 1)
        learn_one_gene = get_gene_id._embedded.genes[0].name
        desc_one_gene = get_gene_id._embedded.genes[0].description
        id_one_gene = get_gene_id._embedded.genes[0].id
        learn_two_gene = get_gene_id._embedded.genes[1].name
        desc_two_gene = get_gene_id._embedded.genes[1].description
        id_two_gene = get_gene_id._embedded.genes[1].id
        learn_three_gene = get_gene_id._embedded.genes[2].name
        desc_three_gene = get_gene_id._embedded.genes[2].description
        id_three_gene = get_gene_id._embedded.genes[2].id

        puts "#{get_gene_id} and #{learn_one_gene}"

        data = {
            artist_creation: get_artist_creation_date,
            artist_page: get_artist_name,
            artist_year: get_artist_birthday,
            artist_hometown: get_artist_hometown,
            artist_image: get_artist_thumbnail.to_s,
            artist_id: artist_id,
            gene_one: {name: learn_one_gene, desc: desc_one_gene, id: id_one_gene},
            gene_two: [learn_two_gene, desc_two_gene, id_two_gene],
            gene_three: [learn_three_gene, desc_three_gene, id_three_gene]
        }
        render json: data

    end

    def render_artsy
      data_received = params[:artist_id]
      puts "artist id #{data_received}"

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

        get_gene_id = api.genes(artist_id: data_received, total_count: 1)
        learn_one_gene = get_gene_id._embedded.genes[0].name
        desc_one_gene = get_gene_id._embedded.genes[0].description
        id_one_gene = get_gene_id._embedded.genes[0].id
        learn_two_gene = get_gene_id._embedded.genes[1].name
        desc_two_gene = get_gene_id._embedded.genes[1].description
        id_two_gene = get_gene_id._embedded.genes[1].id
        learn_three_gene = get_gene_id._embedded.genes[2].name
        desc_three_gene = get_gene_id._embedded.genes[2].description
        id_three_gene = get_gene_id._embedded.genes[2].id
        learn_four_gene = get_gene_id._embedded.genes[3].name
        desc_four_gene = get_gene_id._embedded.genes[3].description
        id_four_gene = get_gene_id._embedded.genes[3].id

        puts "#{get_gene_id} and #{learn_one_gene}"

        data = {
          one_name: learn_one_gene,
          one_desc: desc_one_gene,
          one_id: id_one_gene,
          two_name: learn_two_gene,
          two_desc: desc_two_gene,
          two_id: id_two_gene,
          three_name: learn_three_gene,
          three_desc: desc_three_gene,
          three_id: id_three_gene,
          four_name: learn_four_gene,
          four_desc: desc_four_gene,
          four_id: id_four_gene
        }
        render json: data
    end



end
