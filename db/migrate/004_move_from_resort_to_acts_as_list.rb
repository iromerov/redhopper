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
class MoveFromResortToActsAsList < ActiveRecord::Migration[4.2]
  def up
    add_column :redhopper_issues, :position, :integer

    redhopper_issue = RedhopperIssue.where(first: true).first
    counter = 1
    while redhopper_issue.present?
      redhopper_issue.insert_at(counter)
      redhopper_issue = RedhopperIssue.find_by_id(redhopper_issue.next_id)
      counter += 1
    end

    remove_column :redhopper_issues, :next_id
    remove_column :redhopper_issues, :first
  end
end
