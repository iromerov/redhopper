#
# Redhopper - Kanban boards for Redmine, inspired by Jira Agile (formerly known as
# Greenhopper), but following its own path.
# Copyright (C) 2015-2019 infoPiiaf <contact@infopiiaf.fr>
#
# This file is part of Redhopper.
#
# Redhopper is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Redhopper is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Redhopper.  If not, see <http://www.gnu.org/licenses/>.
#
source 'https://rubygems.org'

gem 'acts_as_list', '~> 0.9.17'
gem 'haml', '~> 5.1.1'

group :development do
	gem 'sass', '~> 3.4.15'
	# Not the latest version becaus of following issue
	# Bundler could not find compatible versions for gem "mime-types":
  # In Gemfile:
  #   copyright-header (~> 1.0.15) ruby depends on
  #     github-linguist (~> 2.6) ruby depends on
  #       mime-types (~> 1.19) ruby
	#
  #   mime-types (2.6.2)
	# Hence does not mamange .rake files :(
	gem 'copyright-header', '~> 1.0.8'
end

gem 'byebug', group: [:development, :test]

group :test do
  gem 'rails-controller-testing', '~> 1.0.4'
end
