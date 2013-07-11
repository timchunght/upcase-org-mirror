require 'spec_helper'

describe AccessTokenQuery do
  it { build_query.should be_a(Enumerable) }

  describe '#for_user' do
    it 'returns the last access token for a given user' do
      expected_user = create(:user)
      other_user = create(:user)
      expected_token =
        create(:oauth_access_token, resource_owner_id: expected_user.id)
      other_token =
        create(:oauth_access_token, resource_owner_id: other_user.id)

      expect(build_query.for_user(expected_user)).to eq expected_token
    end
  end

  describe '#for_discourse' do
    it 'returns tokens for Discourse' do
      discourse = create(
        :oauth_application,
        name: AccessTokenQuery::DISCOURSE_APPLICATION_NAME
      )
      not_discourse = create(:oauth_application, name: 'Not Discourse')
      discourse_token =
        create(:oauth_access_token, application_id: discourse.id)
      not_discourse_token =
        create(:oauth_access_token, application_id: not_discourse.id)

      query = build_query.for_discourse

      expect(query.first).to eq discourse_token
      expect(query).to be_a(AccessTokenQuery)
    end
  end

  describe '#each' do
    it 'delegates to its relation' do
      relation = %w(a b c)

      expect(build_query_for(relation).each.to_a).to eq relation
    end
  end

  def build_query
    build_query_for(Doorkeeper::AccessToken)
  end

  def build_query_for(relation)
    AccessTokenQuery.new(relation)
  end
end
