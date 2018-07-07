require "codebreaker_rack/version"
require 'erb'

module CodebreakerRack
  class Racker
    def self.call(env)
      new(env).response.finish
    end

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    def response
      case @request.path
      when '/'
        Rack::Response.new(render('index.html.erb'))
      when '/start'
        start
      when '/update_answer'
        update_answer
      else Rack::Response.new('Not Found', 404)
      end
    end

    def start
      @request.session.clear
      @request.session[:game] = Codebreaker::Game.new
      @request.session[:hint] = game.secret_code[rand(0..3)]
      redirect_to('/')
    end


    def hint
      @request.session[:hint]
    end

    def game
      @request.session[:game]
    end

    def answer
      @request.session[:answer_user]
    end

    def update_answer
      @request.session[:answer_user] = @request.params['answer_user']
      redirect_to('/')
    end

    private

    def render(template)
      path = File.expand_path("../views/#{template}", __FILE__)
      ERB.new(File.read(path)).result(binding)
    end

    def redirect_to(path)
      Rack::Response.new { |response| response.redirect(path) }
    end
  end
end
