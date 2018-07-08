require './lib/codebreaker_rack'

use Rack::Reloader
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: '123'
use Rack::Static, urls: ['/css', '/img', '/js'], root: 'public'

run CodebreakerRack::Racker