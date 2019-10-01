namespace :deploy do
  namespace :puma do
    task :start do
      on release_roles(:web) do
        within current_path do
          execute :bundle, 'exec puma -C spec/dummy/config/puma.rb --daemon'
        end
      end
    end
  end
end

after 'deploy:finished', 'deploy:puma:start'
