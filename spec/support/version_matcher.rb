# frozen_string_literal: true

class VersionMatcher
  attr_reader :spec

  def initialize(spec)
    @spec = Gem.loaded_specs[spec]
  end

  def matches?(version)
    requirement(version).satisfied_by? spec.version
  end

  def excludes?(version)
    !matches?(version)
  end

  def to_proc
    method(:excludes?).to_proc
  end

  private

  def requirement(version)
    return version unless version.is_a?(String)

    Gem::Requirement.create version.split(", ")
  end
end

RSpec.configure do |config|
  config.filter_run_excluding rack: VersionMatcher.new("rack").to_proc
end
