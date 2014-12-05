class AddBadgesToAlternativeDescriptionOfRepositories < ActiveRecord::Migration
  def up
    insert_description repo_name: "Upcase", description: <<-DESC.squish
      <li><a href="https://codeclimate.com/repos/509bdbd313d6373b2b001546/feed"><img src="https://codeclimate.com/repos/509bdbd313d6373b2b001546/badges/ca2720aded19a6da11e7/gpa.svg" /></a></li>
      <li><a href="https://codeclimate.com/repos/509bdbd313d6373b2b001546/feed"><img src="https://codeclimate.com/repos/509bdbd313d6373b2b001546/badges/ca2720aded19a6da11e7/coverage.svg" /></a></li>
    DESC

    insert_description repo_name: "Upcase Exercises", description: <<-DESC.squish
      <li><a href="https://codeclimate.com/repos/52f260c4e30ba0359e001874/feed"><img src="https://codeclimate.com/repos/52f260c4e30ba0359e001874/badges/5b5ac054ebd74d061e88/gpa.svg" /></a></li>
      <li><a href="https://codeclimate.com/repos/52f260c4e30ba0359e001874/feed"><img src="https://codeclimate.com/repos/52f260c4e30ba0359e001874/badges/5b5ac054ebd74d061e88/coverage.svg" /></a></li>
    DESC

    insert_description repo_name: "Payload", description: <<-DESC.squish
      <li><a href="https://codeclimate.com/repos/5480882ae30ba0437e0005bc/feed"><img src="https://codeclimate.com/repos/5480882ae30ba0437e0005bc/badges/29e75fbf220a48362716/gpa.svg" /></a></li>
      <li><a href="https://codeclimate.com/repos/5480882ae30ba0437e0005bc/feed"><img src="https://codeclimate.com/repos/5480882ae30ba0437e0005bc/badges/29e75fbf220a48362716/coverage.svg" /></a></li>
    DESC
  end

  private

  def insert_description(repo_name:, description:)
    insert <<-SQL.squish
      UPDATE products SET alternative_description = '#{description}'
        WHERE type = 'Repository' AND name = '#{repo_name}'
    SQL
  end
end
