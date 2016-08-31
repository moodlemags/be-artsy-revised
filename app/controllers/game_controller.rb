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


      genes_array = {"4eb45f970253b800010233f7" => "Art That Plays With Scale", "4dc7ed68b1783b0001000233" => "Humor", "5637df04726169640f00013e" => "Use of Precious Materials", "5182c6a187d161c1a300005b" => "Germany, Austria and Switzerland", "4e6a4315ec5e520001072274" => "Myth/Religion", "56d613398b0c142caf000194" => "Minimalism and Contemporary Minimalist" }

      game_gene = keys(genes_array)
      puts "#{game_gene}"
      # randomized_gene = game_gene[rand(game_gene.length)].keys
      # puts "#{game_gene} and randomly selected #{randomized_gene}"

      render_painting = art_link._links.thumbnail
      artist_id = art_link.id
      puts "#{artist_id}"
      get_genes = api.genes(artist_id: artist_id)
      gene_one = get_genes._embedded.genes[0].name
      gene_id = get_genes._embedded.genes[0].id
      puts "#{get_genes} #{gene_one}"
      data = {
        painting: render_painting.to_s,
        gene_one: gene_one,
        gene_id: gene_id
      }
      #
      render json: data

    end

    def find_gene
      gene_received = params[:id]
      puts "#{gene_received}"
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

        get_gene = api.gene(id: gene_received)
        gene_name = get_gene.name
        gene_desc = get_gene.description
        gene_img = get_gene._links.thumbnail
        gene_others = get_gene._links.artists
        gene_other_one = gene_others._embedded.artists[0].name
        puts "#{get_gene} named #{gene_name}"

        data = {
          name: gene_name,
          description: gene_desc,
          sample_img: gene_img.to_s,
          another: gene_other_one
        }
        render json: data

    end



end
