server ENV['REALME_PRODUCRION_API_SERVER'], port: 22, roles: [:web, :app, :db], primary: true

set :puma_threads, [4, 16]
set :puma_workers, 4