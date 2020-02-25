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
require File.expand_path('../../test_helper', __FILE__)

class RedhopperIssuesControllerTest < ActionController::TestCase

  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :enabled_modules,
           :enumerations,
           :trackers,
           :projects_trackers

  def setup
    @first_kanban = RedhopperIssue.create! issue: Issue.find(1)
    @second_kanban = RedhopperIssue.create! issue: Issue.find(2)
    @third_kanban = RedhopperIssue.create! issue: Issue.find(3)
  end

  def test_create
    # Given
    requested_issue = Issue.find(4)
    # When
    assert_difference('RedhopperIssue.count', +1) do
      post :create, params: { issue_id: requested_issue.id }
    end
    # Then
    assert_redirected_to project_kanbans_path(requested_issue.project)
  end

  def test_button_move_in_first_place
    # Given
    # When
    get :move, params: { id: @second_kanban.id, target_id: @first_kanban.id }
    # Then
    assert_equal [1, 2], [@second_kanban, @first_kanban].map(&:reload).map(&:position)
    assert_redirected_to project_kanbans_path(@second_kanban.issue.project)
  end

  def test_button_move_up_in_second_place
    # Given
    # When
    get :move, params: { id: @third_kanban.id, target_id: @second_kanban.id }
    # Then
    assert_equal [1, 2, 3], [@first_kanban, @third_kanban, @second_kanban].map(&:reload).map(&:position)
    assert_redirected_to project_kanbans_path(@third_kanban.issue.project)
  end

  def test_button_move_down
    # Given
    # When
    get :move, params: { id: @first_kanban.id, target_id: @second_kanban.id }
    # Then
    assert_equal [1, 2], [@second_kanban, @first_kanban].map(&:reload).map(&:position)
    assert_redirected_to project_kanbans_path(@first_kanban.issue.project)
  end

  def test_drag_and_drop_move_in_first_place
    # Given
    # When
    get :move, params: { id: @second_kanban.id, target_id: @first_kanban.id, insert: "before" }
    # Then
    assert_equal [1, 2, 3], [@second_kanban, @first_kanban, @third_kanban].map(&:reload).map(&:position)
    assert_redirected_to project_kanbans_path(@second_kanban.issue.project)
  end

  def test_drag_and_drop_move_up_in_second_place
    # Given
    # When
    get :move, params: { id: @third_kanban.id, target_id: @first_kanban.id, insert: "after"}
    # Then
    assert_equal [1, 2, 3], [@first_kanban, @third_kanban, @second_kanban].map(&:reload).map(&:position)
    assert_redirected_to project_kanbans_path(@third_kanban.issue.project)
  end

  def test_drag_and_drop_move_down
    # Given
    # When
    get :move, params: { id: @first_kanban.id, target_id: @second_kanban.id, insert: "after" }
    # Then
    assert_equal [1, 2, 3], [@second_kanban, @first_kanban, @third_kanban].map(&:reload).map(&:position)
    assert_redirected_to project_kanbans_path(@first_kanban.issue.project)
  end

  def test_block
    # When
    get :block, params: { id: @first_kanban.id }
    # Then
    assert @first_kanban.reload.blocked?
    assert_redirected_to project_kanbans_path(@first_kanban.issue.project)
  end

  def test_unblock
    # Given
    blocked_issue = RedhopperIssue.create! issue: Issue.find(4), blocked: true
    # When
    get :unblock, params: { id: @first_kanban.id }
    # Then
    assert_not @first_kanban.reload.blocked?
    assert_redirected_to project_kanbans_path(@first_kanban.issue.project)
  end

  def test_delete
    # Given
    requested_issue = @first_kanban.issue
    # When
    assert_difference('RedhopperIssue.count', -1) do
      post :delete, params: { :id => @first_kanban }
    end
    # Then
    assert_redirected_to project_kanbans_path(requested_issue.project)
  end

end
