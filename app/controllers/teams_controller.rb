class TeamsController < ApplicationController
  before_filter :must_be_team_owner, only: :edit

  def index
    @catalog = Catalog.new

    render layout: 'empty-body'
  end

  def edit
    @team = current_team
  end
end
