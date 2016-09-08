class GameController < ApplicationController
  require 'hyperclient'

  def welcome_placeholder
    render json: {"root route placeholder": "hello"}
  end



  def index
    render json: {"Game controller": "index route"}
  end



  def make_artsy_api_call
    client_id = '45c1a28f62560c431645'
    client_secret = '3fb01aaf998e1ef3fea830d232a36c05'

    # Get token
    xapp_token = HTTParty.post("https://api.artsy.net/api/tokens/xapp_token?client_id=#{client_id}&client_secret=#{client_secret}")
    xapp_token = xapp_token["token"]
    puts "token!:", xapp_token

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

    andy_warhol = api.artist(id: 'andy-warhol')
    puts "#{andy_warhol.name} was born in #{andy_warhol.birthday} in #{andy_warhol.hometown}"

    render json: andy_warhol
  end





  def get_game_data
    works_received = params[:saved_works]
    items = works_received.values
    randomized_artist = items[rand(items.length)].values

    puts "found firebase data #{works_received} w/values of #{items} and randomed #{randomized_artist}"
        client_id = '45c1a28f62560c431645'
        client_secret = '3fb01aaf998e1ef3fea830d232a36c05'

        xapp_token = HTTParty.post("https://api.artsy.net/api/tokens/xapp_token?client_id=#{client_id}&client_secret=#{client_secret}")
        xapp_token = xapp_token["token"]
        puts "token!:", xapp_token

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
      puts "endpoint #{endpoint} and params #{search_params} and "



      render_painting = art_link._links.thumbnail
      artist_id = art_link.id
      puts "#{artist_id}"
      get_genes = api.genes(artist_id: artist_id)
      gene_one = get_genes._embedded.genes[0].name
      gene_id = get_genes._embedded.genes[0].id
      gene_hash = {gene_id => gene_one}
      puts "#{get_genes} #{gene_one}"

      genes_array = {"4eb45f970253b800010233f7" => "Art That Plays With Scale", "4dc7ed68b1783b0001000233" => "Humor", "5637df04726169640f00013e" => "Use of Precious Materials", "5182c6a187d161c1a300005b" => "Germany, Austria and Switzerland", "4e6a4315ec5e520001072274" => "Myth/Religion", "56d613398b0c142caf000194" => "Minimalism and Contemporary Minimalist" }.merge(gene_hash)

      game_gene = genes_array.keys
      randomize_genes = game_gene.shuffle
      render_array = randomize_genes.slice!(0..5)
        if render_array.include? "#{gene_id}"
          puts "true"
        else
          render_array.pop
          render_array.push(gene_id)
          puts "false #{render_array}"
        end
      puts "#{genes_array}"


      data = {
        painting: render_painting.to_s,
        gene_one: gene_one,
        gene_id: gene_id,
        first_gene_id: render_array[0],
        first_gene_name: genes_array[render_array[0]],
        second_gene_id: render_array[1],
        second_gene_name: genes_array[render_array[1]],
        third_gene_id: render_array[2],
        third_gene_name: genes_array[render_array[2]],
        fourth_gene_id: render_array[3],
        fourth_gene_name: genes_array[render_array[3]],
        fifth_gene_id: render_array[4],
        fifth_gene_name: genes_array[render_array[4]],
        sixth_gene_id: render_array[5],
        sixth_gene_name: genes_array[render_array[5]],
        # genes_hash: render_hash
      }

      render json: data

    end

    def find_gene
      gene_received = params[:id]
      puts "#{gene_received}"
      client_id = '45c1a28f62560c431645'
      client_secret = '3fb01aaf998e1ef3fea830d232a36c05'

      xapp_token = HTTParty.post("https://api.artsy.net/api/tokens/xapp_token?client_id=#{client_id}&client_secret=#{client_secret}")
      xapp_token = xapp_token["token"]
      puts "token!:", xapp_token

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

    def confirm_gene
      gene_received = params[:id]
      puts "#{gene_received}"
      client_id = '45c1a28f62560c431645'
      client_secret = '3fb01aaf998e1ef3fea830d232a36c05'

      xapp_token = HTTParty.post("https://api.artsy.net/api/tokens/xapp_token?client_id=#{client_id}&client_secret=#{client_secret}")
      xapp_token = xapp_token["token"]
      puts "token!:", xapp_token

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
