# see https://stackoverflow.com/a/44796030

namespace :puma do
  Rake::Task[:restart].clear_actions

  desc 'Overwritten puma:restart task'
  task :restart do
    puts 'Overwriting puma:restart to ensure that puma is running. '\
         'Effectively, we are just starting Puma.'
    puts 'A solution to this should be found.'
    invoke 'puma:stop'
    invoke 'puma:start'
  end
end
