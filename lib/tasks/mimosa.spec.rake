require 'spec/rake/spectask'

namespace :spec do

  desc 'Generate Specdoc files for all specs'
  Spec::Rake::SpecTask.new('docs') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--format', 'specdoc:doc/specdoc']
  end

  desc 'Generate HTML report for all specs '
  Spec::Rake::SpecTask.new('html') do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--format', 'html:public/report.html']
    t.fail_on_error = false
  end

end
