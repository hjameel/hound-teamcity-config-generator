#!/usr/bin/env ruby
require 'faraday'
require 'json'

teamcity_hosts=File.readlines('serverlist').each{|server| server.chop!}
config_body = { 'dbpath' => '../Hound-data', 'repos' => {} }

teamcity_hosts.each do |teamcity_host|
  roots = JSON.parse((Faraday.get "http://#{teamcity_host}/guestAuth/app/rest/vcs-roots", {}, {'Accept' => 'application/json'}).body)

  roots['vcs-root'].each do |root|
    root_info = JSON.parse((Faraday.get "http://#{teamcity_host}#{root['href']}", {}, {'Accept' => 'application/json'}).body)

    teamcity8_archived = (root_info['project'] && root_info['project']['archived'])
    teamcity7_archived = (root_info['status'] == 'NOT_MONITORED')
    if (teamcity7_archived || teamcity8_archived)
      next
    end

    name = root_info['project'] ? root_info['project']['name'] : root_info['name']
    git_url = (root_info['properties']['property'].select { |p| p['name'] == 'url' })[0]['value']

    repo_already_added = (config_body['repos'].select { |key, repo| repo['url'] == git_url }).empty?

    if (!repo_already_added)
      next
    end

    config_body['repos'][name] = {'url' => git_url}
  end
end

puts JSON.pretty_generate(config_body)
