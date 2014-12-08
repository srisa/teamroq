class InstallContribPackages < ActiveRecord::Migration
 def up
    enable_extension :pg_trgm
    enable_extension :unaccent
    enable_extension :fuzzystrmatch
    enable_extension :hstore
  end

  def down
    disable_extension :pg_trgm
    disable_extension :unaccent
    disable_extension :fuzzystrmatch
    disable_extension :hstore
  end
end
