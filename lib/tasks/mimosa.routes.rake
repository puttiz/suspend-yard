desc 'Print out all defined routes in match order, with names.'
task :routes => :environment do
  routes = ActionController::Routing::Routes.routes.collect do |route|
    name = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
    verb = route.conditions[:method].to_s.upcase
    segs = route.segments.inject("") { |str,s| str << s.to_s }
    reqs = route.requirements.empty? ? "" : route.requirements.inspect
    {:name => name, :verb => verb, :segs => segs, :reqs => reqs}
  end
  name_width = routes.collect {|r| r[:name]}.collect {|n| n.length}.max
  verb_width = routes.collect {|r| r[:verb]}.collect {|v| v.length}.max
  segs_width = routes.collect {|r| r[:segs]}.collect {|s| s.length}.max
  routes.each do |r|
    puts "#{r[:name].rjust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:segs].ljust(segs_width)} #{r[:reqs]}"
  end
end

desc 'Routes listed in a browser.'
task :routes_page => :environment do
  require 'erb'
  include ERB::Util
  @routes = ActionController::Routing::Routes.routes.collect do |route|
    name = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
    verb = route.conditions[:method].to_s.upcase
    segs = route.segments.inject("") { |str,s| str << s.to_s }
    reqs = route.requirements.inspect
    {:name => name, :verb => verb, :segs => segs, :reqs => reqs}
  end
  
  template = <<-END_ERB
<html><head><title>Rails Routes</title></head>
<body>
<table>
<% @routes.each do |r| %>
  <tr<%= r[:name] =~ /^formatted_/ ? ' style="color: gray"' : "" %>>
    <td style="padding-right: 1em" align="right"><%= h r[:name] %></td>
    <td style="padding-right: 1em"><%= h r[:verb] %></td>
    <td style="padding-right: 1em"><%= h r[:segs] %></td>
    <td><%= h r[:reqs] %></td>
  </tr>
<% end %>
</table>
</body></html>
END_ERB

  ERB.new(template).run(binding)

end
