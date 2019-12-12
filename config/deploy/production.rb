server ENV['REALME_API_PRODUCTION_SERVER'], port: 22, roles: [:web, :app, :db], primary: true

set :puma_threads, [4, 16]
set :ssh_options,     {
    forward_agent: true,
    user: fetch(:user),
    keys: [ENV['REALME_API_PROD_PUBLIC_KEY']],
    auth_methods: %w(publickey)
}
