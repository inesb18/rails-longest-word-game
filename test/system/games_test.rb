require 'application_system_test_case'

class GamesTest < ApplicationSystemTestCase
  test 'Going to /new gives us a new random grid to play with' do
    visit new_url
    assert_text 'New Game'
    assert_selector '.board-letter', count: 10
  end
  test ' Playing m gives us a message that M is not a word' do
    visit new_url
    fill_in 'word', with: 'm'
    click_on 'Play'
    assert_text 'does not seem to be a valid English word...'
  end
  test ' Playing appear gives us a message that M is not in the grid' do
    visit new_url
    fill_in 'word', with: 'appear'
    click_on 'Play'
    assert_text "can't be built out of"
  end
  test 'Playing a when the grid has one gives us a Congrats message' do
    visit new_url
    visit new_url until page.find('.board').has_content?('A')
    fill_in 'word', with: 'a'
    click_on 'Play'
    assert_text 'Congratulations'
  end
end
