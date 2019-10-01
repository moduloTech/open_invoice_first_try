namespace :deploy do
  task :yarn_install do
    on release_roles(fetch(:assets_roles)) do
      within release_path do
        execute :yarn, 'install'
      end
    end
  end
end

before 'deploy:compile_assets', 'deploy:yarn_install'
