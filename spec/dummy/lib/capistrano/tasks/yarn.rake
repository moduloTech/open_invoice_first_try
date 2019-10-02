namespace :deploy do
  namespace :yarn do
    task :install do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          execute :yarn, 'install'
        end
      end
    end
  end

  before :compile_assets, 'yarn:install'
end
