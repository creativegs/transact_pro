require "transact_pro/version"

module TransactPro
  extend self

  def root
    @@root ||= Pathname.new(Gem::Specification.find_by_name("transact_pro").gem_dir)
  end
end
