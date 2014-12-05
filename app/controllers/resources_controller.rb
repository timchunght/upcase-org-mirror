class ResourcesController < ApplicationController
  def index
    @topic = TopicsWithResources.new(
      topics: Topic.explorable,
      factory: TopicWithResourcesFactory.new(
        catalog: Catalog.new(user: current_user)
      )
    ).find(params[:topic_id])
    @trail = TrailWithProgress.new(@topic.trail, user: current_user)
    @resources = @topic.resources.group_by { |resource| resource.class.name }
  end
end
