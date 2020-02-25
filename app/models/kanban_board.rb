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
class KanbanBoard

	attr_reader :columns

	def initialize project
		@project = project
		@columns_by_status = {}

		@columns = statuses.map do |status|
			@columns_by_status[status] = Column.new status
		end

		project_issues = issues

		RedhopperIssue.where(issue: project_issues).includes(:issue).ordered.each do |redhopper_issue|
			issue = redhopper_issue.issue
			if issue_column = column_for_issue_status(issue.status)
				issue_column << redhopper_issue
			end
			project_issues.delete issue
		end

		project_issues.each do |issue|
			if issue_column = column_for_issue_status(issue.status)
				issue_column << RedhopperIssue.new(issue: issue)
			end
		end
	end

	private

	def column_for_issue_status status
		@columns_by_status[status]
	end

	def issues
		project_issues = Issue.visible(User.current, :project => @project)
		project_issues = project_issues.open if Feature.enabled("only_open_statuses")
		project_issues = project_issues.where(tracker_id: tracker_ids)

		project_issues.to_a
	end

	def tracker_ids
		trackers_to_remove = (Setting.plugin_redhopper && Setting.plugin_redhopper["hidden_tracker_ids"] || []).map(&:to_i)

		@project.trackers.ids - trackers_to_remove
	end

	def statuses
		result = IssueStatus.sorted
		result = result.where(is_closed: false) if Feature.enabled("only_open_statuses")

		necessary_statuse_ids = WorkflowTransition.where(tracker_id: tracker_ids, role_id: Role.ids).pluck(:old_status_id, :new_status_id).flatten.uniq
		result.where(id: necessary_statuse_ids)
	end

end
