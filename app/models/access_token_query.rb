# Allows querying of Doorkeeper access tokens without reopening the class.
class AccessTokenQuery
  DISCOURSE_APPLICATION_NAME = 'Discourse'

  include Enumerable

  def initialize(relation)
    @relation = relation
  end

  def for_user(user)
    @relation.where(resource_owner_id: user.id).last
  end

  def for_discourse
    self.class.new @relation.where(application_id: discourse.id)
  end

  def each(&block)
    @relation.each(&block)
  end

  private

  def discourse
    Doorkeeper::Application.where(name: DISCOURSE_APPLICATION_NAME).first!
  end
end
