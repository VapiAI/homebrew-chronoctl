#!/usr/bin/env ruby

require "digest"
require "fileutils"
require "open-uri"
require "open3"
require "rubygems/version"

UPSTREAM_GIT = "https://github.com/chronosphereio/chronoctl-core.git"
UPSTREAM_ARCHIVE = "https://github.com/chronosphereio/chronoctl-core/archive/refs/tags"
FORMULA_PATH = File.expand_path("../Formula/chronoctl.rb", __dir__)
VERSIONED_FORMULA_LIMIT = 4

def upstream_tags
  output, status = Open3.capture2("git", "ls-remote", "--tags", "--refs", UPSTREAM_GIT)
  abort "Unable to read upstream tags" unless status.success?

  output.each_line.each_with_object({}) do |line, tags|
    revision, ref = line.split
    match = ref&.match(%r{refs/tags/v(\d+\.\d+\.\d+)\z})
    tags[Gem::Version.new(match[1])] = revision if match
  end
end

def formula_version(contents)
  match = contents.match(%r{/v(\d+\.\d+\.\d+)\.tar\.gz"})
  abort "Unable to determine the current formula version" unless match

  Gem::Version.new(match[1])
end

def versioned_formula(contents, version)
  class_suffix = version.to_s.delete(".")
  result = contents.sub("class Chronoctl < Formula", "class ChronoctlAT#{class_suffix} < Formula")
  result.sub!(/^  head .*\n\n/, "")
  result.sub!(/\n  livecheck do\n.*?\n  end\n/m, "")
  unless result.include?("keg_only :versioned_formula")
    result.sub!(/(  license .*\n)/, "\\1\n  keg_only :versioned_formula\n")
  end
  result
end

tags = upstream_tags
target = ARGV.empty? ? tags.keys.max : Gem::Version.new(ARGV.fetch(0).delete_prefix("v"))
abort "Version v#{target} is not an upstream stable tag" unless tags.key?(target)

contents = File.read(FORMULA_PATH)
current = formula_version(contents)
if target == current
  puts "chronoctl is already current at v#{current}"
  exit
end
abort "Refusing to replace v#{current} with non-newer v#{target}" unless target > current

archive_url = "#{UPSTREAM_ARCHIVE}/v#{target}.tar.gz"
archive = URI.open(archive_url, "User-Agent" => "VapiAI-homebrew-chronoctl-updater", &:read)
checksum = Digest::SHA256.hexdigest(archive)
revision = tags.fetch(target)[0, 7]

old_path = File.join(File.dirname(FORMULA_PATH), "chronoctl@#{current}.rb")
File.write(old_path, versioned_formula(contents, current)) unless File.exist?(old_path)

contents.sub!(%r{^  url ".*"$}, %(  url "#{archive_url}"))
contents.sub!(/^  sha256 "[0-9a-f]{64}"$/, %(  sha256 "#{checksum}"))
contents.sub!(/^(      -X #\{build_package\}\.SHA=)[0-9a-f]+$/, "\\1#{revision}")
File.write(FORMULA_PATH, contents)

versioned_paths = Dir[File.join(File.dirname(FORMULA_PATH), "chronoctl@*.rb")]
versioned_paths.sort_by! { |path| formula_version(File.read(path)) }
versioned_paths.first([versioned_paths.length - VERSIONED_FORMULA_LIMIT, 0].max).each do |path|
  FileUtils.rm(path)
end

puts "Updated chronoctl from v#{current} to v#{target} (#{revision}, #{checksum})"
